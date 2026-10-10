-- ============================================================
-- AIOS · MIGRACIÓN del núcleo comercial v1 → v2
--
-- Solo se aplica en instancias que YA corrieron la primera versión de
-- 05-comercial.sql. Una instancia nueva aplica 05 directo y salta esto.
--
-- Es idempotente y no destruye datos: agrega columnas, rellena el sujeto
-- desde la oportunidad conocida y libera la restricción que impedía
-- registrar eventos anteriores a la oportunidad.
-- ============================================================

begin;

-- El ledger es inmutable por trigger. Para migrar hay que desarmarlo y
-- volverlo a armar dentro de la MISMA transacción: si algo falla, el
-- rollback deja el candado puesto.
alter table evento_comercial disable trigger tg_evento_comercial_inmutable;

-- 1 · El evento deja de depender de que exista una oportunidad.
alter table evento_comercial add column if not exists subject_type text;
alter table evento_comercial add column if not exists subject_id uuid;

update evento_comercial
   set subject_type = coalesce(subject_type, 'oportunidad'),
       subject_id   = coalesce(subject_id, oportunidad_id)
 where subject_type is null or subject_id is null;

alter table evento_comercial alter column subject_type set not null;
alter table evento_comercial alter column subject_id   set not null;
alter table evento_comercial alter column oportunidad_id drop not null;

do $$ begin
  alter table evento_comercial add constraint evento_subject_type_valido
    check (subject_type in ('entidad','identidad','touchpoint','oportunidad','actividad','conversacion'));
exception when duplicate_object then null; end $$;

-- 2 · El valor vive en el evento y nunca entra sin confianza declarada.
alter table evento_comercial add column if not exists valor_estimado  numeric(14,2);
alter table evento_comercial add column if not exists valor_moneda    text not null default 'MXN';
alter table evento_comercial add column if not exists valor_confianza text;
alter table evento_comercial add column if not exists etapa_anterior  text references etapa_comercial_def(codigo);
alter table evento_comercial add column if not exists causa           text;

do $$ begin
  alter table evento_comercial add constraint evento_valor_confianza_valida
    check (valor_confianza is null or valor_confianza in ('declarado','inferido','mediana_etapa'));
exception when duplicate_object then null; end $$;

do $$ begin
  alter table evento_comercial add constraint evento_valor_con_confianza
    check ((valor_estimado is null and valor_confianza is null)
        or (valor_estimado is not null and valor_confianza is not null));
exception when duplicate_object then null; end $$;

-- 3 · Ruta de corrección para un ledger inmutable.
alter table evento_comercial add column if not exists compensa_evento_id uuid references evento_comercial(id);

do $$ begin
  alter table evento_comercial add constraint evento_compensacion_no_circular
    check (compensa_evento_id is null or compensa_evento_id <> id);
exception when duplicate_object then null; end $$;

create index if not exists ix_evento_comercial_subject on evento_comercial(subject_type, subject_id, ocurrido_en desc);
create index if not exists ix_evento_compensado on evento_comercial(compensa_evento_id)
  where compensa_evento_id is not null;

alter table evento_comercial enable trigger tg_evento_comercial_inmutable;

-- 4 · La oportunidad declara la confianza de su monto.
alter table oportunidad add column if not exists valor_confianza text;
do $$ begin
  alter table oportunidad add constraint oportunidad_valor_con_confianza
    check ((valor_estimado is null and valor_confianza is null)
        or (valor_estimado is not null and valor_confianza is not null));
exception when duplicate_object then null; end $$;

-- 5 · Insertar una etapa intermedia deja de exigir renumerar el proceso.
alter table etapa_comercial_def drop constraint if exists etapa_comercial_def_orden_key;
alter table etapa_comercial_def alter column orden type numeric(8,3);
alter table etapa_comercial_def add column if not exists zona text not null default 'comercial';
alter table etapa_comercial_def add column if not exists exige_causa boolean not null default false;
create index if not exists ix_etapa_orden on etapa_comercial_def(orden) where activa;

-- 6 · La actividad que escribe un cron necesita el mismo candado que el evento.
alter table actividad_comercial add column if not exists clave_idempotencia text;
do $$ begin
  alter table actividad_comercial add constraint actividad_clave_idempotencia_key unique (clave_idempotencia);
exception when duplicate_object then null; end $$;

-- 7 · La calidad del dato se mide por rama, no solo por sistema.
alter table data_quality_observation add column if not exists segmento text not null default 'global';
alter table data_quality_observation add column if not exists universo_esperado  integer;
alter table data_quality_observation add column if not exists universo_observado integer;
create index if not exists ix_dq_fuente_segmento
  on data_quality_observation(fuente_sistema, segmento, dimension, medido_en desc);

commit;

-- Las tablas nuevas de v2 (experimento, asignacion_experimento, bloqueo_externo)
-- se crean corriendo 05-comercial.sql de nuevo: todas sus sentencias son
-- `create table if not exists` y no tocan lo que ya existe.

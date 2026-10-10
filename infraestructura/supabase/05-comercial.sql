-- ============================================================
-- AIOS · NÚCLEO COMERCIAL ADAPTATIVO
-- Esquema comercial base para una instancia aislada; una instancia nueva lo aplica directamente.
-- Las etapas se configuran por instancia; no se fijan al modelo clínico.
--
-- Tres reglas que este esquema hace cumplir, no solo declarar:
--   1. La captura nunca depende de una decisión de negocio.
--      Un evento se registra aunque todavía no exista una oportunidad.
--   2. Un valor sin confianza declarada no entra.
--      Contar leads y contar dinero dan conclusiones opuestas.
--   3. Toda intervención medible deja asignación reconstruible.
--      Sin brazo de control registrado no hay causalidad, solo relato.
-- ============================================================

-- Una persona u organización puede aparecer mediante varias identidades.
create table if not exists entidad_comercial (
  id              uuid primary key default gen_random_uuid(),
  tipo            text not null check (tipo in ('persona','organizacion')),
  nombre           text,
  creado_en        timestamptz not null default now(),
  actualizado_en   timestamptz not null default now()
);

create table if not exists identidad_canal (
  id                uuid primary key default gen_random_uuid(),
  entidad_id         uuid not null references entidad_comercial(id) on delete cascade,
  canal              text not null,
  identificador      text not null,
  confirmada         boolean not null default false,
  fuente_sistema     text not null,
  creado_en          timestamptz not null default now(),
  unique (canal, identificador, fuente_sistema)
);
create index if not exists ix_identidad_entidad on identidad_canal(entidad_id);

-- Marketing y atribución. Un touchpoint puede existir antes de conocer la identidad.
create table if not exists touchpoint (
  id                uuid primary key default gen_random_uuid(),
  entidad_id         uuid references entidad_comercial(id) on delete set null,
  canal              text not null,
  fuente             text,
  campana            text,
  conjunto           text,
  anuncio            text,
  creativo           text,
  contenido          text,
  external_click_id  text,
  ocurrido_en        timestamptz not null default now(),
  meta               jsonb not null default '{}'::jsonb
);
create index if not exists ix_touchpoint_entidad on touchpoint(entidad_id, ocurrido_en desc);
create index if not exists ix_touchpoint_click on touchpoint(external_click_id)
  where external_click_id is not null;

-- El catálogo permite que cada instancia defina su proceso sin migrar enums.
-- `orden` es numeric y NO es único: insertar una etapa intermedia (3.5) no debe
-- obligar a renumerar el proceso entero dentro de una sola transacción.
create table if not exists etapa_comercial_def (
  codigo              text primary key,
  nombre              text not null,
  orden               numeric(8,3) not null,
  zona                text not null default 'comercial' check (zona in ('marketing','comercial','entrega')),
  terminal            boolean not null default false,
  exige_causa         boolean not null default false,
  evidencia_requerida text,
  activa              boolean not null default true
);
create index if not exists ix_etapa_orden on etapa_comercial_def(orden) where activa;

create table if not exists oportunidad (
  id                uuid primary key default gen_random_uuid(),
  entidad_id         uuid not null references entidad_comercial(id) on delete restrict,
  oferta_codigo      text,
  moneda             text not null default 'MXN',
  valor_estimado     numeric(14,2),
  -- Confianza del MONTO. No es lo mismo que la probabilidad de cierre:
  -- un lead que declaró 100 unidades y otro al que se le imputó la mediana
  -- pueden tener idéntica probabilidad y confianza de valor opuesta.
  valor_confianza    text check (valor_confianza in ('declarado','inferido','mediana_etapa')),
  probabilidad       numeric(5,4) check (probabilidad between 0 and 1),
  responsable        text,
  siguiente_paso     text,
  siguiente_paso_en  timestamptz,
  creada_en          timestamptz not null default now(),
  actualizada_en     timestamptz not null default now(),
  constraint oportunidad_valor_con_confianza check (
    (valor_estimado is null and valor_confianza is null)
    or (valor_estimado is not null and valor_confianza is not null)
  )
);
create index if not exists ix_oportunidad_responsable on oportunidad(responsable, siguiente_paso_en);

-- ── EXPERIMENTOS · la asignación es dato, no un campo de texto en un YAML ──
-- Un experimento cuyo brazo no se puede reconstruir a posteriori no es
-- auditable: cualquiera edita el archivo y la evidencia desaparece.
create table if not exists experimento (
  id                   uuid primary key default gen_random_uuid(),
  codigo               text not null unique,
  hipotesis            text not null,
  variable_principal   text not null,
  metrica_primaria     text not null,
  metricas_guardrail   text[] not null default '{}',
  muestra_minima       integer,
  duracion_minima_dias integer,
  estado               text not null default 'borrador'
                       check (estado in ('borrador','activo','concluido','revertido')),
  iniciado_en          timestamptz,
  concluido_en         timestamptz,
  decision             text check (decision in ('mantener','iterar','revertir')),
  creado_en            timestamptz not null default now()
);

create table if not exists asignacion_experimento (
  id             uuid primary key default gen_random_uuid(),
  experimento_id uuid not null references experimento(id) on delete cascade,
  subject_type   text not null,
  subject_id     uuid not null,
  brazo          text not null check (brazo in ('control','tratamiento')),
  metodo         text not null,              -- p.ej. 'fnv1a_mod100'
  bucket         integer check (bucket between 0 and 99),
  asignado_en    timestamptz not null default now(),
  unique (experimento_id, subject_type, subject_id)
);
create index if not exists ix_asignacion_brazo on asignacion_experimento(experimento_id, brazo);

-- ── LEDGER · fuente histórica universal ──
-- `subject_*` es el sujeto real del evento. `oportunidad_id` es una PROYECCIÓN
-- opcional: touchpoint_created, lead_created, message_received y el propio
-- opportunity_created ocurren ANTES de que exista una oportunidad. Exigirla
-- colgaría la captura de una decisión de negocio — la falla más cara del
-- modelo anterior y la que este framework existe para impedir.
create table if not exists evento_comercial (
  id                uuid primary key default gen_random_uuid(),
  subject_type      text not null check (subject_type in
                      ('entidad','identidad','touchpoint','oportunidad','actividad','conversacion')),
  subject_id        uuid not null,
  oportunidad_id    uuid references oportunidad(id) on delete cascade,
  tipo_evento       text not null,
  etapa_codigo      text references etapa_comercial_def(codigo),
  etapa_anterior    text references etapa_comercial_def(codigo),
  causa             text,
  actor_tipo        text check (actor_tipo in ('contacto','agente','humano','sistema')),
  actor_id          text,
  fuente_sistema    text not null,
  fuente_evento_id  text not null,
  evidencia_ref     text,
  regla_version     text,
  -- El valor vive en el evento, no solo en la oportunidad: si únicamente
  -- vive en un campo mutable, un lead que dijo 100 y bajó a 12 pierde su
  -- historia, que es exactamente lo que el ledger existe para conservar.
  valor_estimado    numeric(14,2),
  valor_moneda      text not null default 'MXN',
  valor_confianza   text check (valor_confianza in ('declarado','inferido','mediana_etapa')),
  -- Ruta de corrección: el ledger es inmutable, así que un error se repara
  -- con un evento que apunta al que corrige. Sin este vínculo la proyección
  -- no sabe cuál ignorar y el dato malo se vuelve inmortal.
  compensa_evento_id uuid references evento_comercial(id),
  ocurrido_en       timestamptz not null,
  registrado_en     timestamptz not null default now(),
  meta              jsonb not null default '{}'::jsonb,
  unique (fuente_sistema, fuente_evento_id),
  constraint evento_valor_con_confianza check (
    (valor_estimado is null and valor_confianza is null)
    or (valor_estimado is not null and valor_confianza is not null)
  ),
  constraint evento_compensacion_no_circular check (
    compensa_evento_id is null or compensa_evento_id <> id
  )
);
create index if not exists ix_evento_comercial_subject on evento_comercial(subject_type, subject_id, ocurrido_en desc);
create index if not exists ix_evento_comercial_opp on evento_comercial(oportunidad_id, ocurrido_en desc)
  where oportunidad_id is not null;
create index if not exists ix_evento_comercial_tipo on evento_comercial(tipo_evento, ocurrido_en desc);
create index if not exists ix_evento_compensado on evento_comercial(compensa_evento_id)
  where compensa_evento_id is not null;

-- Un estado terminal sin causa no explica nada. Qué etapas la exigen lo
-- decide la instancia en etapa_comercial_def, no un enum del core.
create or replace function exigir_causa_comercial() returns trigger
language plpgsql as $$
declare
  requiere boolean;
begin
  if new.etapa_codigo is null then
    return new;
  end if;
  select exige_causa into requiere from etapa_comercial_def where codigo = new.etapa_codigo;
  if coalesce(requiere, false) and coalesce(btrim(new.causa), '') = '' then
    raise exception 'la etapa % exige causa: sin ella la fuga no se puede explicar', new.etapa_codigo;
  end if;
  return new;
end $$;

drop trigger if exists tg_exigir_causa_comercial on evento_comercial;
create trigger tg_exigir_causa_comercial before insert on evento_comercial
  for each row execute function exigir_causa_comercial();

create table if not exists actividad_comercial (
  id                uuid primary key default gen_random_uuid(),
  oportunidad_id    uuid not null references oportunidad(id) on delete cascade,
  tipo              text not null,
  estado            text not null check (estado in ('pendiente','completada','cancelada','fallida')),
  responsable       text,
  vence_en          timestamptz,
  completada_en     timestamptz,
  regla_version     text,
  -- Es la tabla que escribe un cron. Sin candado, un reintento horario
  -- duplica seguimientos sobre personas reales.
  clave_idempotencia text unique,
  creado_en         timestamptz not null default now(),
  meta              jsonb not null default '{}'::jsonb
);
create index if not exists ix_actividad_pendiente on actividad_comercial(vence_en)
  where estado = 'pendiente';

-- Recomendaciones y aprobaciones: la IA no se confunde con autoridad.
create table if not exists decision_comercial (
  id                uuid primary key default gen_random_uuid(),
  oportunidad_id    uuid references oportunidad(id) on delete cascade,
  tipo              text not null,
  recomendacion     text not null,
  evidencia         jsonb not null default '[]'::jsonb,
  calidad_evidencia jsonb not null default '{}'::jsonb,
  nivel_autoridad   text not null check (nivel_autoridad in ('automatico','asistido','aprobacion','humano')),
  estado            text not null default 'propuesta' check (estado in ('propuesta','aprobada','rechazada','ejecutada','revertida')),
  aprobada_por      text,
  aprobada_en       timestamptz,
  creada_en         timestamptz not null default now()
);

-- Calidad del dato es una dimensión observable, no una nota escondida.
-- `segmento` es obligatorio en la práctica: dos ramas del MISMO sistema
-- pueden tener cobertura 1.0 y 0.05. Medir solo por fuente las promedia
-- y esconde justo el hueco que esta tabla existe para encontrar.
create table if not exists data_quality_observation (
  id                uuid primary key default gen_random_uuid(),
  fuente_sistema    text not null,
  segmento          text not null default 'global',
  dimension         text not null check (dimension in ('coverage','completeness','consistency','freshness','uniqueness','lineage')),
  score             numeric(5,4) check (score between 0 and 1),
  universo_esperado integer,
  universo_observado integer,
  detalle           text,
  medido_en         timestamptz not null default now(),
  meta              jsonb not null default '{}'::jsonb
);
create index if not exists ix_dq_fuente_segmento on data_quality_observation(fuente_sistema, segmento, dimension, medido_en desc);

-- ── BLOQUEOS EXTERNOS · lo detenido tiene dueño, reloj y costo ──
-- Separa "no se entregó" de "no se desbloqueó". Sin esto, un motor
-- apagado 44 días por una decisión del cliente se reporta como "en curso".
create table if not exists bloqueo_externo (
  id               uuid primary key default gen_random_uuid(),
  descripcion      text not null,
  impacto          text not null,
  dueno            text not null,
  organizacion     text not null default 'cliente' check (organizacion in ('cliente','azxion','tercero')),
  solicitado_en    date not null,
  compromiso_en    date,
  resuelto_en      date,
  valor_expuesto   numeric(14,2),
  valor_confianza  text check (valor_confianza in ('declarado','inferido','mediana_etapa')),
  creado_en        timestamptz not null default now(),
  constraint bloqueo_valor_con_confianza check (
    (valor_expuesto is null and valor_confianza is null)
    or (valor_expuesto is not null and valor_confianza is not null)
  )
);

create or replace view bloqueo_abierto as
  select id, descripcion, impacto, dueno, organizacion, solicitado_en, compromiso_en,
         (current_date - solicitado_en) as dias_abierto,
         valor_expuesto, valor_confianza
    from bloqueo_externo
   where resuelto_en is null
   order by solicitado_en;

-- El comentario no basta: se impide modificar/borrar el ledger desde roles normales.
create or replace function evento_comercial_inmutable() returns trigger
language plpgsql as $$
begin
  raise exception 'evento_comercial es append-only; inserta un evento compensatorio con compensa_evento_id';
end $$;

drop trigger if exists tg_evento_comercial_inmutable on evento_comercial;
create trigger tg_evento_comercial_inmutable
  before update or delete on evento_comercial
  for each row execute function evento_comercial_inmutable();

-- Una asignación que cambia después del hecho invalida el experimento entero.
create or replace function asignacion_inmutable() returns trigger
language plpgsql as $$
begin
  raise exception 'asignacion_experimento es inmutable: reasignar destruye la comparabilidad del experimento';
end $$;

drop trigger if exists tg_asignacion_inmutable on asignacion_experimento;
create trigger tg_asignacion_inmutable
  before update or delete on asignacion_experimento
  for each row execute function asignacion_inmutable();

alter table entidad_comercial        enable row level security;
alter table identidad_canal          enable row level security;
alter table touchpoint                enable row level security;
alter table etapa_comercial_def       enable row level security;
alter table oportunidad               enable row level security;
alter table experimento               enable row level security;
alter table asignacion_experimento    enable row level security;
alter table evento_comercial          enable row level security;
alter table actividad_comercial       enable row level security;
alter table decision_comercial        enable row level security;
alter table data_quality_observation  enable row level security;
alter table bloqueo_externo           enable row level security;

-- Las políticas y roles se crean por instancia con privilegio mínimo.

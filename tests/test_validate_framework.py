import subprocess
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "scripts" / "validate_framework.py"


def run(*args):
    return subprocess.run([sys.executable, str(SCRIPT), "--root", str(ROOT), *args], text=True, capture_output=True)


class ValidatorTests(unittest.TestCase):
    def test_template_is_valid(self):
        result = run()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_template_is_not_a_ready_instance(self):
        result = run("--instancia")
        self.assertEqual(result.returncode, 1)
        self.assertTrue("sin llenar" in result.stdout or "unknown" in result.stdout)


if __name__ == "__main__":
    unittest.main()

#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_omni_plug info
PYTHONPATH=src python -m gbt_omni_plug check --payload '{}'
PYTHONPATH=src python -m gbt_omni_plug run   --payload '{}'

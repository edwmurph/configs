#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONFIG_PATH="${1:-"${REPO_DIR}/macos/default-apps.json"}"

osascript -l JavaScript "${SCRIPT_DIR}/apply-default-apps.jxa" "${CONFIG_PATH}"

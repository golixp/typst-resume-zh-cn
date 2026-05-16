#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "script/pr.sh is deprecated; forwarding to script/typst-package-pr.sh." >&2
exec "$SCRIPT_DIR/typst-package-pr.sh" "$@"

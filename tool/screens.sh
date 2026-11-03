#!/usr/bin/env bash
# Renders every screen and the component sheet to build/screens/ for design
# review against docs/design-system.md. Uses the real bundled fonts.
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf build/screens
RAKUBA_SCREENS=1 flutter test test/widgets "$@"
echo "Screens written to build/screens/"

#!/bin/bash
# The pour checks prove something only because the runner *can't* build the formula: the macos-15
# image installs Xcode 26 but selects 16.4, and the formula needs Swift 6.2. If the image ever
# starts selecting Xcode 26 by default, a successful install stops proving a pour — so say so and
# fail, rather than go on passing without meaning anything.
set -euo pipefail

selected="$(xcode-select -p)"
echo "Selected developer directory: $selected"
case "$selected" in
  *Xcode_26*)
    echo "This runner now selects Xcode 26, so it could build the formula and an install here" >&2
    echo "no longer proves a pour. Point this check at a runner that can't build it." >&2
    exit 1
    ;;
esac

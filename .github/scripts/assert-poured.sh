#!/bin/bash
# Asserts that a `brew install` log shows a bottle being poured and nothing being built.
#
# Presence alone isn't enough: on a runner whose Xcode can build the formula, a failed pour could
# fall back to a source build and still end in "installed". So this also asserts the absence of a
# build, which is what makes "it installed" mean "it poured".
set -euo pipefail

log="$1"

if ! grep -q 'Pouring marsdawn' "$log"; then
  echo "No 'Pouring marsdawn' line: the bottle was not poured." >&2
  exit 1
fi

if grep -Eqi 'swift build|from source' "$log"; then
  echo "The log shows a source build, so this install did not come from the bottle:" >&2
  grep -Ein 'swift build|from source' "$log" >&2
  exit 1
fi

echo "Poured, and nothing was built: $(grep -m1 'Pouring marsdawn' "$log")"

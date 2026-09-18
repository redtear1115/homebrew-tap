#!/bin/bash
# Exports a document that exercises every part of the renderer with the installed marsdawn,
# outside `brew test`'s sandbox (which denies the Mach lookups WebKit needs, see issue #2).
# MARSDAWN_APP_PATH points nowhere, so this also proves export needs no MarsDawn app.
set -euo pipefail

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cd "$work"

cat > doc.md <<'MARKDOWN'
# Install check

Inline math $E=mc^2$ and a display block:

$$
\int_0^1 x\,dx
$$

![A blocked web image](https://example.com/cat.png)

```mermaid
graph TD; Start-->Finish
```

```swift
let answer = 42
```
MARKDOWN

status=0
result="$(MARSDAWN_APP_PATH=/nonexistent marsdawn export doc.md -o out.pdf --json)" || status=$?
echo "$result"
if [ "$status" -ne 0 ]; then
  echo "marsdawn export exited with $status" >&2
  exit 1
fi

ruby -rjson -e '
  r = JSON.parse(ARGV[0])
  abort "export did not report ok" unless r["ok"] == true
  abort "expected at least one page, got #{r["pages"].inspect}" unless r["pages"].to_i >= 1
  abort "diagram errors: #{r["diagramErrors"].inspect}" unless r["diagramErrors"] == []
' "$result"

header="$(head -c 5 out.pdf)"
if [ "$header" != "%PDF-" ]; then
  echo "out.pdf does not start with %PDF- (got: $header)" >&2
  exit 1
fi

echo "Export check passed: $(wc -c < out.pdf | tr -d ' ') bytes."

#!/bin/bash
# Exports a document that exercises every part of the renderer with the installed marsdawn,
# outside `brew test`'s sandbox (which denies the Mach lookups WebKit needs, see issue #2).
# MARSDAWN_APP_PATH points nowhere, so this also proves export needs no MarsDawn app.
set -euo pipefail

scripts="$(cd "$(dirname "$0")" && pwd)"
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

# A PDF header and a JSON "ok" are true of a blank page too. Read the text layer back and look
# for words that can only be there if the document actually rendered: the heading, and a line
# from the code block.
text="$(swift "$scripts/pdf-text.swift" out.pdf)"
for expected in "Install check" "answer"; do
  if ! grep -qF "$expected" <<<"$text"; then
    echo "The PDF's text doesn't contain \"$expected\". What it does contain:" >&2
    echo "$text" >&2
    exit 1
  fi
done

echo "Export check passed: $(wc -c < out.pdf | tr -d ' ') bytes, and its text contains the heading and the code."

# redtear1115/homebrew-tap

Homebrew formulae for [MarsDawn](https://marsdawn.southern-light.dev).

```sh
brew tap redtear1115/tap
brew install marsdawn
```

**The tool needs macOS 15 or later; the MarsDawn app needs macOS 26.** They are deliberately
different: the command-line tool is for developers and agents and should run on more machines than
the app does. Installing the tool builds it from source, so expect a few minutes' compile and
Xcode 26 on the machine.

## What's here

**`marsdawn`** — the free command-line tool from
[`mars-dawn-kit`](https://github.com/redtear1115/mars-dawn-kit), Apache-2.0.

- `marsdawn export doc.md -o doc.pdf` renders Markdown to PDF on its own. It needs nothing else
  installed: the same renderer the app uses lives in the open-source package.
- `marsdawn open doc.md:120` opens a document in the MarsDawn app and lands on line 120. That one
  needs the app.

## Why there is no cask

The MarsDawn app ships only through the Mac App Store, and
[Homebrew Cask doesn't accept](https://docs.brew.sh/Acceptable-Casks) an app whose full version is
distributed that way. So this tap carries the command-line tool only, and the app stays on the
store.

## Requirements

| | Needs |
|---|---|
| `marsdawn` (this tap) | macOS 15 or later, and Xcode 26 to build it |
| MarsDawn (the app) | macOS 26, from the Mac App Store |

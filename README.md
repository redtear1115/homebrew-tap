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
- `marsdawn open doc.md` opens a document in the MarsDawn app. That one needs the app.
  `marsdawn open doc.md:120` also passes line 120 along. The current app opens the document but
  doesn't jump to the line yet; that comes in a later app update.

## Why there is no cask

The MarsDawn app ships only through the Mac App Store and has no direct download, so there is
nothing a cask could install (see Homebrew's [Acceptable Casks](https://docs.brew.sh/Acceptable-Casks)).
This tap carries the command-line tool only, and the app stays on the store.

## Requirements

| | Needs |
|---|---|
| `marsdawn` (this tap) | macOS 15 or later, and Xcode 26 to build it |
| MarsDawn (the app) | macOS 26, from the Mac App Store |

## Install check

[`install-check.yml`](.github/workflows/install-check.yml) installs `marsdawn` from this tap on a
macOS runner and exports a real PDF. `brew test` can't do that inside Homebrew's sandbox (#2). It
runs on every pull request, weekly, and on demand.

GitHub turns off scheduled workflows in a public repository after 60 days without activity, so the
weekly run stops on its own if the tap is quiet for two months. Check it on every release:

```sh
gh workflow list --all --repo redtear1115/homebrew-tap               # "disabled_inactivity" means it stopped
gh workflow enable install-check.yml --repo redtear1115/homebrew-tap  # turns it back on
gh workflow run install-check.yml --repo redtear1115/homebrew-tap     # runs it now
```

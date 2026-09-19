# Contributing

This is the Homebrew tap for the `marsdawn` command-line tool: the formula, its bottles, and the
workflows that build, install-check and publish them. It's the right place for problems installing
`marsdawn` through Homebrew, or with the formula itself.

## What goes elsewhere

- Anything about what `marsdawn` actually does — rendering, PDF export, CLI behaviour, bugs in the
  tool once it's installed — [mars-dawn-kit](https://github.com/redtear1115/mars-dawn-kit). This
  tap only packages that project's releases; it doesn't change how the tool works.
- Questions or feedback about the MarsDawn Mac app itself —
  [mars-dawn-website/discussions](https://github.com/redtear1115/mars-dawn-website/discussions).

## The formula's version isn't hand-edited here

`Formula/marsdawn.rb`'s `url` and `sha256` track a tagged release of mars-dawn-kit, and the bottle
comes from that repo's release build via `publish.yml` (`brew pr-pull`). A version bump is a
release event, not something to send as an unprompted PR against a version that isn't out yet.

## Build and test locally

```sh
brew install --build-from-source redtear1115/tap/marsdawn
brew test redtear1115/tap/marsdawn
brew audit --strict --online redtear1115/tap/marsdawn
```

`brew test` can't export a real PDF — its sandbox denies the Mach lookups WebKit needs — so it only
covers `--version`, argument checks and the JSON error contract. CI's `install-check.yml` and
`tests.yml` (`brew test-bot`) cover the rest: a real install from source, a real PDF export, and
pouring the built bottle on runners that can't build it.

## Issues and pull requests

Keep pull requests small and focused — most changes here touch the formula, a workflow, or one of
the `.github/scripts/` helpers, not several at once. Describe what changed and why. CI (`test-bot`,
`pour-check`, `refuses-without-xcode-26`, and `install-check` on pull requests) has to be green.

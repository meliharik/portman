# Homebrew Cask

This directory contains the [Homebrew Cask](https://github.com/Homebrew/homebrew-cask) formula for portman.

## How users install via Homebrew

```sh
brew tap meliharik/portman
brew install --cask portman
```

The tap maps to a separate repository named `homebrew-portman` (Homebrew prefixes tap repos with `homebrew-`). To set that up, see [Setting up the tap](#setting-up-the-tap) below.

## Setting up the tap (one-time, maintainer only)

1. Create a new public repository on GitHub named **`homebrew-portman`** under the same account (`meliharik/homebrew-portman`).
2. In that repo, create a `Casks/` directory and copy `portman.rb` from this folder into it.
3. Commit and push.

That's all. From then on, `brew tap meliharik/portman && brew install --cask portman` works for everyone.

## Updating the formula on each release

After publishing a new GitHub Release with a DMG attached:

1. Bump the `version` in `Casks/portman.rb`.
2. Replace `sha256 :no_check` with the actual SHA-256 of the DMG (taken from the `.sha256` file the release workflow uploads).
3. Copy the updated formula into the `homebrew-portman` tap repo and commit there.

The release workflow could be extended to push these updates automatically — see [`docs/automating-the-tap.md`](../docs/automating-the-tap.md) once that exists.

## Why `sha256 :no_check`?

Until the first signed release exists, the SHA cannot be hard-coded. Once `v0.1.0` ships, replace the line with the real digest, e.g.:

```ruby
sha256 "abc123...def456"
```

`livecheck` is configured so that `brew livecheck portman` reports new versions as soon as they're tagged on GitHub.

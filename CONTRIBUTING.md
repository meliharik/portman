# Contributing to portman

Thanks for your interest in contributing! This document covers the workflow, coding conventions, and how to get a pull request merged.

By participating in this project you agree to abide by the [Code of Conduct](CODE_OF_CONDUCT.md).

## Quick links

- [Reporting a bug](#reporting-a-bug)
- [Requesting a feature](#requesting-a-feature)
- [Asking a question](#asking-a-question)
- [Setting up the project](#setting-up-the-project)
- [Submitting a pull request](#submitting-a-pull-request)
- [Coding style](#coding-style)
- [Commit messages](#commit-messages)

## Reporting a bug

Please use the **Bug Report** issue template:
[https://github.com/meliharik/portman/issues/new?template=bug_report.yml](https://github.com/meliharik/portman/issues/new?template=bug_report.yml)

Before opening:

1. Search [existing issues](https://github.com/meliharik/portman/issues?q=is%3Aissue) to make sure it isn't already reported.
2. Make sure you're on the latest release.
3. Try to reproduce on a clean account if it might be configuration-specific.

Include:

- macOS version (`sw_vers`)
- portman version (Settings → Version)
- Exact steps to reproduce
- Expected vs actual behavior
- Console output if any (Console.app, filter for `portman`)

## Requesting a feature

Use the **Feature Request** issue template:
[https://github.com/meliharik/portman/issues/new?template=feature_request.yml](https://github.com/meliharik/portman/issues/new?template=feature_request.yml)

A good feature request describes:

- The problem you're trying to solve (not just the solution).
- What you've tried so far.
- A rough sketch of how the feature would work in the UI.

## Asking a question

For general questions, please use [GitHub Discussions](https://github.com/meliharik/portman/discussions) rather than the issue tracker. Issues are reserved for actionable bug reports and feature requests.

## Setting up the project

### Prerequisites

- macOS 15.0 (Sequoia) or later
- Xcode 16 or later
- Git

### First build

```sh
git clone https://github.com/meliharik/portman.git
cd portman
open portman.xcodeproj
```

In Xcode, press **⌘R** to build and run. The menu bar icon should appear within a couple of seconds.

### Project layout

```
portman/
├── portmanApp.swift        Scene definitions (MenuBarExtra + Welcome window)
├── PortListView.swift      Popover content (list, header, search)
├── PortRow.swift           Single row in the list
├── PortStore.swift         Observable store, auto-refresh timer
├── PortScanner.swift       lsof runner + parser
├── ProcessKiller.swift     POSIX kill(2) with SIGTERM → SIGKILL escalation
├── SettingsView.swift      Settings panel (Form-based)
├── AutostartManager.swift  SMAppService wrapper
├── WelcomeView.swift       First-launch onboarding
└── Models.swift            PortEntry struct
```

### Common tasks

| Task | Command |
| --- | --- |
| Build (Debug) | `xcodebuild -project portman.xcodeproj -scheme portman -configuration Debug build` |
| Build (Release) | `xcodebuild -project portman.xcodeproj -scheme portman -configuration Release build` |
| Run unit tests | `xcodebuild -project portman.xcodeproj -scheme portman test` |
| Reset the welcome flag | `defaults delete dev.meliharik.portman hasSeenWelcome` |

## Submitting a pull request

1. Fork the repository and create a branch from `main`. Use a descriptive name like `feat/sort-by-pid` or `fix/kill-button-zombie`.
2. Make your change. Keep commits small and focused — see [Commit messages](#commit-messages).
3. Make sure the project still builds: `xcodebuild ... build`.
4. If you changed UI, attach a screenshot or short screen recording in the PR description.
5. Open a pull request against `main`. The PR template will prompt for the relevant context.
6. CI must be green before review.
7. A maintainer will review. We may suggest changes — don't take it personally; we want the codebase to stay coherent.

We try to review PRs within a week. If yours has gone quiet, feel free to ping with a comment.

## Coding style

- **Swift 5+ / Swift 6 concurrency**: the project uses `default-isolation = MainActor`. Mark non-UI work with `Task.detached`, dispatch queues, or `nonisolated` as appropriate.
- **No third-party dependencies** unless absolutely necessary. The whole point of this project is a small, audited, native binary.
- **No comments that just restate the code.** Comments should explain *why*, not *what*. The code's job is to be self-explanatory.
- **Prefer SwiftUI over AppKit**, but reach for AppKit when SwiftUI doesn't have an equivalent (e.g., `NSPasteboard`).
- **Use system fonts and SF Symbols.** Avoid hard-coded pixel sizes when there's a system text style that fits.
- **Tabs vs spaces**: 4 spaces, no tabs (matches the Xcode default).

## Commit messages

- Keep the subject line under 72 characters and write it in the imperative mood ("Add settings panel", not "Added settings panel" or "Adds settings panel").
- One logical change per commit. If you find yourself writing "and" in the subject line, split the commit.
- Use the body to explain *why* the change is needed when it isn't obvious from the diff.

Good:

```
Refresh port list when the popover opens
```

Less good:

```
fixed bug
```

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).

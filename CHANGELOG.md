# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Menu bar app that lists processes listening on TCP ports.
- One-click process termination with `SIGTERM` → `SIGKILL` escalation.
- Live auto-refresh every two seconds.
- Search filter by port number or command name.
- Right-click context menu to copy port, PID, or full command.
- Settings panel with "Launch at login" toggle (`SMAppService`).
- First-launch welcome screen.
- Native popover styling (system materials, SF Symbols, accent color).

### Notes

- Targets macOS 15.0 (Sequoia) or later.
- App Sandbox is disabled to allow spawning `lsof` and sending signals to other processes.

[Unreleased]: https://github.com/meliharik/portman/compare/HEAD...HEAD

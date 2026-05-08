# Security Policy

## Supported versions

Only the latest released version of portman receives security fixes. If you're on an older version, please update before reporting.

| Version | Supported |
| --- | --- |
| latest release | ✅ |
| older releases | ❌ |
| `main` branch | ✅ (best effort) |

## Reporting a vulnerability

**Please do not open a public GitHub issue for security reports.**

If you've found a security vulnerability in portman, report it privately using GitHub's [Private vulnerability reporting](https://github.com/meliharik/portman/security/advisories/new) feature.

A good report includes:

- A description of the issue and its impact.
- Step-by-step reproduction instructions.
- The version of portman and macOS you tested on.
- Any proof-of-concept code or screenshots.

## What to expect

- **Acknowledgement:** within 72 hours of your report.
- **Initial assessment:** within 7 days.
- **Fix timeline:** depends on severity. Critical issues are prioritized; non-critical issues are scheduled for the next release.
- **Credit:** with your permission, we'll credit you in the release notes once a fix ships.

## Scope

Issues in scope include:

- Privilege escalation (running code as another user, including root).
- Reading or modifying files outside the user's control.
- Killing processes the user would not normally have permission to terminate.
- Crashes triggered by parsing malicious `lsof` output.

Out of scope:

- The fact that App Sandbox is disabled — this is a documented design choice required for the app to function.
- Issues in macOS itself, `lsof`, or other system tools.
- Issues that require local administrator access to exploit.

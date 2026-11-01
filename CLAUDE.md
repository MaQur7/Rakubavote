# CLAUDE.md

Rakubavote: offline-first voting platform for schools, associations and party
bodies in South Sudan.
Full brief: @docs/concept-note.md · Brand: @docs/brand-guidelines.md ·
Decisions since the brief: @docs/decisions.md · Screens: docs/mockups/ · Logo files: brand/
Station protocol: docs/protocol.md · Secrecy design: SECURITY.md

## Stack
- Flutter (Dart), one codebase: Android tablets + Windows/Linux laptops
- SQLite via drift + SQLCipher; Ed25519 / SHA-256 / AES-GCM / X25519 / Argon2id via `cryptography`
- Local station server: shelf (HTTP/WebSocket) over local Wi-Fi
- Printing: voter registration cards only, via `pdf` + `printing` (D18). No vote receipts,
  no token slips, no thermal printers; results are counted and shown by the laptop.
- i18n: intl ARB files in lib/l10n (en, ar RTL, placeholder local language)
- State: flutter_riverpod

## Commands
- Get packages: `flutter pub get`
- Generate drift code: `dart run build_runner build --delete-conflicting-outputs`
- After editing app_en.arb: `python3 tool/sync_l10n.py` (declares placeholder order, fills
  app_din.arb, lists missing Arabic keys). Without declared order gen-l10n sorts arguments
  alphabetically and silently swaps them.
- Run tests: `flutter test`
- Static checks: `flutter analyze`
- Run app: `flutter run -d <device>`
- Build tablet APK: `flutter build apk --release`
- Build laptop app: `flutter build windows` / `flutter build linux`
- In the cloud dev container Flutter lives at /opt/flutter/bin (add to PATH).

## Structure
- lib/app/ device mode chooser, PIN unlock, shell
- lib/core/ theme tokens, crypto, db (registry + ballot box), audit log, domain models, counting, templates
- lib/features/{device_setup,setup,registration,register_lock,checkin,booth,results}/
- lib/station/ local server, client, protocol, USB bundles, multi-part QR
- lib/printing/ voter registration cards (only printed item, D18)
- lib/platform/ kiosk (Android lock task), camera
- test/ unit + integration (incl. 500-voter simulation and secrecy tests); widget tests use
  test/support/app_harness.dart (end each with `finish()`; drift needs real-time pumps via `settle()`)

## Non-negotiable rules
- Must work with NO internet. Online sync is optional and off by default (Supabase deferred, D4).
- Ballot secrecy: registry.db (who) and ballotbox.db (how) are separate files and share NO key.
  A vote row holds only: random ballot id, position, choice, device signature.
  Never add voter id, token, fee data, precise timestamps or arrival order to votes.
  Vote and token tables are WITHOUT ROWID with random keys; no AUTOINCREMENT; secure_delete on.
  Votes are shuffled before every export and before counting.
  Booth audit entries record counts only, never individual votes. Check-ins keep only an hour bucket.
- Tokens: only SHA-256(election id + token) is stored, never linked to a voter; booths accept a
  token only after live activation from the laptop, or from the pre-loaded pool once the officer
  switches the booth to pool mode with the PIN (D1, D23). Pool plain codes are erased when issued.
- No USB or file inputs that can change what is counted (D23): ballots and votes travel only over
  the paired, encrypted station network (laptop or phone hotspot, no internet).
- Every ballot definition, locked register, vote batch and result file is signed (Ed25519);
  verify signatures on import and show failures in plain words.
- Audit log is append-only and hash-chained; never add update/delete for it (triggers block it).
- Registration fee is optional per election, set before registration, locked after the first voter.
  Fee data never touches ballot box tables.
- Voter card QR holds only voter number + signature (signature covers card issue number).
- Positions/candidates/rules are data, never hard-coded. Support 13+ candidates per position.
- Ties are flagged and recorded only; the app never breaks a tie or declares a winner by rule (D3).
- Personal data fields are fixed by D2; school elections need the consent checkbox before registration.

## UI rules
- Follow docs/mockups/ and docs/brand-guidelines.md. Touch targets >= 64 px,
  sentence case, Atkinson Hyperlegible (Latin) + Noto Sans Arabic, fonts
  bundled offline (assets/fonts).
- Button text styles must carry the font family and fallbacks: use the theme, or
  `buttonTextStyle(context, size)` from lib/core/theme.dart, never a bare TextStyle (Arabic
  turns into empty boxes otherwise). Noto Sans is the fallback for letters Atkinson lacks (D13).
- Brand colours only as named tokens in lib/core/theme.dart: nileBlue
  #1D4E89, acaciaGreen #1F5E3A, clay #A9521A, thatchGold #C8963E, lightThatch
  #E6C27A, ink #1B1B1B, paper #F4F1EA. Never hard-code hex in screens; never
  white text on thatch colours. Position colours are election data, contrast-checked.
- App name is always "Rakubavote" (one word, capital R only).
- One position per screen; colour per position; "No choice" always last.
- All user-facing text goes through ARB files; check Arabic RTL layout.
- Voice: plain, neutral, never blaming ("That code was not found. Check your slip or ask an official").

## Working style
- Propose a plan and wait for approval before large changes.
- Write tests with every feature; run `flutter test` before saying work is done.
- Ask before adding any dependency (approved list in D5), paid service, network call
  outside the station, or new personal data field.
- Commit each milestone to master and push (D6). Record new decisions in docs/decisions.md.

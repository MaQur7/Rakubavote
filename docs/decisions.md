# Decisions

Decisions made by the project lead after the concept note. Newest last. CLAUDE.md links here;
when a decision changes a rule, update CLAUDE.md too.

| # | Date | Decision |
|---|---|---|
| D1 | 2026-10-31 | **Token validation: live activation.** A token is valid at a booth only after check-in issues it and the laptop broadcasts its hash over local Wi-Fi. If Wi-Fi is down, booths may switch to a pre-loaded token pool only with the presiding officer's PIN; the switch is written to the audit log and any mismatch is flagged at closing. |
| D2 | 2026-10-31 | **Personal data fields approved:** voter full name, member/student/delegate ID, group, photo, registration date and station, fee paid status, fee currency/amount, receipt number; objection claimant name and name of person objecting; officials' names in the audit log. **School consent:** an election-level "School consent recorded" checkbox (who recorded it, when) — required before registration in school elections. Nothing stored per minor. |
| D3 | 2026-10-31 | **Ties: record only.** The platform counts, flags ties and records the data. It never breaks a tie or names a winner by rule; the committee announces results based on the recorded data. |
| D4 | 2026-10-31 | **Supabase deferred.** Not built in milestones 1–8; only a disabled placeholder. Any network call outside the station needs fresh approval. |
| D5 | 2026-10-31 | **Dependencies approved:** drift, drift_dev, build_runner, sqlite3, sqlcipher_flutter_libs, cryptography, shelf, shelf_router, shelf_web_socket, web_socket_channel, http, mobile_scanner, qr_flutter, pdf, printing, esc_pos_utils_plus, print_bluetooth_thermal, camera, image_picker, flutter_localizations, intl, flutter_riverpod, path_provider, file_picker, csv, audioplayers. Anything else needs approval. |
| D6 | 2026-10-31 | **Git:** commit each milestone directly to `master` and push. |
| D7 | 2026-10-31 | **Audit of check-ins:** hourly counts in the audit log, not one line per check-in. Manual check-ins are logged individually with their reason. |
| D8 | 2026-10-31 | **License:** AGPL-3.0. |
| D9 | 2026-10-31 | **Two database files.** `registry.db` (who: election, register, check-ins, fees, audit) and `ballotbox.db` (how: votes only). Booth tablets carry only `ballotbox.db` plus the signed ballot. |
| D10 | 2026-10-31 | **SQLCipher via `sqlite3` 3.x build hooks.** `sqlcipher_flutter_libs` is end-of-life (an empty package from 0.7.0). SQLCipher is selected with `hooks: user_defines: sqlite3: source: sqlcipher` in pubspec.yaml; this covers Android, Windows and Linux. The SQLCipher build links OpenSSL on those platforms. |
| D11 | 2026-10-31 | **Placeholder local language** uses locale code `din` (Dinka) with English text until a translator supplies it. Flutter framework strings fall back to English for it. |
| D12 | 2026-10-31 | **Per-booth used codes in batches.** Each booth's `used_tokens` lists only codes used at that booth; its signed batch carries those hashes (sorted, unlinked to ballots) so the laptop can detect a code used at two booths or never issued. Each batch is the booth's complete set; the latest batch per booth wins. |
| D13 | 2026-10-31 | **Noto Sans bundled as a fallback font** (OFL), as the brand guidelines direct, because Atkinson Hyperlegible lacks Dinka letters such as ɔ. Fallback order: Latin text Atkinson → Noto Sans → Noto Sans Arabic; Arabic text Noto Sans Arabic → Atkinson → Noto Sans. |
| D14 | 2026-10-31 | **Officer PIN is 6–12 digits**, entered with the official's name each time the app opens; the name goes into the audit log. |
| D15 | 2026-10-31 | **Ballot stays editable until the register is locked.** Any change clears the ballot signature, so it must be signed again; registration can start before the ballot is signed. The audit log stores voter numbers only, never names or IDs. |
| D16 | 2026-10-31 | **Objection decisions.** Possible duplicate: *Keep both* or *Remove* (the voter is marked removed; numbers are never reused). Missing name: *Add voter* (registered with a new number) or *Reject*. Other: *Upheld* or *Rejected* (recorded only). Each objection is decided once. The app suggests duplicate pairs but never raises or decides objections by itself. The register can be locked only with a signed ballot, at least one voter and no open objections; its signature binds it to the ballot hash. Lost-card reprints stay allowed after locking. |

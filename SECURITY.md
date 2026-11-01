# Security and ballot secrecy

This document explains how Rakubavote keeps the vote secret, how it makes tampering visible,
and what it does **not** protect against. It is written for election officials, party agents,
observers and independent reviewers. If you find a weakness, please report it (see the end).

## The promise

> Every eligible person votes once, in secret, and everyone can check the count.

Two things must both be true:

1. **Nobody can link a vote to a voter**, including the presiding officer, the person who
   wrote the software, and anyone who copies every file on every device.
2. **Nobody can change the register, the ballot, the votes or the results without it
   showing**, and the paper receipts allow an independent hand recount.

## How secrecy works

### Two separate databases

| Database | Holds | Lives on |
|---|---|---|
| `registry.db` | **Who**: the election, the register, voter photos, fees, objections, check-ins, issued voting-code hashes, the audit log | Station laptop (and the check-in device) |
| `ballotbox.db` | **How**: the signed ballot and the votes | Each booth tablet, and the laptop after closing |

They are separate files with separate encryption keys. There is no column, value or
key that appears in both and refers to the same person.

### What a vote record contains

Exactly four things, enforced by the database schema and by automated tests
(`test/core/secrecy_test.dart`):

| Field | Meaning |
|---|---|
| `ballot_id` | A random 128-bit number made when the voter presses *Confirm my vote*. It is printed on the receipt. |
| `position_id` | Which position (for example "Chairman"). |
| `choice` | The chosen candidate(s), or "No choice for this position". |
| `signature` | The booth tablet's digital signature over the row. |

A vote record **never** contains the voter's name or number, the voting code, the fee, the
time, or a counter that shows the order of voting.

### The one-time voting code

1. The presiding officer opens the polls. At check-in, the official finds the voter by voter
   card (a signed QR code holding only the voter number) or by name, and confirms identity
   against the registration photo. The laptop marks the voter as
   checked in (with the hour only, for turnout) and creates a random 6-character code such as
   `7K4-Q9M`, which is printed on a slip for the voter.
2. The code itself is **never stored**. Only a one-way hash of it is stored, in a table that
   has **no voter column and no time column**.
3. The laptop sends that hash to every booth over the local Wi-Fi ("live activation"). A booth
   accepts only codes that have been activated and not yet used.
4. When the voter confirms, the booth moves the hash to a "used codes" table (again with no
   time and no link to the ballot) and writes the vote rows with a fresh random ballot id.

So the chain *voter → code → vote* is broken twice: check-in does not keep the code, and the
booth does not keep which code went with which ballot.

### Order and time cannot be used to link

Even without a shared key, someone could try to match the 37th check-in with the 37th vote.
Rakubavote prevents this:

- **No timestamps** on votes, issued codes or used codes. Check-ins keep the hour only.
- **No arrival order.** Vote and code tables are `WITHOUT ROWID` tables keyed by random
  values, so SQLite stores rows in random-key order, not in the order they were written. No
  table uses `AUTOINCREMENT`.
- **Batches are ordered by random ballot id** (a random permutation, unrelated to voting
  order), and votes are shuffled again before counting.
- **`secure_delete` is on**, so deleted data (for example a code moved from "active" to
  "used") is overwritten rather than left in free pages.
- **Booth audit logs record counts and device events only**, never an individual vote or code.
- **Check-ins are logged as hourly counts** in the audit log; only manual check-ins are logged
  one by one (with their reason), because those need an explanation.

### Paper receipts

Each receipt shows the election, position names, candidate numbers and names, and the random
ballot id — never the voter. The voter checks it and drops it into the sealed box. Receipts
allow a hand recount that does not depend on the software.

## How tampering is made visible

| What | Protection |
|---|---|
| Ballot (positions, candidates, rules, photos) | Signed by the station laptop (Ed25519). Booths verify before loading. Photos are covered by their SHA-256 hash. |
| Voter register | Signed when locked; a short **fingerprint code** (e.g. `K7QM-2H9X`) is printed for agents. The database refuses any change to voters after locking. |
| Each vote | Signed by the booth that recorded it. |
| Each booth's vote batch | Signed by the booth. The laptop accepts batches only from booths it enrolled, and checks every vote signature. |
| Results | Signed by the laptop, with a fingerprint code printed on every results sheet. |
| Audit log | Append-only and hash-chained. The database refuses edits and deletes; if someone bypasses that, the chain check names the first broken entry. |
| Voter card | The QR code holds only the voter number and a signature over (election, voter number, card issue). A reprinted card makes the old card fail. |
| Registration fee | Settings are locked by the database once the first voter is registered. Fee data never leaves the registry. |

Signatures use Ed25519; hashes use SHA-256; fingerprints are the first 40 bits of the SHA-256
hash in Crockford base32. Everything that is hashed or signed is first written as canonical
JSON (sorted keys, integers only), so the same data always gives the same bytes.

### Closing checks

At closing the laptop reports, and never silently corrects:

- check-ins vs codes issued vs codes used vs ballots;
- the same code used at two booths (possible only if Wi-Fi failed between them);
- codes used that were never issued;
- ballots with a missing or unknown position, or an invalid choice.

**Ties** are flagged and recorded. The software never breaks a tie or declares a winner by
rule; the committee announces results from the recorded data.

## Encryption at rest and device keys

- Both databases are encrypted with **SQLCipher** using random 256-bit keys.
- Those keys, and the device's signing keys, are kept in a small vault file encrypted with
  AES-256-GCM under a key derived from the **officer PIN** with Argon2id. Changing the PIN
  re-encrypts only the vault, not the databases.
- Without the PIN, a stolen laptop or tablet does not reveal voter data or votes.

## Network

- Everything works with **no internet**. The station uses its own local Wi-Fi.
- Online upload (Supabase) is **not built** and is off by default; it will only be added
  with the project lead's approval.
- Devices pair with the laptop by scanning a QR code; after pairing, messages are signed and
  encrypted per device (see `docs/protocol.md`).

## What this does not protect against

Be honest with voters and agents about these limits:

- **Someone watching the voter** in the booth, or a camera pointed at the screen. Use
  privacy screens and place booths so nobody can see them.
- **Timing by a person in the room.** An observer who writes down when each voter enters each
  booth learns nothing from the data, but booth layout and queue order are physical matters
  for the presiding officer.
- **A voter who shows their receipt** to someone outside. Receipts must go into the sealed
  box before the voter leaves the booth area.
- **A compromised device** (someone installs modified software or has the PIN and full
  control of a booth during polling). Use the official release builds, keep tablets in kiosk
  mode, keep the PIN secret, and compare the paper recount with the digital count.
- **Very small groups.** If only one person in a group votes, or everyone votes the same way,
  the result itself reveals choices. This is true of any ballot.
- **The check-in official can see the code on screen** while printing it. The code cannot be
  linked to a ballot afterwards, but officials should not write codes down.
- **A lost voting slip cannot be replaced.** Because nothing links a code to a voter, the app
  cannot cancel the lost code; issuing a second one would allow two votes. This is deliberate.

## Personal data

Only the fields approved in `docs/decisions.md` (D2) are collected. Photos and voter data are
encrypted at rest. School elections require the "school consent recorded" box to be ticked
before registration. Data should be deleted after the election and the dispute period; the
retention period is set by each organization.

## Reporting a problem

Please open a GitHub issue marked **security**, or contact the project lead privately before
publishing details of a serious weakness. Independent review by a university or tech group is
planned before the first real election.

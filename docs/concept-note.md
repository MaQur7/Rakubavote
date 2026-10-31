# Rakubavote: Concept Note and Build Brief

Oct 31, 2026 · Makur Majeng

> Converted from the original PDF. Screens referenced here are in [docs/mockups/](mockups/).
> Decisions made after this brief are recorded in [docs/decisions.md](decisions.md).

## Concept note

We will build a low-cost voting platform that runs fully offline on tablets and a laptop, so
schools, community associations and party bodies in South Sudan can hold secret,
transparent elections without internet.

**Problem.** Paper elections in schools, associations and party primaries often end in
disputes over who was allowed to vote, spoiled ballots, slow counting and contested
results. Internet and power are unreliable in most of the country, so online voting systems
do not work.

**Purpose.** Give any organization a simple kit (one laptop, a few tablets, a small printer,
power banks) that registers voters, checks them in, records secret votes, and produces a
count everyone can verify, all without internet. Internet is an optional extra for backups
and sending results.

**Users.**

- Election officials who set up elections, register voters, run check-in and close the polls
- Voters, including people who cannot read or have never used a touchscreen
- Candidates, party agents and observers who need to trust the process and check results
- Organizations: schools (prefects), community associations (committees), party bodies
  (primaries and congresses)

**Principles.**

1. Offline first: every function works with no internet, ever.
2. Secret ballot: who voted is recorded separately from how they voted; a vote can never
   be linked to a person.
3. Verifiable: every vote also prints a paper receipt into a sealed box, so the digital count
   can be recounted by hand.
4. Simple for everyone: large buttons, photos, candidate numbers and symbols, three
   languages, one position per screen.
5. Configurable: positions, candidates and rules are set per election, never hard-coded.
6. Neutral and open: the same tool is offered to any organization or party, and the code is
   public so anyone can inspect it.
7. Fail safely: a printed register and manual procedures back up every digital step.

## How it works

An election runs in four phases on one station laptop, with tablets used only on election day.

**Phase 1: Setup.** An official creates the election from a template (school, association, party
primary or blank), adds positions in order, adds candidates with photo, number and
symbol, and sets rules per position (how many to choose, whether "No choice" is allowed).
The ballot is then signed so it cannot be changed unnoticed.

**Phase 2: Registration.** Officials register voters offline: full name,
member/student/delegate ID, group (class, branch or county) and a photo. The app flags
possible duplicates. Each voter gets a voter number and a printed card with a QR code.
Lists can also be imported from a CSV (for example, a party's delegate list).

**Phase 3: Public review and lock.** The register is printed and posted for a set number of
days. Objections (duplicates, missing names) are recorded and decided in the app, with
every decision logged. When all objections are resolved, the register is locked and signed,
and a short fingerprint code is printed for agents and observers.

**Phase 4: Election day.**

1. The station laptop starts a local Wi-Fi network (no internet). Tablets join it and load the
   signed ballot.
2. At the check-in desk, the official finds the voter by QR card or name, compares the
   photo, and confirms. The voter is marked as voted and receives a one-time token
   printed on a slip.
3. In the booth, the voter enters the token, chooses a language, and votes one position
   per screen: tap a candidate, type the candidate number, or choose "No choice".
4. A review screen shows all choices; the voter can change any before pressing Confirm.
5. The tablet saves the encrypted, signed vote with a random ID (no link to the voter),
   prints a paper receipt, beeps and shows "End". The voter checks the receipt and drops
   it in the sealed box.
6. If a voter is not found or a device fails, the official uses the printed register and Manual
   check-in, recording the reason.

**Closing.** The official closes polls; tablets lock and send their votes to the laptop. The
laptop checks that check-ins match votes, counts each position, flags ties, and prints
results sheets for signing by officials, agents and observers. Results are exported as a
signed file (USB) and a signed QR code, and sent online only if internet is available. Paper
receipts are counted by hand with agents present and entered to compare with the
digital count.

## Registration fee and voter card

Organizations can charge an optional registration fee, and every registered voter receives
a printed, sealed voter card.

**Fee (optional).**

- Set in Election setup before registration opens: on or off, amount, and currency (SSP,
  USD, or either).
- Locked once the first voter is registered, so everyone pays the same amount.
- At registration the official ticks "Paid" and enters a receipt number; the app can also
  print a fee receipt.
- A Fee summary report shows totals by currency and by official, for the treasurer and auditors.
- Fee records belong to the registration side only; they are never linked to votes.
- Each organization sets whether an unpaid person can still be registered (block, or allow
  with a flag).

**Voter registration card** (see mockup E).

- Generated automatically after a voter is saved, sized as an ID card (85.6 × 54 mm) or
  A6, printed on the station printer.
- Shows: organization name and logo, election name and year, voter photo, full name,
  voter number, member/student ID, branch/class/county, fee status and receipt number,
  registration date and station.
- QR code holds only the voter number and a digital signature, no personal data; check-in
  scans it to find the voter.
- Bottom strip for the registration official's signature and the organization's seal; the
  card is then handed to the voter.
- Lost cards: only an official can reprint, and the old card is marked as replaced in the
  audit log.

## Apps and screens

The platform is one Flutter codebase that runs in three modes, chosen when the device is
set up. All screens are drawn in the mockups (`docs/mockups/`).

| Mode | Device | Screens (mockup) | Who uses it |
|---|---|---|---|
| Station Admin | Laptop (Windows or Linux) | A Setup · B Registration · C Review and lock · D Results | Presiding officer |
| Check-in | Laptop, or a tablet joined to the laptop | 1 Check-in desk, Manual check-in | Check-in official |
| Voting Booth | Android tablet in kiosk mode | 2 Enter token · 3 Position ballot (2 candidates) · 3b Position ballot (13 candidates) · 4 Review · 5 Vote recorded | Voter |

**Booth design rules** (from ballot design research and systems used in Brazil, India, the US
and Kenya):

- One position per screen, colour-coded consistently across ballot, review, receipt and results
- Candidate photo, number and symbol on every row; mixed-case text; minimum 16 px
  body, 24 px names
- Touch targets at least 64 px; whole row is tappable; tapping another option replaces the choice
- Number entry as an alternative for long lists; "No choice for this position" always last
- Help button and instructions on every screen; English, Arabic (right-to-left) and local languages
- Review screen before confirm; long beep and "End" after; screen clears after 10 seconds
- For 13+ candidates: two-column grid of compact rows, a number box, and the current
  choice pinned at the bottom

## Security, secrecy and transparency

The core rule: check-in data (who voted) and ballot data (how they voted) are stored in
separate tables with no shared key, so no one, including administrators, can link a vote to a voter.

- **Tokens.** Check-in issues a random one-time token. The booth marks the token used
  and stores only a hash. The vote record never contains the token, voter number,
  timestamp to the second, or booth order.
- **Vote records.** Each vote gets a random ID, is encrypted on the tablet (SQLCipher), and
  is signed with the device's Ed25519 key. Votes are shuffled before counting so order
  cannot reveal identity.
- **Signed artifacts.** The ballot definition, the locked register, each tablet's vote batch and
  the results file are signed. Any change breaks the signature and is shown as an error.
- **Fingerprint codes.** The locked register and final results show a short hash code that
  agents copy down and can check later.
- **Paper receipts.** Each vote prints a receipt with position names, candidate numbers and
  names, and the random vote ID, never the voter. Receipts go into a sealed box for hand recount.
- **Audit log.** Append-only, hash-chained log of every action (setup, registration,
  objections, check-ins counted but not linked, polls open/close, exports), with official
  name and time.
- **Device lockdown.** Tablets run in Android lock-task (kiosk) mode; no other apps; admin
  functions need an officer PIN on the laptop.
- **Personal data.** Collect only what is needed; photos and voter data are encrypted at
  rest and deleted after the election and dispute period. Minors' data (schools) needs
  the school's consent.
- **Independent review.** The code is public on GitHub; ask a local university or tech group
  to review it before the first real use.

Out of scope for the pilot: biometric fingerprint checks (Kenya's experience shows high
failure rates for manual workers and elderly voters) and any internet voting.

## Technology stack

Everything below is free and open source; the only optional paid-tier risk is the online
backup service, which the system never depends on.

| Layer | Choice | Why |
|---|---|---|
| Language and UI | Flutter (Dart) | One codebase for Android tablets and Windows/Linux laptops; works fully offline; strong right-to-left and multi-language support |
| Local database | SQLite via `drift`, encrypted with SQLCipher (`sqlcipher_flutter_libs`) | Reliable offline storage, encrypted at rest |
| Cryptography | `cryptography` package: Ed25519 signatures, SHA-256 hashes, AES-GCM | Signs ballots, registers, votes and results |
| Station network | Laptop runs a small HTTP/WebSocket server (`shelf`) on a local Wi-Fi hotspot or cheap travel router | Tablets sync with the laptop with no internet |
| Fallback transfer | USB drive and QR codes (`mobile_scanner`, `qr_flutter`) | Works if Wi-Fi fails |
| Printing | ESC/POS thermal printers over Bluetooth or USB (`esc_pos_utils_plus` or similar); PDF for A4 sheets (`pdf` + `printing`) | Receipts, voter cards, registers, results |
| Camera | `camera` / `image_picker` | Voter and candidate photos |
| Languages | Flutter `intl` with ARB files: English, Arabic, local languages | Translators edit plain files |
| Kiosk mode | Android lock-task mode (device owner) | Voters cannot leave the app |
| Code hosting | GitHub (public repository) | Free; open code builds trust |
| Builds | GitHub Actions | Free builds of the Android APK and desktop app on every release |
| Distribution | GitHub Releases; install APK by USB (sideload) | No app store or internet needed at stations |
| Optional online | Supabase free tier (Postgres) for results upload and register backup | Only used when internet is available; free tiers have limits and can change |
| Tests | `flutter_test`, integration tests, a simulated 500-voter election | Catch counting errors before real use |

## Hardware and cost

A pilot station kit costs roughly USD 700 to 1,000 if bought new, less with donated or
existing devices. Prices below are approximate estimates, not quotes; check local prices in Juba.

| Item | Quantity | Approx. unit cost (USD) | Notes |
|---|---|---|---|
| Station laptop (existing or refurbished) | 1 | 0 to 300 | Windows 10+ or Ubuntu; runs Admin and the local server |
| Android tablet, 10 inch, Android 10+ | 2 to 3 | 100 to 150 | Voting booths; one spare recommended |
| Bluetooth thermal receipt printer, 58 mm | 2 | 30 to 50 | One per booth; carry spare paper rolls |
| Travel Wi-Fi router (optional) | 1 | 20 to 30 | More stable than a laptop hotspot |
| Power banks, 20,000 mAh | 3 to 4 | 20 to 30 | Charge everything before the day |
| Folding solar panel (optional) | 1 | 50 to 100 | For long days or remote sites |
| Sealed receipt box, privacy screens, USB drives | 1 set | 20 to 40 | Locally made boxes are fine |

Software, code hosting and builds cost nothing.

## Brand and name

The platform is named **Rakubavote**, after the rakuba, the open shaded shelter where
communities across South Sudan gather and decide. Logo, colours (Nile Blue, Thatch Gold,
Clay, Acacia Green, Ink), fonts (Atkinson Hyperlegible and Noto Sans Arabic), voice and
usage rules are in the [Rakubavote Brand Guidelines](brand-guidelines.md); the logo draft is on
board F of the mockups. Before launch, check the name in the Play Store, domains (.com, .ss) and
South Sudan's business register.

## Pilot plan and roadmap

Start with one school election, then a community association, and only then larger bodies
such as party primaries.

1. **Build the core (MVP).** Setup, registration, lock, check-in, booth, results, receipts, all
   offline on one laptop and two tablets.
2. **Usability test.** Mock election with 20 to 30 real users, including people who cannot
   read and first-time touchscreen users; fix what confuses them.
3. **School pilot.** Head prefect, head boy, head girl, secretaries; all students vote for all
   positions. Run the paper recount and compare.
4. **Community association.** Chairman, Secretary General, Finance Secretary, using the
   CIEC ballot layout; invite observers.
5. **Independent code review** by a university or tech group; publish the findings.
6. **Party bodies.** Offer to any party's election committee for congresses, primaries or
   by-elections, with written agreement from the committee and aspirants. Party delegate
   lists come in by CSV import; ballots must handle 13+ candidates.
7. **Later.** Multiple stations with central tally, ranked or multi-seat contests, audio ballot for
   blind voters.

**Open questions**

- Which local languages besides English and Arabic, and who translates?
- Tie rule for each organization (re-vote, committee decision)? — *Answered: see decisions.md (D3).*
- How long are photos and data kept after an election, and who decides?
- Who will be the first school, and when is its election?

# Rakubavote

**Fair elections, in the shade of the community.**

Rakubavote is a free, open-source voting kit for schools, community associations and party
bodies in South Sudan. One laptop and a few tablets register voters, check them in, record
secret votes and print a count everyone can check — **with no internet**.

> **Status: under construction.** The app is being built in milestones (see
> [Project status](#project-status)). Do not use it for a real election until the independent
> code review described in the [concept note](docs/concept-note.md) has been done.

## What you need

| Item | How many | Used for |
|---|---|---|
| Laptop (Windows 10+ or Ubuntu Linux) | 1 | Setting up the election, registration, results |
| Android tablet, 10 inch, Android 10+ | 2–3 | Voting booths (one spare) |
| Bluetooth thermal receipt printer, 58 mm | 1 per booth | Vote receipts and voting slips |
| Travel Wi-Fi router (optional) | 1 | A local network with no internet |
| Power banks or a solar panel | 3–4 | A full day without mains power |
| Sealed receipt box, USB drives | 1 set | Paper receipts for a hand recount |

## Installing the app

You do not need internet at the polling station. Download the files once, before election day.

1. Open the [Releases page](../../releases) and download:
   - `rakubavote-windows-x64.zip` or `rakubavote-linux-x64.tar.gz` for the laptop
   - `rakubavote-android-apk` for each tablet
2. **Laptop (Windows):** unzip the file into a folder, open the folder and double-click
   `rakubavote.exe`.
3. **Laptop (Ubuntu):** extract the file into a folder, open the folder and double-click
   `rakubavote` (or run `./rakubavote` in a terminal).
4. **Tablet:** copy the APK to the tablet with a USB cable, open it in the Files app and
   tap *Install*. If Android asks, allow installing from this source.
5. Open Rakubavote and choose what the device will be used for: *Station admin*,
   *Check-in desk* or *Voting booth*.

### First start on the laptop

1. Choose your language at the top (English, العربية or the local language).
2. Tap **Station admin**.
3. Type your name and choose an **officer PIN** of 6 to 12 digits. Type it twice.
   Keep it secret: without it nobody can open the election data, and it cannot be recovered.
4. Each time the app opens, type your name and the PIN. Your name is written next to
   everything you do, in the audit log.

### Phase 1: Set up the election (tab "1 Setup")

1. Choose a **template**: School, Community association, Party primary or Blank. Type the
   organization name, election name, year and station name. Choose the ballot languages.
2. **School elections:** tick *The school has given consent to register students under 18*.
   Registration cannot start until this is ticked.
3. **Registration fee (optional):** tick *Charge a fee*, type the amount, choose SSP, USD or
   either, and choose what happens if someone has not paid. Press *Save fee*.
   The fee cannot be changed after the first voter is registered.
4. **Positions:** the template adds the usual positions. Tap a position to edit it:
   - its title in each ballot language,
   - its colour (the app refuses colours that are too light to read),
   - how many candidates a voter may choose, and whether "No choice" is allowed.
   Use *Add position*, *Move up*, *Move down* and *Delete position* as needed.
5. **Candidates:** tap *Add candidate (take photo)*. Check the number, type the name, take
   the photo and choose the symbol. Numbers must be different within a position.
6. Press **Save and sign ballot**. Write down the fingerprint code it shows. If you change
   anything later, sign again.

### Phase 2: Register voters (tab "2 Registration")

1. Tap **Take photo** (on a laptop this opens a photo file), then type the full name,
   ID and group.
2. If there is a fee, tick **Paid** and type the receipt number.
3. If a yellow **Possible duplicate** box appears, check the other voter before saving.
4. Press **Save and print voter card**. The voter number is given automatically.
   (Card printing is added in a later update.)
5. **Import list (CSV):** for a list such as party delegates. The first row must have a
   `full_name` column; it may also have `member_id`, `group`, `fee_paid`, `currency` and
   `receipt_no`. The app tells you which lines it skipped and why.
6. **Fee summary** shows totals by currency and by official.
7. **Back up to USB** at the end of each day: choose the USB drive. The backup is encrypted
   and needs the officer PIN to open.

### Phase 3: Public review and lock (tab "3 Review and lock")

1. Press **Set dates** and choose the first and last day the register is posted for the public.
2. Post the printed register on the notice board. (Printing is added in a later update; until
   then use the Registration list.)
3. When someone objects, press **Record an objection** and choose:
   - **Possible duplicate:** type both voter numbers.
   - **Missing name:** type the name of the person who says they registered.
   - **Other:** type the voter number and the details.
   Always type the name of the person objecting.
4. **Check for duplicates** lists names that look alike in the same group. You can record any
   of them as an objection; the app never removes anyone by itself.
5. Decide each objection with the buttons on it: *Keep both* / *Remove*, *Add voter* /
   *Reject*, or *Upheld* / *Rejected*. Every decision is saved with your name and the date.
6. When there are no open objections, press **Lock register** and confirm. The ballot must
   already be signed in Setup.
7. Write the **fingerprint code** on the notice board and give it to party agents and
   observers. After locking, no names can be added, changed or removed, and the ballot cannot
   be changed. A lost card can still be reprinted.

Guides for election day and closing will be added as those parts are finished.

## Project status

| Milestone | What it delivers | Status |
|---|---|---|
| 0 | Project setup, fonts, brand, build workflow | Done |
| 1 | Data model, encryption, signatures, audit log | Done |
| 2 | Election setup and voter registration | Done |
| 3 | Public review, objections and register lock | Done |
| 4 | Check-in and voting codes | Planned |
| 5 | Voting booth screens | Planned |
| 6 | Station network, closing and results | Planned |
| 7 | Printing (receipts, voter cards, registers, results) | Planned |
| 8 | Tablet kiosk mode and release packages | Planned |

## For developers

See [CLAUDE.md](CLAUDE.md) for commands and rules, [SECURITY.md](SECURITY.md) for the secrecy
design and [docs/](docs/) for the brief, brand guidelines, mockups and decisions.

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter run -d linux   # or windows, or an Android device id
```

## License

[GNU Affero General Public License v3.0](LICENSE). Fonts: SIL Open Font License (see
`assets/fonts/`).

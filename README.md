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
| Printer (any printer the laptop can print to) | 1 | Voter registration cards |
| A Wi-Fi hotspot with **no internet**: the laptop's own hotspot, or any phone hotspot | 1 | The station network all tablets join |
| Power banks or a solar panel | 3–4 | A full day without mains power |
| USB drive | 1 | End-of-day encrypted backup and saving the signed results |

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
4. Press **Save and print voter card**. The voter number is given automatically and the print
   window opens. Choose the card size:
   - **ID cards on A4 paper** (10 per page, cut them out) for an ordinary printer,
   - **One ID card per page** for a card printer,
   - **A6 card** for a larger card.
   Press **Print**, or **Save PDF** to print elsewhere. Sign the card and stamp it with the seal
   before giving it to the voter.
5. **Print cards not yet printed** prints every card still waiting, in one go.
6. **Lost or damaged card:** tap the voter in the list, press **Replace lost card**, choose the
   reason, then **Print card**. The old card stops working at check-in.
7. **Import list (CSV):** for a list such as party delegates. The first row must have a
   `full_name` column; it may also have `member_id`, `group`, `fee_paid`, `currency` and
   `receipt_no`. The app tells you which lines it skipped and why.
8. **Fee summary** shows totals by currency and by official.
9. **Back up to USB** at the end of each day: choose the USB drive. The backup is encrypted
   and needs the officer PIN to open.

### Phase 3: Public review and lock (tab "3 Review and lock")

1. Press **Set dates** and choose the first and last day the register is posted for the public.
2. Press **Print register for notice board** (or **Save PDF**) and post it. It lists voter
   numbers, names, IDs and groups only. Keep a printed copy at the check-in desk as a backup for
   manual check-in; after locking, print it again so it shows the fingerprint code.
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

### Election day: open the polls and check voters in

1. In **3 Review and lock**, after the register is locked, press **Open the polls** and confirm.
2. Press **Check-in desk** in the top bar.
3. For each voter:
   - Scan the voter card with the USB QR scanner (it types into the *Find voter* box), or
     type the name or voter number.
   - **Compare the photo with the person in front of you.**
   - Press **Confirm and issue voting token**. Copy the code onto the slip for the voter.
     There is no printer at check-in: write the code on a blank slip for the voter.
   - Press **Next voter**.
4. If the app says *This voter has already received a token*, do not give another code; call
   the presiding officer.
5. If a card was replaced, ask for the new card. If the voter is not found or a device fails,
   find the voter on the printed register and use **Manual check-in**: type the voter number,
   choose the reason and add details. Manual check-ins are recorded one by one.
6. A lost slip cannot be replaced: codes are not linked to voters, so a new code would allow a
   second vote. Ask the voter to find the slip.

### Election day: set up each voting booth (tablet)

1. Connect the tablet to the laptop (see below). The ballot arrives from the laptop by itself.
2. **Compare the fingerprint code** on the tablet with the one the laptop showed when the ballot
   was signed. If they differ, do not use the tablet.
3. Press **Start voting booth**. The voter screen appears.
4. To leave the voter screen, press and hold the top corner for a few seconds and type the
   officer PIN.

What the voter does: types the code, chooses a language, picks a candidate (or *No choice*) on
each screen, checks the choices, presses **Confirm my vote**, hears a long beep and sees
**End**. The screen clears by itself after 10 seconds.

### Connect the tablets to the laptop (before polls open)

1. Turn on the laptop's Wi-Fi hotspot (or a phone hotspot). **No internet is needed**; mobile
   data can be switched off. Join all tablets to that Wi-Fi network.
2. On the laptop, press the **Devices** icon in the top bar, then **Start the station network**
   and **Show pairing code**.
3. On each tablet, choose **Connect to the laptop**. Scan the laptop's QR code, or type the
   laptop address and the pairing code shown on the laptop.
4. The laptop shows a request with a device id. Check that the tablet shows **the same id**,
   then press **Approve**.
5. A booth then loads the ballot from the laptop by itself. A check-in
   tablet shows the check-in desk.

Each code is valid at the booths as soon as it is issued.

**Before opening the polls**, on the laptop's **Devices** page press **Prepare code pool** while
all booths are connected. Then, if the Wi-Fi fails during the day:

- On the booth that lost Wi-Fi, open the officer panel (long press on the corner, PIN) and press
  **Wi-Fi is down: use pre-loaded codes**, then type the officer PIN. Voters checked in at the
  laptop can keep voting there.
- When the Wi-Fi is back, press **Wi-Fi is back: stop using pre-loaded codes**. The booth tells
  the laptop which codes it used.

### Closing the polls and results (tab "4 Results")

1. Press **Close the polls** and confirm. Check-in stops; booths finish and send their votes.
2. Wait until every booth shows **Votes received**. If a booth cannot reach the laptop, bring it
   closer to the hotspot; its votes are sent as soon as it reconnects. (Votes are never moved by
   USB, so nobody can slip in a file.)
3. Press **Show results**. The laptop counts, checks that check-ins match votes, and flags ties.
   Ties are not broken: the committee decides, as the election rules say.
4. Read out the **results fingerprint**. Agents and observers copy it, or scan **Show signed QR
   code**. Press **Save signed file to USB** to keep the signed results.
5. If a booth's votes arrive late, press **Count again**.

## Project status

| Milestone | What it delivers | Status |
|---|---|---|
| 0 | Project setup, fonts, brand, build workflow | Done |
| 1 | Data model, encryption, signatures, audit log | Done |
| 2 | Election setup and voter registration | Done |
| 3 | Public review, objections and register lock | Done |
| 4 | Check-in and voting codes | Done |
| 5 | Voting booth screens | Done |
| 6 | Station network, closing and results | Done |
| 7 | Printing voter registration cards and the register PDF | Done |
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

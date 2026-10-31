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

Step-by-step guides for each phase (setup, registration, review and lock, election day,
closing) will be added here as each part of the app is finished.

## Project status

| Milestone | What it delivers | Status |
|---|---|---|
| 0 | Project setup, fonts, brand, build workflow | Done |
| 1 | Data model, encryption, signatures, audit log | Done |
| 2 | Election setup and voter registration | Planned |
| 3 | Public review, objections and register lock | Planned |
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

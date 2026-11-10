# Rakubavote design system

Approved by the project lead · 2026-11-02 (D25). The source of truth for how every screen looks. It turns
[brand-guidelines.md](brand-guidelines.md) into exact values, so no screen falls back on Flutter or
Material defaults. If a case is not covered here, add it here first, then build it.
Code: `lib/core/theme.dart` (tokens) and `lib/core/widgets/` (shared components).

## 1. Personality

- **Is:** calm, official, plain, warm (paper and ink), made for polling stations.
- **Looks like:** a printed ballot paper, a register ledger, a notice board. Colour bands per
  position, numbers in boxes, ruled lines, generous margins.
- **Is not:** a SaaS dashboard, a Material 3 sample app, a Stripe or Tailwind lookalike, a
  fintech app, a marketing landing page.

## 2. Do not use (explicit bans)

| Banned | Use instead |
|---|---|
| `ColorScheme.fromSeed` and every tonal colour it invents (blue-grey tints, purple-grey snackbars, surface tint) | An explicit `ColorScheme` built only from the tokens in section 3 |
| KPI / stat tiles ("Registered 4", "Checked in 3" in boxes) | A ledger: label left, number right, ruled line between rows (section 7) |
| Cards inside cards, coloured boxes inside cards | One surface level; separate groups with space, a heading and a 1 px rule |
| Shadows, elevation, glow, blur, gradients | Flat fills and 1 px rules |
| Material 3 default dialog (28 px radius, tinted surface), default snackbar, default spinner | The Rakubavote dialog, notice bar and progress line (section 6) |
| Any radius not in section 5 | Section 5 |
| Any font size not in section 4; weights other than 400 and 700 | Section 4 |
| Spacing values not on the scale (2, 3, 5, 6, 10, 14, 15, 18, 20, 28 are used today) | Section 5 |
| Placeholder shapes standing in for missing content (the empty gold circle on the booth welcome) | Leave the space out, or show the text it stands for |
| Icons without a word next to them on voter and check-in screens | Icon + label, or label only |
| Stock check, add, lock, arrow and "block" icons; ticks in circles | `BrandTick`, `TickBox`, `BrandIcon` (section 11) |
| Flat grey photo placeholders; pill-shaped progress bars; zoom or fade page transitions | Thatch hatch; roof bars; sideways slide (section 11) |
| Any decorative shape that is not a part of the mark | Section 11 only |
| Grey text below 4.5:1, white text on Thatch Gold or Light Thatch | `inkMuted` (section 3); Ink on thatch colours |
| Emoji, sparkles, robot imagery, stock photos of people at screens | Nothing, or real photos with consent |
| "Token", "submit", "success!", "error" in the interface | "Voting code", "Save", plain sentences (brand voice) |

## 3. Colour roles

Brand tokens (unchanged): nileBlue #1D4E89, acaciaGreen #1F5E3A, clay #A9521A, thatchGold #C8963E,
lightThatch #E6C27A, ink #1B1B1B, paper #F4F1EA.

| Role | Token | Value | Notes |
|---|---|---|---|
| Page background | `paper` | #F4F1EA | Admin, check-in, device setup, booth officer panel |
| Surface (one level only) | `card` | #FFFFFF | Panels, ballot rows, dialogs |
| Text | `ink` | #1B1B1B | 15.3:1 on paper |
| Secondary text | `inkMuted` (new) | #57524A | ≥ 6:1 on paper and white; replaces grey hints and small print |
| Rule / divider | `rule` (was `placeholder`) | #DDD6C6 | 1 px lines, photo placeholders |
| Control border | `border` | #8A8577 | Inputs, tick boxes, unselected rows (3:1 non-text contrast) |
| Primary action, links, selected, focus | `nileBlue` | | |
| Confirm, saved, done | `acaciaGreen` | | With a word or tick, never colour alone |
| Warning, problem, fee, destructive | `clay` | | With a word |
| Warning wash | `warningTint` | #FFF6E3 | Only behind a clay left bar |
| Success wash | `successTint` | #E7F2EA | End screen only |
| Disabled | `disabled` | #6E6A60 | Fill with white text 5.3:1, or text/border on paper 4.9:1 |
| Brand accents | `thatchGold`, `lightThatch` | | Logo, active admin tab (Ink text), never text colour |
| Ballot position colours | election data | | Contrast-checked; used for the band, selected border and tick |

## 4. Type scale

Atkinson Hyperlegible (Latin) → Noto Sans → Noto Sans Arabic; Arabic text starts with Noto Sans
Arabic (D13). Always through the theme or `RakubaType`, never a bare `TextStyle`.

| Name | Size / line height | Weight | Use |
|---|---|---|---|
| `display` | 48 / 56 | 700 | Voting code on the check-in screen, "End" |
| `title` | 32 / 40 | 700 | Position heading, booth screen titles, fingerprint codes |
| `name` | 26 / 32 | 700 | Candidate names, voter name at check-in |
| `heading` | 22 / 28 | 700 | Admin section headings, dialog titles |
| `bodyLarge` | 18 / 26 | 400 / 700 | Booth body text, buttons |
| `body` | 16 / 24 | 400 / 700 | Admin body, table cells, form fields |
| `label` | 14 / 20 | 400 / 700 | Field labels, table headers, small notes (minimum size) |

Seven sizes replace the 17 used today. Numbers that line up (voter numbers, counts, codes) use
tabular figures. Lines stay under about 60 characters (max width 640 px for running text).

## 5. Space, shape, lines

- **Spacing scale (px):** 4, 8, 16, 24, 32, 48, 64. Inside components 8/16; between groups 24/32;
  page margins 24 (tablet) and 32 (laptop).
- **Touch targets:** 64 px minimum on every touch screen; 48 px only for admin table actions on the
  laptop (mouse and keyboard).
- **Radius:** 4 only for the small admin tick box · 8 inputs, booth tick boxes and photos · 12 buttons and ballot rows · 16 panels and dialogs ·
  999 only for status pills and the Help button. Bars (progress, counts, roof lines) use a quarter
  of their height. Nothing else.
- **Lines:** 1 px `rule` for dividers and panel edges; 1 px `border` for inputs; 2 px for the
  booth's outlined buttons and focus/selected borders (3 px). No other widths.

## 6. Components and their states

Every interactive element defines all of these. Hover and focus matter: the laptop is used with a
mouse, a keyboard and a USB scanner that types.

| State | Treatment |
|---|---|
| Default | As below |
| Hover (mouse) | 8 % Ink overlay on the surface; cursor becomes a hand |
| Focus (keyboard) | 3 px Ink outline just outside the shape (a blue ring would vanish around blue buttons); never removed |
| Pressed | 16 % Ink overlay; no ripple spreading across the screen |
| Selected | 3 px border in the position colour (booth) or `nileBlue` (admin), plus a filled tick box with a white tick |
| Disabled | `disabled` text and border, no overlay, with a sentence saying why when the reason is not obvious |

- **Primary button:** filled `nileBlue` (or `acaciaGreen` for Confirm my vote / Save voter), white
  text, `bodyLarge` 700, radius 12, height 64. One per panel.
- **Secondary button:** booth: white fill, 2 px Ink border. Admin: white fill, 1 px `border`,
  `nileBlue` text. Destructive secondary: `clay` text and border.
- **Text action:** `nileBlue` 700 text, underline on hover; for low-priority admin actions
  (Move up, Edit) so rows are not walls of boxes.
- **Input:** white, 1 px `border`, radius 8, label above in `label` 700, help text below in
  `inkMuted`; focus = 2 px `nileBlue`; error = 2 px `clay` + clay sentence below.
- **Tick box:** 40 px (booth) / 24 px (admin), radius 8, 2 px `border`; ticked = filled, white tick.
- **Ballot row:** white, 2 px `border`, radius 12, the chosen border appears instantly (no animation); photo left, number box, symbol, name, tick box
  right (mockup 3). Same selected treatment in the two-candidate list and the 13-candidate grid.
- **Notice (inline):** no box. 4 px left bar in `clay` / `acaciaGreen` / `nileBlue`, then a bold
  first sentence and what to do next. Replaces the yellow outlined boxes.
- **Dialog:** white, radius 16, 32 px padding, `heading` title (voter Help dialog: `name` title, `heading`-size text), actions right-aligned
  (left in Arabic), primary last.
- **Saved message (snackbar):** Ink bar, paper text, `body`, radius 0, full width at the bottom.
- **Status pill:** radius 999, `acaciaGreen` or `clay` fill with white text, or Ink outline.
- **Admin navigation:** numbered steps "1 Setup · 2 Registration · 3 Review and lock ·
  4 Results"; active step lightThatch fill with **Ink** text; all four always visible.
- **Icons:** brand icons (`BrandIcon`, section 11) wherever one exists. Material Symbols outlined
  only for technical things the mark cannot draw (Wi-Fi, QR code, printer, USB, camera, delete,
  devices, help). 24 px, Ink or `nileBlue`, always with a word on voter and check-in screens.

## 7. Layout patterns

- **Admin page:** paper background, 32 px margins, a two-column grid (form 360 px, work area
  flexible). Panels are white with a 1 px `rule` edge and radius 16; no nesting.
- **Ledger (replaces stat tiles):** a list of rows `label …… number`, `body` text, numbers right
  aligned in tabular figures, 1 px rule between rows; a row that needs attention gets a clay
  left bar and a sentence. Used for review counts, reconciliation and results totals.
- **Results per position:** a colour band with the position name (like the ballot), then one row
  per candidate: number, name, count, a thin bar in the position colour; "No choice" last;
  a tie is a notice line under the band.
- **Booth:** follows mockups 2–5 exactly: white top strip with position count and Help, colour
  band, tinted list area, bottom bar with Back and Next.

## 8. Data states (every list, panel and screen that loads data)

| State | Pattern |
|---|---|
| Loading | One sentence of what is happening ("Opening the register…") and a 2 px `nileBlue` progress line at the top of the panel; no spinner in the middle of the page |
| Empty | One sentence of what will appear here and the action that fills it ("No voters yet. Register the first voter on the left.") |
| Error | Clay notice: what happened, in plain words, and what to do next; never a code |
| Success | Acacia tick + one sentence ("Saved. Voter No. 0001."); never "Success!" |

## 9. Logo

Approved (D26): a flat rakuba roof on two posts with a tick inside. Files and construction are in
`brand/` (written by `tool/brand_assets.py`); the mark is never redrawn or recoloured outside the
three versions there (full colour, on dark, one colour) and the app icon.

- Unit u = 1/30 of the mark. Roof 26u × 4u, posts 3u × 16u, bay 14u × 16u, tick 45° with arms
  1 : 2 and stroke 3u. Clear space 4u. Minimum size 24 px (mark), 120 px (mark with name).
- The wordmark is "Rakuba" in Ink and "vote" in Nile Blue (Paper and Light Thatch on dark), alone;
  role words sit beside it in plain text.
- In code the mark is `RakubaMark` and the logo `RakubaLogo` (`lib/core/brand/brand.dart`), drawn
  from the same numbers; `test/core/brand_test.dart` fails if they drift from `brand/`.
- Where it appears: the Ink top bar of admin, booth panel and check-in tablet (on-dark logo, role
  beside it); the brand panel of first run and PIN unlock; the closed-polls screen (one colour);
  beside "Powered by Rakubavote" on the booth welcome; launcher icons; the printed voter card.

## 10. Checks that keep this true

- `test/design_system_test.dart` scans `lib/` and fails on: a `Color(0x…)` outside `theme.dart`,
  a font size, radius or spacing value not on the scales, `ColorScheme.fromSeed`, `elevation`
  above 0, `BoxShadow`, gradients, and stock icons that have a brand icon (check, add, lock,
  arrows, block, vote).
- `test/core/brand_test.dart` fixes the mark's construction and the files in `brand/`.
- A component sheet (all buttons, inputs, ballot rows and notices in every state, English and
  Arabic) is rendered by `tool/screens.sh` before any screen work is reviewed.

## 11. Visual language (from the mark only)

Every graphic element comes from the mark's four parts (A roof, B posts, C tick, D the bay between
the posts), its one angle (45°) and its unit. Nothing else may be drawn. All of these are widgets
in `lib/core/brand/brand.dart`; use them, never a look-alike.

| Element | Widget | From | Use it for | Never |
|---|---|---|---|---|
| Tick | `BrandTick`, `DrawnTick` | C | Chosen, saved, done. The End screen draws it once | A stock check icon |
| Tick box | `TickBox` | C in a square | Ballot rows, chosen device mode, votes received from a booth | Circles with ticks |
| Roof line | `RoofLine` | A | Opening a screen or brand panel (8 px; corner = a quarter of its height) | Under every heading |
| Post rule | `PostRule` | A on B | Under every panel heading (built into `SectionCard`) | As a general divider in lists |
| Tick end | `TickEnd` | a rule + C | Closing something finished: the locked register, the completed count | Unfinished or open items |
| Band module | colour band over a white panel | A over D | Ballot positions, review cards, results per position | A thin accent stripe on a card |
| Shelter frame | `ShelterFrame` | A, B, D (7 : 8) | Identity photos: registration, voter details, check-in | Candidate photos (circles, as on the paper ballot) |
| Thatch hatch | `ThatchHatch` | 45° of C | Missing photos and empty image areas | Behind text; flat grey boxes instead |
| Mat weave | `MatWeave` | C repeated | Brand surfaces: the lower part of the first-run and unlock panel, covers | Behind text or on working screens |
| Colonnade | `Colonnade` | B under A | Footer that closes a sheet (results) | More than once per screen |
| Tally dots | `TallyDots` | round end of C | Small counts up to about 10 (choices made of N) | Large numbers; use the ledger |
| Roof bars | radius = height / 4 | A | Booth progress segments, result count bars | Pill-shaped progress bars |
| Brand icons | `BrandIcon` | A, B, C on the 30u grid | station, vote, results, voter card, check-in, secret (lock), next, back, add, tie, none (no choice), up, down | Stock icons for these meanings |

**Motion.** Things move only the way the mark is built: screens slide in sideways, along the roof;
the tick is drawn short arm first, then the long arm. Nothing zooms, bounces, spins or fades in
from nowhere. With animations turned off in the device settings everything appears complete.

**Brand panel.** First run and PIN unlock share `BrandShell`: an Ink panel (2 of 5 columns) with
the on-dark logo, a Light Thatch roof line, the tagline, and the mat weave in its lower part; the
form sits on Paper beside it. On narrow screens the panel becomes an Ink header.

**Still to do.** The printed voter card and register PDF carry the mark but keep their earlier
layout (round logo holder, dashed seal circle); they should be redrawn with the shelter frame and
roof line. The marketing site mockups (G) predate the brand.

## Changelog

- 2026-11-10: Visual language applied to all screens (D27); section 11 added; icons and bans updated.
- 2026-11-10: Logo approved (D26); section 9 rewritten.
- 2026-11-01: First draft from the screen audit against the MindStudio design-system guide.
- 2026-11-03: Ballot rows 2 px border; booth progress segments may be pills; voter Help dialog uses 26 / 22.
- 2026-11-03: Focus ring is Ink, not Nile Blue; radius 4 allowed for the small admin tick box.
- 2026-11-02: Approved (D25); logo section on hold until the project lead reworks the logo.

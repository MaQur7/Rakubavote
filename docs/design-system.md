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
  999 only for status pills and the Help button. Nothing else.
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
- **Ballot row:** white, 1 px `border`, radius 12; photo left, number box, symbol, name, tick box
  right (mockup 3). Same selected treatment in the two-candidate list and the 13-candidate grid.
- **Notice (inline):** no box. 4 px left bar in `clay` / `acaciaGreen` / `nileBlue`, then a bold
  first sentence and what to do next. Replaces the yellow outlined boxes.
- **Dialog:** white, radius 16, 32 px padding, `heading` title, actions right-aligned
  (left in Arabic), primary last.
- **Saved message (snackbar):** Ink bar, paper text, `body`, radius 0, full width at the bottom.
- **Status pill:** radius 999, `acaciaGreen` or `clay` fill with white text, or Ink outline.
- **Admin navigation:** numbered steps "1 Setup · 2 Registration · 3 Review and lock ·
  4 Results"; active step lightThatch fill with **Ink** text; all four always visible.
- **Icons:** Material Symbols outlined only, 24 px, Ink or `nileBlue`, always with a word on voter
  and check-in screens. Custom set later (ballot box, voter card, rakuba) as the brand asks.

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

**On hold (D25).** The project lead will choose and approve a reworked logo first, then define the
brand visual language around it. Until then the app keeps the current wordmark text and the board F
draft files in `brand/` unchanged, and no screen work in this document touches the logo.

## 10. Checks that keep this true

- `test/design_system_test.dart` scans `lib/` and fails on: a `Color(0x…)` outside `theme.dart`,
  a font size, radius or spacing value not on the scales, `ColorScheme.fromSeed`, `elevation`
  above 0, `BoxShadow`, gradients.
- A component sheet (all buttons, inputs, ballot rows and notices in every state, English and
  Arabic) is rendered by `tool/screens.sh` before any screen work is reviewed.

## Changelog

- 2026-11-01: First draft from the screen audit against the MindStudio design-system guide.
- 2026-11-03: Focus ring is Ink, not Nile Blue; radius 4 allowed for the small admin tick box.
- 2026-11-02: Approved (D25); logo section on hold until the project lead reworks the logo.

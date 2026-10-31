# Rakubavote Brand Guidelines

Oct 31, 2026 · Makur Majeng

> Converted from the original PDF. Visual examples are on board F: [docs/mockups/F-brand.png](mockups/F-brand.png).

Rakubavote is an offline voting platform for South Sudan; this guide keeps every screen,
card, receipt and poster looking and sounding the same.

## Brand story

Rakubavote brings voting into the rakuba: the shaded shelter of poles and grass where
people across South Sudan sit together, talk and decide.

**The name.** *Rakuba* is the open shelter found outside homes, schools and markets. It
belongs to no single community, it is open on all sides so everyone can see what happens
inside, and it protects people from the harsh sun. *Vote* says plainly what the app does.
Together: a fair, open place to choose.

**Promise.** Every eligible person votes once, in secret, and everyone can check the count.

**Values.**

- **Open:** like the rakuba, nothing is hidden; results, registers and code can be checked by anyone.
- **Fair to all:** neutral between candidates, parties, communities and languages.
- **Secret:** a vote can never be traced to a person.
- **Simple:** anyone can use it, including people who cannot read or have never used a touchscreen.
- **Grounded:** works offline, on solar power, with tools people already have.

**Tagline.** "Fair elections, in the shade of the community." Short form for screens and
posters: "Your vote, in the open."

## Name and logo

The logo is a rakuba roof on two posts sheltering a ballot box with a tick, next to the
wordmark "Rakubavote".

**Writing the name.** Always one word, capital R only: Rakubavote. Never "RakubaVote",
"Rakuba Vote" or "RAKUBAVOTE". In Arabic text, keep the Latin name; do not translate it.

**Versions** (see board F):

| Version | When to use |
|---|---|
| Full colour on light | Default: screens, voter cards, receipts with colour, posters |
| On dark | Dark headers (admin bar, voter card top strip) |
| One colour (black) | Thermal receipts, photocopies, stamps |
| App icon (mark only, blue square) | Tablet and laptop app icon, favicon |

In the wordmark, "Rakuba" is Ink and "vote" is Nile Blue on light; "vote" is Light Thatch on dark.

**Clear space.** Keep empty space around the logo equal to the height of the roof on every side.

**Minimum size.** Full logo: 32 mm wide in print, 120 px on screen. Mark only: 8 mm in print, 24
px on screen. On 58 mm thermal receipts use the one-colour mark at 10 mm.

**Don't:**

- Stretch, squash, rotate or add shadows, glows or gradients
- Change the colours outside the approved versions
- Put the logo on busy photos or patterned backgrounds
- Rearrange the mark and wordmark or redraw the roof
- Place it next to any party, candidate or government logo as if endorsing them; use
  "Powered by Rakubavote" in small text instead

The mark on board F is a first draft; a local designer should refine it, keeping the roof, two
posts and ballot box idea.

## Colour

The palette comes from the rakuba and its surroundings: thatch, clay, acacia, the Nile and
charcoal ink on paper.

| Name | HEX | RGB | CMYK | Use | Text contrast |
|---|---|---|---|---|---|
| Nile Blue | #1D4E89 | 29, 78, 137 | 79, 43, 0, 46 | Primary buttons, links, "vote" in wordmark | White text 8.4:1 |
| Acacia Green | #1F5E3A | 31, 94, 58 | 67, 0, 38, 63 | Confirm vote, success | White text 7.7:1 |
| Clay | #A9521A | 169, 82, 26 | 0, 51, 85, 34 | Warnings, fees, seal marks | White text 5.4:1 |
| Thatch Gold | #C8963E | 200, 150, 62 | 0, 25, 69, 22 | Logo roof, decorative only | Ink text 6.5:1; never white text |
| Light Thatch | #E6C27A | 230, 194, 122 | 0, 16, 47, 10 | Accents on Ink backgrounds | On Ink 10.1:1 |
| Ink | #1B1B1B | 27, 27, 27 | 0, 0, 0, 89 | Body text, headers, logo posts | On Paper 15.3:1 |
| Paper | #F4F1EA | 244, 241, 234 | 0, 1, 4, 4 | Page backgrounds | — |

**Rules.**

- All text must reach at least 4.5:1 contrast (WCAG AA); large text 3:1. The values above
  are calculated for these exact colours.
- Never put white text on Thatch Gold or Light Thatch.
- Colour is never the only signal: pair it with a word, number or icon (for example "Paid"
  plus green, not green alone).
- **Ballot position colours are functional, not brand colours.** Each election's positions get
  their own colours (as on the paper ballot), set in Election setup; the app checks their
  contrast. Avoid any party's colours for brand use.
- CMYK values are conversions for local printers; ask for a printed proof before large print runs.

## Typography

Two free font families cover everything: Atkinson Hyperlegible for Latin text and Noto
Sans Arabic for Arabic.

- **Atkinson Hyperlegible** (Google Fonts, free): designed for readers with low vision, so
  similar letters such as I, l and 1 stay distinct. Use Bold (700) for names, headings and
  buttons; Regular (400) for body text.
- **Noto Sans Arabic** (Google Fonts, free): for all Arabic text, right to left, same sizes as Latin.
- **Local languages** written in Latin letters (for example Dinka with ɛ, ɔ, ŋ): check that
  every special letter displays correctly in Atkinson Hyperlegible; if any are missing, fall
  back to Noto Sans for that language.
- **Fallback** when fonts cannot load: the system sans-serif.
- Bundle the font files inside the app, because stations are offline.

| Use | Size (screen) | Size (print) | Weight |
|---|---|---|---|
| Position heading on ballot | 30–36 px | — | Bold |
| Candidate name | 24–28 px | 14 pt | Bold |
| Body and instructions | 16–18 px | 11 pt | Regular |
| Labels and small notes | 14 px minimum | 9 pt minimum | Regular |
| Receipt text (58 mm thermal) | — | 10 pt minimum | Bold for names |

Write in sentence case ("Confirm my vote"), never all capitals, left-aligned (right-aligned
for Arabic), with no more than about 60 characters per line.

## Voice and tone

Rakubavote speaks like a calm, respected polling officer: plain, polite, neutral and brief.

- **Plain:** short sentences, everyday words, one instruction at a time. "Tap one candidate",
  not "Please make your selection from the available options".
- **Neutral:** never praise, rank or hint at a candidate, party or community. No slogans for or
  against anyone.
- **Respectful:** address the voter as "you"; never blame ("That code was not found. Check
  your slip or ask an official", not "Invalid token").
- **Reassuring about secrecy:** repeat that the vote is secret at the start and the end.
- **Same meaning in every language:** translate meaning, not word for word; have each
  translation checked by a native speaker from a different community than the translator.

| Say | Don't say |
|---|---|
| Your vote is secret. | Your data is protected by Ed25519 signatures. |
| No choice for this position | Abstain / Null vote |
| Thank you. Your vote has been recorded. | Success! Vote submitted 🎉 |
| Ask an official if you need help. | Contact support. |
| This voter has already received a token. | ERROR 409: duplicate check-in |

The Arabic sample on board F ("your vote is a trust") is a placeholder; confirm the final
Arabic and local-language phrases with native speakers.

## Imagery and icons

Rakubavote should look made in South Sudan, by people who know paper ballots and
polling stations, not generated by a template.

**Photography.** Real photos of South Sudanese voters, officials and polling stations, taken
with written consent. Show a mix of ages, genders, communities and places (towns and
rural areas). Never show a voter's screen or ballot choice, and never show candidates or
party symbols in brand materials.

**Icons.** Simple line icons with rounded ends, 2.5 px stroke at 24 px, in Ink or Nile Blue. Draw
a small custom set for things stock icons get wrong: ballot box, voter card, receipt, sealed
box, solar panel, rakuba. Every icon on a voter screen has a text label next to it.

**Shapes and layout.** Flat colour fills, generous spacing, rounded corners (12–16 px on cards,
999 px for pills). Layouts follow the paper ballot people already know: colour band per
position, photo on the left, tick box on the right.

**Avoiding the AI-generated look:**

- No purple, pink or blue gradient washes, glowing effects or glass blur
- No 3D blob illustrations, floating devices or stock images of people pointing at screens
- No emoji in the interface
- No generic "sparkle" or robot imagery; Rakubavote is a tool run by people
- Prefer texture from real materials (thatch, woven mats) used sparingly in posters, never behind text

## Applications and governance

The brand appears on six main items; each organization's own name and logo always
comes first, with Rakubavote in a supporting role.

| Item | Organization brand | Rakubavote brand |
|---|---|---|
| Voting booth screens | Header: organization name and logo, election name | "Powered by Rakubavote" on the welcome screen only |
| Check-in and admin screens | Election name | Rakubavote name in the top bar |
| Voter registration card | Top strip: organization name, logo, election | Small wordmark top right |
| Paper receipt (thermal) | Election name | One-colour mark at the bottom, 10 mm |
| Results sheet (A4) | Organization header, signatures, seal | Footer: Rakubavote mark and fingerprint code |
| Posters and training material | Optional | Full logo and tagline |

**Co-branding.** For party primaries, never place Rakubavote beside a party logo as a pair;
use the party's materials with "Powered by Rakubavote" in small text. Offer the same
treatment to every party.

**Governance.**

- One brand owner (the project lead) approves new logo uses, colours and translations.
- Logo files (SVG, PNG on light and dark, one-colour) and fonts live in the GitHub
  repository under `brand/`, so Claude Code and designers use the same files.
- Review these guidelines after the school pilot and update them with what confused users.
- In code, colours and fonts are defined once as named tokens (for example `nileBlue`,
  `acaciaGreen`) and used everywhere; never type hex codes directly into screens.

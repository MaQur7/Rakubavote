# Station protocol

How the station laptop and the tablets talk. Implemented in `lib/station/`. Everything stays
inside the polling station: the laptop runs a `shelf` HTTP and WebSocket server (default port
47800) on the station Wi-Fi (travel router or laptop hotspot). No internet, no outside service.

## Roles

| Role | Device | Talks to |
|---|---|---|
| Station admin | Laptop | Runs the server; holds `registry.db`; receives vote batches |
| Check-in | Laptop (built-in desk), or a paired tablet | Laptop |
| Booth | Android tablet | Laptop |

## Pairing (`lib/station/pairing.dart`)

1. On the laptop: **Devices → Start the station network → Show pairing code**. The code is
   8 Crockford characters (40 bits), valid 10 minutes, shown as text and as a QR code holding
   `RKVP1|<host>|<port>|<code>|<laptop id>`.
2. On the tablet: **Connect to the laptop**, scan the QR (Android camera) or type the address and
   code. The tablet calls `GET /hello` (laptop public keys), checks the laptop id when it came from
   the QR, then `POST /pair` with its role, label, Ed25519 and X25519 public keys and
   `HMAC-SHA256(code, canonical{role,label,signing,exchange,station})`. Five wrong codes disable
   the code.
3. The laptop lists the request with the tablet's device id; the tablet shows the same id. The
   officer compares and presses **Approve**. The enrolment is written to the audit log. The
   tablet polls `GET /pair/<request>` and stores the link (`station.json`: address and the
   laptop's public keys only).

## Channel (`lib/station/channel.dart`)

Shared key per device: HKDF-SHA256 over X25519(laptop, device), salt = both device ids sorted,
info `rakubavote-channel-v1`. Every message after pairing is an envelope:

```json
{"type": "...", "election": "...", "device": "<sender id>", "seq": 1730458123456789,
 "nonce": "...", "body": "<AES-256-GCM ciphertext + tag>", "sig": "<Ed25519 over all fields>"}
```

`seq` is a monotonic microsecond counter; replays and older sequence numbers are rejected. The
AES-GCM associated data binds type, election, sender and seq.

## Requests (`POST /rpc`, one envelope in, one envelope out)

| Type | Allowed role | Purpose |
|---|---|---|
| `ballot.get` | any paired | Ballot package (signed ballot + images by hash) |
| `checkin.search` / `checkin.card` | check-in | Find a voter (name/number, or voter card QR) |
| `checkin.issue` / `checkin.manual` | check-in | Check in; the reply holds the one-time code |
| `checkin.counts` | check-in | Checked in / registered |
| `batch.submit` | booth | Signed vote batch (verified against the booth's enrolled key) |

Errors come back as an encrypted `error` envelope with a code (for example `alreadyCheckedIn`).
Unpaired or removed devices get HTTP 403.

## Live events (`GET /events`, WebSocket)

The device first sends a `hello` envelope (a booth includes the hashes of codes it used while
disconnected). Then:

| Event | Direction | Content |
|---|---|---|
| `polls.state` | laptop → all | `polling` / `closed`; on `closed` a booth stops and sends its batch |
| `token.sync` | laptop → booth (on connect) | All active code hashes, sorted |
| `token.activate` | laptop → booths | One new code hash (never the code, never a voter) |
| `token.used` | booth → laptop → other booths | One code hash |

The laptop watches its issued-codes table, so a code from any check-in desk reaches the booths.
Votes are **not** streamed during polling; booths keep them until the polls close.

## Ballot package (USB) — `.rkvballot`

`{"type":"rakubavote-ballot-package","v":1,"station":<laptop Ed25519 key>,"ballot":<signed
ballot>,"media":{<sha256>:<base64url image>}}`. The booth verifies the signature, every image
hash and that every hash the ballot refers to is present. The first package pins the laptop's
key (D19). No personal data.

## Vote batch (USB fallback) — `rakubavote-votes-<booth>-<fingerprint>.json`

The booth's signed batch artifact (D12), saved from the booth panel with **Save votes to USB**
and loaded on the laptop with **Import votes from USB**. Same checks as over Wi-Fi.

## When Wi-Fi fails

- Booths keep the votes they already recorded. They cannot accept new codes until Wi-Fi is back
  (live activation, D1). Used codes are reported on reconnect.
- Votes can always be moved by USB.
- **Not built yet:** the pre-loaded code pool that D1 allows with the officer PIN, and moving
  results by multi-part QR codes. Until then, keep the station router powered.

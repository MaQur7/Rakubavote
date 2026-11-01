# Station protocol

How the station laptop and the tablets talk. Implemented in `lib/station/`. Everything stays
inside the polling station: the laptop runs a `shelf` HTTP and WebSocket server (default port
47800) on the station Wi-Fi: the laptop's own hotspot or any phone hotspot, **without internet**
(D23). No outside service is ever contacted.

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
| `token.pool` | laptop → booth (on connect and when the pool grows) | All pre-loaded code hashes, sorted (D23) |

The laptop watches its issued-codes table, so a code from any check-in desk reaches the booths.
Votes are **not** streamed during polling; booths keep them until the polls close.

## Ballot package

`{"type":"rakubavote-ballot-package","v":1,"station":<laptop Ed25519 key>,"ballot":<signed
ballot>,"media":{<sha256>:<base64url image>}}`, delivered only by `ballot.get` over the paired
channel. The booth verifies the signature, every image hash and that every hash the ballot refers
to is present. The first package pins the laptop's key (D19). No personal data.

## No USB inputs (D23)

Ballots, codes and votes travel only over the paired, encrypted station network. There is no
USB or QR path for anything that affects the count. Outputs only: the signed results file, the
encrypted backup and PDFs.

## When Wi-Fi fails: the pre-loaded code pool (D1, D23)

1. Before the polls open, while every booth is connected, the presiding officer presses
   **Prepare code pool** on the laptop: one code per registered voter plus 5% (at least 10).
   Plain codes stay on the laptop (encrypted database); booths receive only the hashes
   (`token.pool`). Pool hashes do nothing at a booth on their own.
2. From then on every code the check-in desk issues is drawn at random from the pool, and its
   plain text is erased from the laptop as it is issued. It is also activated live as usual.
3. If a booth loses Wi-Fi, its officer presses **Wi-Fi is down: use pre-loaded codes** and enters
   the officer PIN. The switch is written to the booth's audit log. The booth then accepts pool
   codes it has not seen used.
4. When the booth reconnects it reports the codes it used; the laptop marks them used and tells
   the other booths. At closing, a code used at two booths, or a pool code used without being
   issued, is flagged on the results screen.

Votes stay on the booth until it reconnects; bring the tablet within range of the hotspot to
close.

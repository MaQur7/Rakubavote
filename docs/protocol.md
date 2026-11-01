# Station protocol (draft)

Status: design agreed before milestone 1; implemented in milestone 6. Update this file with
the code.

All traffic stays inside the polling station. The laptop runs a `shelf` HTTP and WebSocket
server on the local Wi-Fi (travel router or laptop hotspot). There is no internet requirement
and no outside service.

## Roles

| Role | Device | Talks to |
|---|---|---|
| Station admin | Laptop | Runs the server; holds `registry.db`; receives batches |
| Check-in | Laptop, or tablet paired to it | Laptop |
| Booth | Android tablet | Laptop |

## Pairing

1. The officer opens *Add a device* on the laptop. It shows a QR code containing the laptop
   address and port, the station's Ed25519 and X25519 public keys, the election id and a
   one-time pairing secret (valid 5 minutes).
2. The tablet scans it and sends `POST /pair` with its own public keys, the role it is set up
   for, and an HMAC of its keys under the pairing secret.
3. The laptop shows the tablet's short device id; the officer confirms it matches the tablet
   screen and approves. The enrolment is written to the audit log.
4. Both sides derive a per-device AES-256-GCM key: HKDF-SHA256 over X25519(station, device).

## Envelope

Every message after pairing:

```json
{"type": "...", "election": "...", "device": "<device id>", "seq": 17,
 "nonce": "...", "body": "<AES-GCM ciphertext>", "sig": "<Ed25519 over everything above>"}
```

`seq` increases per device and direction; replays and old sequence numbers are rejected.

## Ballot package (USB, available now)

`rakubavote-ballot-<fingerprint>.rkvballot` is canonical JSON:
`{"type":"rakubavote-ballot-package","v":1,"station":<laptop Ed25519 public key>,
"ballot":<signed ballot artifact>,"media":{<sha256>:<base64url image>}}`.
The booth verifies the signature, every image hash and that every hash the ballot refers to is
present. The first package pins the laptop's key (D19). It holds no personal data.

## Endpoints

| Call | Who | Purpose |
|---|---|---|
| `GET /hello` | any | Station name, election id, state, public keys (no secrets) |
| `POST /pair` | new device | Pairing (above) |
| `GET /ballot` | booth, check-in | Signed ballot + candidate photos/symbols (verified by hash) |
| `GET /register` | check-in only | Signed locked register + voter photos |
| `POST /checkins` | check-in tablet | Check-ins and issued code hashes (when check-in is not on the laptop) |
| `WS /events` | booths, check-in | Live events (below) |
| `POST /vote-batch` | booth | Signed vote batch at closing |

## Live events (`WS /events`)

| Event | Direction | Content |
|---|---|---|
| `polls.opened` / `polls.closed` | laptop → all | State change; booths lock on close |
| `token.activate` | laptop → booths | One code hash. Never the code, never a voter |
| `token.used` | booth → laptop → other booths | One code hash |
| `token.sync` | laptop → booth (on reconnect) | Current set of active code hashes, sorted |
| `heartbeat` | both | Battery, paper status, connection |

Votes are **not** streamed during polling; booths keep them until closing. This avoids a
timing link between a check-in and a vote arriving at the laptop.

## When Wi-Fi fails

- Booths cannot accept new codes until Wi-Fi is back (live activation, decision D1).
- The presiding officer may switch a booth to the **pre-loaded code pool** with the officer
  PIN. The switch is audit-logged, and closing reports any code used at two booths or never
  issued.
- **USB:** the same signed envelopes are written as `.rkv` files (ballot, register, vote
  batches, results). Import checks enrolment and signatures exactly as over Wi-Fi.
- **QR:** pairing, results, fingerprints and small vote batches can move as a numbered
  sequence of QR codes (`RKVQ/<part>/<total>/<data>`), reassembled and verified as a whole.

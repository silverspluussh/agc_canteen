# Internal CA (trust anchor)

`asantegold-ca.crt` is the Asante Gold AD root CA that signs the Caddy leaf for
`https://cmsystem.asantegold.local` and is bundled into the app so the internal
CA is trusted on Android/iOS.

- Subject / Issuer (self-signed root): `DC=local, DC=AsanteGold, CN=AsanteGold-CHI-ACA-01`
- SHA-256 fingerprint: `F3:1E:B0:3F:CE:2D:97:26:9A:D7:26:AC:4A:9C:DA:09:B8:0E:2E:E7:38:D5:1F:46:85:DE:C6:95:20:C8:09:F7`
- Valid: 2024-03-18 → 2044-03-18

`DioClient.configureTrust()` loads this file at startup to trust the internal CA.

Do NOT put the leaf certificate or any private key in the app.

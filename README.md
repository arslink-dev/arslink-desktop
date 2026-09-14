# ArsLink

Cross-platform desktop GUI utility for connecting to your own network infrastructure.

ArsLink is a client application. **It does not provide servers, subscriptions, or any network service.**
It works exclusively with configurations you already have — your own servers, or a subscription link
from any provider you choose.

## What it does

- Import configurations from subscription links, share links, QR codes or JSON
- Manage and switch between server configurations
- Route traffic per application or per rule
- System proxy and TUN modes
- Connection latency testing and traffic statistics

## Supported platforms

| Platform | Notes |
|---|---|
| Windows 10 / 11 | x64 |
| Windows 7 SP1 / 8 / 8.1 | x64, separate legacy build |
| Linux | planned |
| macOS | planned |

Builds are published on the [Releases](https://github.com/arslink-dev/arslink-desktop/releases) page.

Windows builds are currently unsigned, so Windows SmartScreen will show a warning on first run.
Verify the SHA-256 checksum published with each release.

## Privacy

ArsLink collects no telemetry. No configurations, server addresses, usage statistics or identifiers
are sent anywhere. Logs stay on your device.

## Built on

ArsLink is a fork of [Throne](https://github.com/throneproj/Throne) (GPL-3.0), which itself continues
the archived [NekoRay](https://github.com/MatsuriDayo/nekoray) project. All copyright notices of the
original authors are preserved.

Cores: [sing-box](https://github.com/SagerNet/sing-box) and [Xray-core](https://github.com/XTLS/Xray-core).
Built with [Qt](https://www.qt.io/).

A complete list of our changes relative to upstream is kept in [IZMENENIYA.md](IZMENENIYA.md),
and the exact upstream revision this fork started from is recorded in [PROISHOZHDENIE.md](PROISHOZHDENIE.md).

## License

GPL-3.0, inherited from Throne. See [LICENSE](LICENSE).

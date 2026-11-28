# Privacy Policy — Streamore

**Last updated:** 2026-11-28

Streamore is a generic OTT player developed by Guillermo Linares Borrego ("the developer"). This policy describes what data the Windows and Android apps handle.

## Data collected by the developer

None. The app contains **no telemetry, analytics, advertising identifiers, crash reporting, usage statistics, accounts created by us, or in-app purchases**. We do not operate any backend that receives your data.

## Data you provide

If you choose to connect your own Xtream provider, you enter a **server URL, username and password**. These values:

- are stored **locally on your device** using the platform secure storage (Windows Credential Manager / DPAPI on Windows, encrypted preferences on Android);
- are used only to authenticate against **the server you entered** and to request the catalog and streams you select;
- are never logged and are never sent to any server operated by the developer (there is none);
- can be removed at any time by clearing your credentials in the app or by uninstalling it.

**Demo Mode** requires no account and stores no credentials.

## Data stored locally

- **Watch progress** (item identifier, position and timestamp) is kept in local app preferences. It does not contain credentials or playback URLs.
- The media player and image cache may store media data locally to speed up playback.

All of this stays on your device and is removed when you uninstall the app.

## Network access

The app communicates only with:

1. the Xtream server **you** configured, and
2. public URLs used by Demo Mode (open films from the Blender Foundation).

Some Xtream providers offer only plain HTTP. If you configure such a server, traffic to it is not encrypted. The developer does not proxy, record or inspect that traffic.

## Third-party components

Playback uses [media_kit](https://github.com/media-kit/media-kit) with libmpv (LGPL-2.1+). Demo Mode streams open films by the [Blender Foundation](https://www.blender.org/about/projects/) (CC BY). Their respective terms apply to those components.

## Your choices

- Use **Demo Mode** instead of signing in.
- Clear your credentials in the app, or uninstall it to remove all locally stored data.

## Contact

For privacy questions, contact the developer privately via **GitHub → Security tab → Report a vulnerability** at <https://github.com/Glinbor10/streamore>.

## Changes

Updates to this policy will be published at this same URL.

---

## Versión en español

**Datos recopilados por el desarrollador:** ninguno. La app no tiene telemetría, analítica, publicidad, estadísticas de uso, cuentas propias ni compras integradas. El desarrollador no opera ningún servidor que reciba tus datos.

**Datos que aportás:** si conectás tu propio proveedor Xtream, ingresás servidor, usuario y contraseña. Se guardan **solo en tu dispositivo** mediante almacenamiento seguro del sistema (Windows Credential Manager / DPAPI en Windows), se usan únicamente para autenticarte contra **ese servidor** y nunca se registran ni se envían a un servidor del desarrollador. El **Demo Mode** no pide credenciales.

**Datos locales:** el progreso de reproducción y la caché multimedia se guardan localmente; no incluyen credenciales ni URLs de reproducción. Se eliminan al desinstalar la app.

**Red:** la app solo se conecta al servidor que configuraste y a las URLs públicas de los videos de demostración de Blender Foundation. Algunos proveedores usan HTTP sin cifrar; en ese caso el tráfico hacia ese proveedor no está cifrado.

**Contacto:** GitHub → pestaña Security → Report a vulnerability, en <https://github.com/Glinbor10/streamore>.

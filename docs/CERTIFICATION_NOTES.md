# Microsoft Store certification notes — Streamore

Use this as the **"Notes for certification"** text when submitting the MSIX package.

---

Streamore is a generic OTT player with a Netflix-style interface. **It does not include, bundle, host, recommend or link to any copyrighted video content or pirate service.**

For evaluation, no account is required:

1. Open the app.
2. Click **Demo Mode** on the sign-in screen.
3. A fictional catalog is shown (fictional titles and generated artwork). Every item plays an open film from the **Blender Foundation** (CC BY) as a placeholder.

The app only connects to an Xtream server **explicitly entered by the user**. No server address, username or password is shipped with the package, and no credentials are included in the submission.

- No in-app purchases, subscriptions, ads, analytics or telemetry.
- No user accounts are created by the developer.
- Xtream credentials are stored locally with the platform secure storage (Windows Credential Manager / DPAPI) and are never logged or sent to a developer-operated server.
- Watch progress is stored locally and contains no playback URLs or credentials.
- `runFullTrust` is required because playback uses the Win32 `media_kit`/libmpv engine and credentials use the Windows Credential Manager.
- Some Xtream providers only offer plain HTTP; the app allows the user to configure such a server. Traffic goes directly to the server the user chose.

Privacy policy: <https://raw.githubusercontent.com/Glinbor10/streamore/main/docs/PRIVACY.md>

Contact: GitHub → Security tab → Report a vulnerability, <https://github.com/Glinbor10/streamore>.

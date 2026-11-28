# Plan: Streamore — OTT Player (Android móvil + Windows)

## Protocolo Obligatorio antes de escribir código (OpenSpec / SDD)
**REGLA CRÍTICA:** Tienes estrictamente prohibido escribir código de aplicación (`lib/`, `test/`, `android/`, `windows/`) o ejecutar comandos de creación/instalación sin haber completado antes estos 3 pasos con el usuario:

1. **Alineación previa ("Cómo hacerlo bien"):** Antes de iniciar cualquier fase o cambio, analiza el problema, propón las mejores prácticas y herramientas disponibles para resolverlo de forma limpia y pregunta al usuario si está de acuerdo con el enfoque.
2. **Creación de artefactos OpenSpec:** Una vez acordado el enfoque, genera la estructura estándar de OpenSpec dentro de `openspec/changes/<nombre-del-cambio>/`:
   - `proposal.md`: Qué se va a construir, por qué, alcance y criterios de éxito.
   - `design.md`: Arquitectura, paquetes elegidos, decisiones técnicas y diagramas de flujo/estado.
   - `specs/<dominio>/spec.md`: Requisitos funcionales y escenarios de aceptación (`Given / When / Then`).
   - `tasks.md`: Lista ordenada y atómica de tareas de implementación y verificación.
3. **Aprobación explícita:** Presenta un resumen de los documentos OpenSpec generados y **espera la confirmación explícita del usuario** ("Aprobado", "Adelante", etc.) antes de empezar a programar.

---

## Contexto y objetivo
App reproductora OTT genérica con estética tipo Netflix para **Android móvil** y **Windows Desktop**, pensada como proyecto público de porfolio en LinkedIn.
- **Filosofía de desarrollo:** Pragmática. Apoyarse al máximo en paquetes maduros y bien mantenidos en lugar de reinventar parsers, modelos o controles de reproductor desde cero.
- **Distribución lista para descargar:** El repositorio debe generar binarios instalables y listos para usar (**`.apk`** para Android y **`.exe`** para Windows) en la sección **GitHub Releases**, permitiendo que cualquiera descargue y pruebe la app directamente en Modo Demo o con su propia cuenta.
- **Cumplimiento y privacidad:** El repositorio es 100 % genérico, bajo licencia **MIT**, sin contenido preconfigurado ni datos reales de ningún proveedor.

## Stack tecnológico (herramientas de alto nivel)
- **Framework:** Flutter (Material 3, tema oscuro por defecto estilo cine/Netflix).
- **Cliente IPTV / Xtream:** `xtream_code_client` (v2.x) — gestiona autenticación, parseo resiliente (*lenient*), descarga de catálogos en *Isolates* en segundo plano y generación de URLs de reproducción.
- **Reproductor de vídeo:** `media_kit` + `media_kit_video` (`libmpv`) — usando los controles integrados `MaterialVideoControls` (Android) y `MaterialDesktopVideoControls` (Windows).
- **Estado y navegación:** `riverpod` + `go_router`.
- **UI y caché:** `cached_network_image`, `skeletonizer` (para placeholders de carga tipo Netflix) y `flutter_secure_storage` (para credenciales).

## Decisiones de producto
- **Login MVP:** 3 campos estándar (**Servidor + Usuario + Contraseña**, estilo Xtream Codes) + un botón secundario de **"Modo Demo"** (carga un JSON local con vídeos libres de derechos de Blender Foundation para que cualquier persona en LinkedIn pueda probar la app sin tener cuenta propia).
- **Navegación adaptativa:** `LayoutBuilder` que alterna entre `NavigationBar` inferior (móvil < 600px) y `NavigationRail` lateral (Windows >= 600px) con 3 secciones: **TV en vivo**, **Películas** y **Series**.
- **Diseño por sección:**
  - **TV en vivo:** Filtro rápido por categoría + lista/cuadrícula de canales con logo y badge `EN VIVO`. Clic directo abre el reproductor (en Windows, vista dividida opcional con lista a la izquierda y visor a la derecha).
  - **Películas (VOD):** *Hero Banner* destacado con degradado oscuro + filas horizontales por género con carátulas 2:3. Al pulsar abre ficha de detalle con sinopsis y botón Play/Reanudar.
  - **Series:** Catálogo con carátulas 2:3 + ficha de serie con selector de temporadas y listado de episodios en tarjetas 16:9 con barra de progreso y salto al siguiente episodio.
- **Alcance fuera del MVP:** Android TV / D-Pad, guía EPG compleja, favoritos, descargas offline y multi-perfil.
- **Convenciones:** Nombre de proyecto `Streamore`, carpeta `C:\Users\glinares\Desktop\streamora`, repo inicial **privado**, código y commits en inglés, sin atribución a IA en los mensajes de commit.

## Reglas técnicas obligatorias (evitar errores conocidos)
1. **User-Agent en peticiones y vídeo:** Muchos servidores Xtream bloquean el `User-Agent` por defecto de Dart (`Dart/3.x (dart:io)`). Configurar un `User-Agent` estándar de reproductor (ej. `IPTVSmartersPlayer` o `Lavf/60.16.100`) tanto en la inicialización del cliente HTTP como en las `httpHeaders` al abrir cada `Media` en `media_kit`.
2. **Scroll con ratón en Windows:** Envolver `MaterialApp` en un `ScrollConfiguration` personalizado que habilite `PointerDeviceKind.mouse` y `PointerDeviceKind.touch` para que las filas horizontales de carátulas se puedan arrastrar y desplazar cómodamente en Windows.
3. **Rendimiento en listas grandes:** Los catálogos Xtream superan los 10.000 elementos. Usar siempre `ListView.builder` / `GridView.builder` con `cacheExtent` acotado y filtrado por categoría en memoria sin reconstruir toda la pantalla.
4. **Empaquetado Windows completo:** En Windows, `flutter build windows --release` genera `streamora.exe` junto a varias `.dll` obligatorias (`flutter_windows.dll`, `mpv-2.dll`, etc.). Para las Releases, empaquetar toda la carpeta `build\windows\x64\runner\Release\` en un instalador único **`streamore-windows-setup.exe`** (mediante Inno Setup en CI) y/o un `.zip` portable para que el `.exe` nunca falle por DLLs faltantes.

## Fases de desarrollo (1 PR por fase, precedida siempre por OpenSpec)
- **Fase 1 — Base, OpenSpec inicial y CI:**
  - *OpenSpec (`01-project-setup`):* Acordar estructura de carpetas (`features/auth`, `features/catalog`, `features/player`, `shared`), convenciones de lint y pipeline de CI.
  - *Implementación:* Crear proyecto Flutter (`platforms=android,windows`), configurar `LICENSE` (MIT), `.gitignore`, `openspec/project.md` y GitHub Actions (`flutter analyze`, `flutter test` y build de verificación Android/Windows).
- **Fase 2 — Autenticación y Modo Demo:**
  - *OpenSpec (`02-auth-and-demo`):* Definir flujo de login, normalización de URL, almacenamiento seguro en `flutter_secure_storage`, manejo de errores y datos del Modo Demo offline.
  - *Implementación:* Pantalla de login, integración con `xtream_code_client`, Modo Demo y tests unitarios/widget.
- **Fase 3 — Catálogo y búsqueda:**
  - *OpenSpec (`03-catalog-and-search`):* Definir modelos de dominio, estrategia de caché en memoria para +10.000 items, filtrado por categorías y búsqueda instantánea.
  - *Implementación:* Repositorios de Live TV, Películas y Series (con temporadas/episodios) sobre `xtream_code_client` y tests con fixtures JSON ficticios.
- **Fase 4 — UI estilo Netflix y navegación adaptativa:**
  - *OpenSpec (`04-adaptive-netflix-ui`):* Definir sistema de diseño oscuro, breakpoints (`< 600px` vs `>= 600px`), *Hero Banner*, vistas diferenciadas por sección y estados de carga (`skeletonizer`).
  - *Implementación:* Pantallas principales, navegación adaptativa (`NavigationBar` / `NavigationRail`) y scroll habilitado para ratón en Windows.
- **Fase 5 — Reproductor multiplataforma:**
  - *OpenSpec (`05-media-player`):* Definir integración de `media_kit`, inyección de `User-Agent`, controles por plataforma y persistencia local del progreso ("Seguir viendo").
  - *Implementación:* Pantalla de reproducción para directos (`.ts`/`.m3u8`) y VOD (`.mp4`/`.mkv`), controles nativos de móvil/escritorio y reanudación automática.
- **Fase 6 — Releases (APK + EXE) y publicación en LinkedIn:**
  - *OpenSpec (`06-releases-and-launch`):* Definir estrategia de firmado Android, empaquetado Inno Setup para Windows, checklist de auditoría de seguridad y estructura del README.
  - *Implementación:* Workflow de **GitHub Releases** (disparado por tags `v*`) que publique `streamore-android-vX.Y.Z.apk`, `streamore-windows-vX.Y.Z-setup.exe` y `streamore-windows-vX.Y.Z-portable.zip`, README en inglés con capturas del Modo Demo y auditoría de historial Git antes de hacer público el repositorio.

## Reglas de seguridad y auditoría
- **Prohibido** escribir URLs reales de servidores IPTV, usuarios, contraseñas o keystores privados en el código, especificaciones OpenSpec, fixtures de test, ISSUES, PRs o capturas de pantalla.
- Verificar que `git config user.email` usa el correo personal de GitHub y no el corporativo antes del primer commit.
- Antes de hacer público el repositorio, ejecutar una búsqueda en todo el historial (`git log -p -S "..."`) para garantizar cero fugas de datos personales o de proveedor.
---
## Plan changes after phase 5 (agreed with the owner)
- Brand colors: navy blue + electric cyan instead of red.
- New logo (play made of waves) and app icon.
- Modern navigation inspired by Trade Republic / Revolut (floating pill bar) and Stremio (content-first, slim rail).
- Tracked in `openspec/changes/06-brand-and-modern-ui`.

# website — WORKFLOW

Static content of **we-the-greeks.world**. ⚠️ **The live IIS site is NOT a pure static site**: the IIS site `we-the-greeks.world` (W server 10.66.66.210, behind nginx at 45.66.43.245) serves the **Democracy.Web backend** from `C:\inetpub\wwwroot` — the mobile app's REST API lives at `https://we-the-greeks.world/api`. The static pages (landing, presentation, legal) are subfolders/files inside that same folder, served alongside the app.

## Deploy flow

1. Edit locally in `C:\ProjectRepos\WeTheGreeks\website`
2. Commit on `main`, push to GitHub (`geosalonica/we-the-greeks-website`, public)
3. On the server (RDP), run `F:\AI\Projects\WeTheGreeksLiveSite\deploy.cmd` — it pulls this repo into the staging checkout at `F:\AI\Projects\WeTheGreeksLiveSite` and robocopy-mirrors **only the static subfolders** (`presentation`, `legal`, `el`, `en`) into `C:\inetpub\wwwroot`. Publishing is manual and user-controlled.

## Hard rules

- **NEVER make `C:\inetpub\wwwroot` a git checkout of this repo** and never copy this repo's root `web.config` or root `index.html` there — that would overwrite the backend's `web.config` (ASP.NET Core module config) and take the API down. This happened on 2026-08-11 by repointing the site's physicalPath at a static checkout; mobile login broke until the path was reverted.
- The site's physicalPath stays `C:\inetpub\wwwroot`. Don't "move" it to separate the static site — the backend lives there.
- Backend deployment is a separate concern (repo `WeTheGreeks\backend\democracy`).

## Contents

- `index.html` — placeholder landing page (root `index.html` in wwwroot is managed manually, not by deploy.cmd)
- `presentation/` — pitch-deck slide viewer (WebP frames + vanilla-JS crossfade viewer; frames generated from `apothetirio\ppt\webbuild\web_deck.pptx`)
- `legal/` — terms, privacy, moderation in el+en; **URLs must keep working** (mobile app `legal_links.dart` and store listings point at them)
- `el/terms/terms-el.html`, `en/terms/terms-en.html` — older standalone terms pages, kept at their original URLs
- `deploy.cmd` — the server-side publish script described above
- root `web.config` — only relevant if the repo is ever served standalone; NOT deployed to wwwroot

## IIS notes

- `.webp` works via `presentation/web.config` mimeMap (and ASP.NET Core static middleware knows it natively).
- Mobile app dependencies on this host: `https://we-the-greeks.world/api/*` (backend), `/legal/el/*.html` (legal links). Zitadel is `auth2.we-the-greeks.world`, Belenios is `elections.we-the-greeks.world` — separate hosts, not touched by this repo.

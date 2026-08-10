# website — WORKFLOW

Static site of **we-the-greeks.world**, served by IIS on the W server (10.66.66.210), site `we-the-greeks.world`, physical path `C:\inetpub\wwwroot`, behind an nginx reverse proxy (public IP 45.66.43.245).

## Status

Everything currently here is **experimental / placeholder** and will be replaced when the site gets a proper design. Current contents:

- `index.html` — "Hello" placeholder landing page
- `presentation/` — self-contained slide viewer of the WeTheGreeks pitch deck (WebP frames + vanilla-JS crossfade viewer; frames generated from `apothetirio\ppt\webbuild\web_deck.pptx`)
- `el/`, `en/` — reserved for future localized pages (empty)

## Sync flow (global golden rule: always git, never file copy)

1. Edit locally in `C:\ProjectRepos\WeTheGreeks\website`
2. Commit on `main`, push to GitHub
3. The server pulls into `C:\inetpub\wwwroot` (scheduled task running `git pull`, or manually via RDP)

Do not deploy by copying files over the `\\10.66.66.210\ai` share — that was only used for the initial bootstrap.

## IIS notes

- `.webp` MIME type must be declared (done in `presentation/web.config`); older IIS versions don't serve it by default.
- If `C:\inetpub\wwwroot` is a git working copy, IIS must not serve `.git` — add a Request Filtering hidden segment for `.git` (done in the root `web.config` of this repo).

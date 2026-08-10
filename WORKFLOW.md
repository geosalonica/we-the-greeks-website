# website — WORKFLOW

Static site of **we-the-greeks.world**, served by IIS on the W server (10.66.66.210), site `we-the-greeks.world`, physical path `F:\AI\Projects\WeTheGreeksLiveSite`, behind an nginx reverse proxy (public IP 45.66.43.245). IIS routes by host header, so IIS-side changes never require nginx changes.

## Status

The landing page is **experimental / placeholder** and will be replaced when the site gets a proper design. The legal pages are real content whose URLs must keep working (app store / Zitadel links may point at them). Current contents:

- `index.html` — "Hello" placeholder landing page
- `presentation/` — self-contained slide viewer of the WeTheGreeks pitch deck (WebP frames + vanilla-JS crossfade viewer; frames generated from `apothetirio\ppt\webbuild\web_deck.pptx`)
- `legal/` — terms, privacy, moderation in el+en, with a language-picker index
- `el/terms/terms-el.html`, `en/terms/terms-en.html` — older standalone terms pages, kept at their original URLs

## Sync flow (global golden rule: always git, never file copy)

1. Edit locally in `C:\ProjectRepos\WeTheGreeks\website`
2. Commit on `main`, push to GitHub (`geosalonica/we-the-greeks-website`, public)
3. **Publishing is manual and user-controlled**: the user RDPs to the server and runs
   `git -C F:\AI\Projects\WeTheGreeksLiveSite pull --ff-only`
   (deliberately no scheduled task — pushing to `main` does NOT immediately change the live site)

## IIS notes

- `.webp` MIME type must be declared (done in `presentation/web.config`); older IIS versions don't serve it by default.
- The live folder is a git working copy; the root `web.config` hides the `.git` segment from being served (verified: `/.git/config` → 404). Keep that in place.
- App pool identity needs read access on the live folder (`IIS_IUSRS`, already granted).

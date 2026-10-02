# Alcor API Documentation (Slate)

Served at https://api.alcor.exchange from the `gh-pages` branch.

## Deploy

Commit to `main` and push. `.github/workflows/deploy.yml` builds the site and
publishes it to `gh-pages`; it is live about a minute later. Nothing needs to
run locally.

## Preview

```bash
./run.bash   # http://localhost:4567, reloads on edits; starts OrbStack if needed
```

Docker is the only local build: the macOS system Ruby is too old for these gems.

## Structure

- `source/index.html.md` — the whole documentation
- `source/includes/_errors.md` — error codes
- `build/` — generated, ignored by git

## Notes

- Slate itself is no longer maintained upstream (removed from GitHub in 2026);
  the `slatedocs/slate` Docker image and the pinned gems still build it.

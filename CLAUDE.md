# Slate API Documentation

## Build & Deploy

### Build with Docker (recommended)
```bash
docker run --rm -v "$(pwd)/source:/srv/slate/source" -v "$(pwd)/build:/srv/slate/build" slatedocs/slate build
```

### Deploy to gh-pages
```bash
./deploy.sh --push-only
```

### Full rebuild + deploy
```bash
docker run --rm -v "$(pwd)/source:/srv/slate/source" -v "$(pwd)/build:/srv/slate/build" slatedocs/slate build
./deploy.sh --push-only
```

## Structure

- `source/index.html.md` - main documentation file
- `source/includes/_errors.md` - error codes
- `build/` - generated static files (pushed to gh-pages)

## GitHub Actions

- Push to `main` triggers automatic deploy via `.github/workflows/deploy.yml`
- Uses `actions/cache@v4` and `actions/checkout@v4`

## Notes

- Local Ruby build broken on macOS (rack gem incompatibility with Ruby 3.3)
- Always use Docker for local builds
- gh-pages branch serves https://alcorexchange.github.io/

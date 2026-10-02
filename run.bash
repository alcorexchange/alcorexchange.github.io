#!/usr/bin/env bash
# Preview the docs at http://localhost:4567 — edits to source/ reload live.
# Deploying needs none of this: a push to main builds and publishes on GitHub.
set -euo pipefail
cd "$(dirname "$0")"

if ! docker info >/dev/null 2>&1; then
  echo "Starting OrbStack…"
  orb start
  until docker info >/dev/null 2>&1; do sleep 1; done
fi

docker run --rm --name slate -p 4567:4567 -v "$(pwd)/source:/srv/slate/source" slatedocs/slate serve

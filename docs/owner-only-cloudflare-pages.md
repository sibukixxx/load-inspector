# TechVit owner-only Load Inspector Pages deployment (2026-10-26)

The browser viewer in `frontend/` is deployed separately from the Go sidecar, Docker Compose, k6 runner and any collection credentials.

- Cloudflare Pages project: `techvit-load-private`; GitHub `sibukixxx/load-inspector`, branch `main`.
- Build root `frontend`, command `npm install --no-audit --no-fund && npm run build`, output `dist`.
- Access allowed identity: TechVit owner only. Protect all access paths: `load.techvit.me`, `techvit-load-private.pages.dev`, and `*.techvit-load-private.pages.dev`.
- Do not treat the Workers-only `workers_dev:false` option as Pages authentication. No public `.duckdb` upload or backend is included in this static release.

## Acceptance gates

1. Capture the deployed Git SHA and successful Cloudflare Pages build log (do not infer success merely from triggering the deployment).
2. Check anonymous requests to the custom, Pages origin and deployment hostnames are denied, and owner login succeeds.
3. In a real browser, load a synthetic k6 `.duckdb` file and test Summary, Endpoints and regression/gate displays. Verify DuckDB WASM Worker/CDN compatibility and Content Security Policy.
4. Record rollback deployment id, test redeploy/rollback once, and preserve no private input in browser error logs.

Production sidecar/data ingestion requires separate hosting and release approval.

# Contributing

Thanks for considering a contribution to Load Inspector.

## Scope

Good contributions include:

- k6 request-metric capture improvements
- DuckDB storage/query compatibility fixes
- deterministic regression or bottleneck analysis
- performance policy / gate improvements
- portable result inspection
- test fixtures, documentation, and security hardening

Out of scope:

- generic observability-platform features unrelated to load-test evidence
- business recommendations or project prioritization
- autonomous load testing against arbitrary public targets
- customer-specific consulting workflows

## Development

Go requirements are defined in `sidecar-go/go.mod`.

```sh
make fmt-check
make vet
make test-unit
make test-analysis
make test-gate
make build-cli
make build-sidecar
```

Keep analysis behavior deterministic. Add or update synthetic fixtures when changing comparison, regression, explain, or gate semantics.

## Pull requests

Keep changes focused and include:

- the problem being solved
- tests for behavior changes
- documentation changes for user-visible behavior
- no credentials, private datasets, or AI attribution/session metadata in commits or files

By contributing, you agree that your contribution is licensed under the MIT License.

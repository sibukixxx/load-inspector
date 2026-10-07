SIDECAR_DIR := sidecar-go
BINARY      := $(SIDECAR_DIR)/load-inspector-sidecar
CLI_BINARY  := $(SIDECAR_DIR)/load-inspector

.PHONY: build-sidecar build-cli test test-unit test-e2e test-analysis test-gate bench-gate lint fmt fmt-check vet release-check clean docker-build ci zip

# ── Build ──────────────────────────────────────────────────────────────────────

build-sidecar:
	cd $(SIDECAR_DIR) && go build -o load-inspector-sidecar

build-cli:
	cd $(SIDECAR_DIR) && go build -o load-inspector ./cmd/load-inspector

# ── Test ───────────────────────────────────────────────────────────────────────

# Run all tests (unit + E2E)
test: test-unit test-e2e

# Unit tests only (excludes E2E directory)
test-unit:
	cd $(SIDECAR_DIR) && go test \
	  ./analysis/... ./cmd/... ./handlers/... ./models/... \
	  ./orchestrator/... ./realtime/... ./storage/... \
	  -v -race -count=1

# E2E tests — set E2E_RUN=TestName to filter (e.g. make test-e2e E2E_RUN=TestE2EFlush)
test-e2e:
	cd $(SIDECAR_DIR) && go test ./test/e2e/tests/... \
	  -v -race -count=1 $(if $(E2E_RUN),-run $(E2E_RUN),)

# Analysis SQL validation pipeline: build every synthetic fixture, then
# validate + execute every catalog query against it (see analysis/queries,
# analysis/fixtures, analysis/validator). Runnable locally the same way CI
# runs it, and independently of the rest of the unit test suite.
test-analysis:
	cd $(SIDECAR_DIR) && go test \
	  ./analysis/queries/... ./analysis/fixtures/... ./analysis/validator/... \
	  -v -race -count=1
	cd $(SIDECAR_DIR) && go run ./cmd/load-inspector check-analysis

# Performance gate: policy schema, evaluation engine, and CLI/API
# integration, run against every synthetic gate fixture (see
# analysis/fixtures/gate_fixtures.go).
test-gate:
	cd $(SIDECAR_DIR) && go test \
	  ./analysis/policy/... ./analysis/gate/... \
	  -v -race -count=1

# Synthetic cost check for the performance gate at 100k/1M requests (see
# analysis/gate/bench_test.go). Not part of `make test`; run on demand.
bench-gate:
	cd $(SIDECAR_DIR) && go test ./analysis/gate/... -run '^$$' -bench . -benchtime 1x -v

# ── Code quality ───────────────────────────────────────────────────────────────

vet:
	cd $(SIDECAR_DIR) && go vet ./...

fmt:
	cd $(SIDECAR_DIR) && gofmt -w -l .

fmt-check:
	@files="$$(cd $(SIDECAR_DIR) && gofmt -l .)"; \
	if [ -n "$$files" ]; then \
	  echo "The following files need gofmt:"; \
	  echo "$$files"; \
	  exit 1; \
	fi

# Requires golangci-lint: https://golangci-lint.run/usage/install/
lint:
	cd $(SIDECAR_DIR) && golangci-lint run ./...

# Run vet + unit tests (fast CI gate)
ci: fmt-check vet test-unit

# Deterministic public-release gate. Does not require cloud/provider credentials.
release-check: fmt-check vet lint test-unit test-analysis test-gate build-cli build-sidecar

# ── Maintenance ────────────────────────────────────────────────────────────────

clean:
	rm -f $(BINARY) $(CLI_BINARY)
	rm -rf $(SIDECAR_DIR)/data/*.duckdb $(SIDECAR_DIR)/data/*.duckdb.wal

docker-build:
	cd $(SIDECAR_DIR) && docker build -t load-inspector-sidecar .

zip:
	cd /mnt/data && zip -r load-inspector.zip load-inspector

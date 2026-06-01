BIN := $(shell git rev-parse --show-toplevel)/bin

.PHONY: help build install deps clean

help:
	@echo "Available targets:"
	@echo "  help     Show this help"
	@echo "  deps     Download and tidy Go dependencies"
	@echo "  build    Build Go CLIs into $(BIN)"
	@echo "  install  Alias for build"
	@echo "  clean    Remove built Go CLIs from $(BIN)"

build: deps
	@mkdir -p $(BIN)
	@for d in go/cmd/*/; do \
		name=$$(basename $$d); \
		echo "Building $$name -> $(BIN)/$$name"; \
		go build -C go -o $(BIN)/$$name ./cmd/$$name; \
	done

install: build

deps:
	cd go && go mod tidy && go mod download

clean:
	@for d in go/cmd/*/; do \
		name=$$(basename $$d); \
		rm -f $(BIN)/$$name; \
	done

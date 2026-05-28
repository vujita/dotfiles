BIN := $(shell git rev-parse --show-toplevel)/bin

.PHONY: install deps clean

install: deps
	@mkdir -p $(BIN)
	@for d in go/cmd/*/; do \
		name=$$(basename $$d); \
		echo "Building $$name -> $(BIN)/$$name"; \
		cd go && go build -o $(BIN)/$$name ./cmd/$$name && cd ..; \
	done

deps:
	cd go && go mod tidy && go mod download

clean:
	@for d in go/cmd/*/; do \
		name=$$(basename $$d); \
		rm -f $(BIN)/$$name; \
	done

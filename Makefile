build: ## Build the backend
	@cabal build -j

clean: ## Remove the cabal build artifacts
	@cabal clean

repl: ## Start a cabal REPL
	@cabal repl

ghci: repl ## Start a cabal REPL (alias for `make repl`)

watch: ## Load the main library and reload on file change
	@ghcid -l

lint: ## Run the code linter (HLint)
	@find src -name "*.hs" | xargs -P $(PROCS) -I {} hlint --refactor-options="-i" --refactor {}

style: ## Run the code formatters (stylish-haskell, cabal-fmt, nixfmt)
	@cabal-fmt -i *.cabal
	@find src -name '*.hs' -exec fourmolu -i {} +

tags: ## Generate ctags for the project with `ghc-tags`
	@ghc-tags -c

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.* ?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

UNAME := $(shell uname)

SHELL := /usr/bin/env bash

ifeq ($(UNAME), Darwin)
	PROCS := $(shell sysctl -n hw.logicalcpu)
else
	PROCS := $(shell nproc)
endif

.PHONY: all $(MAKECMDGOALS)

.DEFAULT_GOAL := help

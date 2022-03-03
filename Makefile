all: build-test

CHARON_HOME = ../charon
CHARON_EXEC = $(CHARON_HOME)/charon
DEST_DIR = tests

# We use those variables, whose definition depends on the rule we apply
CHARON_TESTS_DIR =
CHARON_OPTIONS =
CHARON_TESTS_SRC =

# The user can specify additional translation options for Aeneas:
OPTIONS ?=

# Default translation options:
# - insert calls to the normalizer in the translated code to test the
#   generated unit functions
TRANS_OPTIONS := -test-trans-units $(OPTIONS)
SUBDIR :=

# Build the project and test it
.PHONY: build-test
build-test: build test

# Build the project
.PHONY: build
build:
	dune build src/main.exe

# Test the project
.PHONY: test
test: build translate-no_nested_borrows translate-hashmap translate-paper \
	translate-nll-betree_nll

# Add specific options to some tests
translate-no_nested_borrows translate-paper: \
	TRANS_OPTIONS:=$(TRANS_OPTIONS) -test-units -no-split-files -no-state -no-decreases-clauses
translate-no_nested_borrows translate-paper: SUBDIR:=misc
translate-hashmap: TRANS_OPTIONS:=$(TRANS_OPTIONS) -template-clauses -no-state
translate-hashmap: SUBDIR:=hashmap

translate-nll-betree_nll: TRANS_OPTIONS=-test-units -no-split-files -no-state -no-decreases-clauses
translate-nll-betree_nll: SUBDIR:=misc

# Generic rules to extract the LLBC from a rust file
# The "standard" and the nll (non-linear lifetime) tests are in separate
# directories in Charon
.PHONY: gen-llbc-%

# TODO: remove those "gen-..." rules, and just do `make` in the charon repo
gen-llbc-%: CHARON_OPTIONS = --dest ../tests/llbc --no-code-duplication
gen-llbc-%: CHARON_TESTS_SRC = ../tests/src

gen-llbc-nll-%: CHARON_OPTIONS = --dest ../tests-nll/llbc --no-code-duplication --nll
gen-llbc-nll-%: CHARON_TESTS_SRC = ../tests-nll/src

gen-llbc-%: build
	cd $(CHARON_HOME)/charon && cargo run $(CHARON_TESTS_SRC)/$*.rs $(CHARON_OPTIONS)

gen-llbc-nll-%: build
	cd $(CHARON_HOME)/charon && cargo run $(CHARON_TESTS_SRC)/$*.rs $(CHARON_OPTIONS)

# Generic rule to test the translation on a LLBC file
.PHONY: translate-%
translate-%: CHARON_TESTS_DIR = $(CHARON_HOME)/tests/llbc
translate-nll-%: CHARON_TESTS_DIR = $(CHARON_HOME)/tests-nll/llbc

translate-%: gen-llbc-%
	dune exec -- src/main.exe $(CHARON_TESTS_DIR)/$*.llbc -dest $(DEST_DIR)/$(SUBDIR) $(TRANS_OPTIONS)

translate-nll-%: gen-llbc-nll-%
	dune exec -- src/main.exe $(CHARON_TESTS_DIR)/$*.llbc -dest $(DEST_DIR)/$(SUBDIR) $(TRANS_OPTIONS)

.PHONY: doc
doc:
	dune build @doc

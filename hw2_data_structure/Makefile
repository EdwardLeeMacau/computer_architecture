################################################################################
# Specify env
################################################################################

JUPITER_ROOT = $(realpath ../jupiter/image/bin)

################################################################################
# Specify tools
################################################################################

CC = gcc
CX = g++
ZIP = zip
COPY = cp
DIFF = diff
MKDIR = mkdir -p
ZIPINFO = zipinfo
JUPITER = $(JUPITER_ROOT)/jupiter

CLEAN_BINS := recurrence linkedlist

################################################################################
# Specify compile options
################################################################################

CFLAGS = -std=c99 -Wall -Wextra -Werror -pedantic -O2

################################################################################
# Specify the default targets
################################################################################

.PHONY: all
all: default

################################################################################
# List intermediate make targets
################################################################################

.PHONY: test_recurrence test_linkedlist

test_recurrence: r11922001_recurrence.s

test_linkedlist: r11922001_linkedlist.s

test_recurrence test_linkedlist:
	@echo "Testing $(subst test_,,$@) ..."
	$(Q)$(foreach file, $(wildcard tests_$(subst test_,,$@)/*.in), \
		echo "> $(notdir $(basename $(file)))"; \
		$(JUPITER) $< < $(file) > $(file:.in=.out) && $(DIFF) $(file:.in=.out) $(file:.in=.ans); \
	)
	@echo ""

# ---------------------------------------------------------------------------- #

r11922001.zip: r11922001/r11922001_recurrence.s \
			   r11922001/r11922001_linkedlist.s
	@echo "Packing source code ..."
	@echo ""
	$(Q)$(ZIP) -r r11922001.zip r11922001

r11922001/r11922001_recurrence.s: r11922001_recurrence.s | r11922001
	$(Q)$(COPY) $< $@

r11922001/r11922001_linkedlist.s: r11922001_linkedlist.s | r11922001
	$(Q)$(COPY) $< $@

r11922001:
	$(Q)$(MKDIR) $@

################################################################################
# Specify the PHONY targets
################################################################################

.PHONY: default
default: test

.PHONY: test
test: test_recurrence test_linkedlist

.PHONY: pack
pack: r11922001.zip
	$(Q)$(ZIPINFO) $<


.PHONY: clean
clean:
	@echo "Cleaning up ..."
	@echo ""
	$(Q)$(RM) $(wildcard tests_linkedlist/*.out) $(wildcard tests_recurrence/*.out) $(CLEAN_BINS)

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@echo "    all (default)    - Build all targets"
	@echo "    test             - Run tests"
	@echo "    pack             - Pack the source code"
	@echo "    help             - Show this help message"
	@echo "    clean            - Clean up all generated files"
	@echo ""

################################################################################
# Generic rules
################################################################################

% : %.c
	@echo "Compiling $@ ..."
	@echo ""
	$(Q)$(CC) $(CFLAGS) -o $@ $<

################################################################################
# Debugging options
################################################################################

V ?= 0

ifeq ($(V), 0)
Q = @
else
Q =
endif

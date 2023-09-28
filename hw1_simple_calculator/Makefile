################################################################################
# Specify env
################################################################################

JUPITER_ROOT = $(realpath ../jupiter/image/bin)

################################################################################
# Specify tools
################################################################################

JUPITER = $(JUPITER_ROOT)/jupiter
DIFF = diff

################################################################################
# Specify the PHONY targets
################################################################################

.PHONY: all
all: default

.PHONY: default
default: test

.PHONY: test
test: r11922001.s
	@echo "Testing ..."
	@echo ""
	$(Q)$(foreach file, $(wildcard tests/*.in), \
		$(JUPITER) $< < $(file) > $(file:.in=.out); \
		$(DIFF) $(file:.in=.out) $(file:.in=.ans); \
	)
	$(Q)$(JUPITER)

.PHONY: clean
clean:
	@echo "Cleaning up ..."
	@echo ""
	$(Q)$(RM) $(wildcard tests/*.out)

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@echo "    all (default)    - Build all targets"
	@echo "    test             - Run tests"
	@echo "    help             - Show this help message"
	@echo "    clean            - Clean up all generated files"
	@echo ""

################################################################################
# Debugging options
################################################################################

V ?= 0

ifeq ($(V), 0)
Q = @
else
Q =
endif

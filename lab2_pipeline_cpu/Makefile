################################################################################
# Specify tools
################################################################################

CC = gcc
CX = g++
RM = rm
ZIP = zip
COPY = cp
DIFF = diff
MKDIR = mkdir -p
ZIPINFO = zipinfo

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

SOURCE_DIR := code/src
TARGET_DIR := r11922001_lab2

SOURCES := $(wildcard $(SOURCE_DIR)/*.v)
TARGETS := $(addprefix $(TARGET_DIR)/src/, $(notdir $(SOURCES))) \
		   $(TARGET_DIR)/r11922001_lab2_report.pdf

$(TARGET_DIR)/r11922001_lab2_report.pdf: report.pdf
	@echo "Copying $@ ..."
	$(Q)$(COPY) $< $@

$(TARGET_DIR)/src/% : code/src/% | $(TARGET_DIR)/src
	@echo "Copying $@ ..."
	$(Q)$(COPY) $< $@

r11922001_lab2.zip: $(TARGETS)
	@echo "Packing source code ..."
	@echo "$(SOURCES)"
	@echo "$(TARGETS)"
	$(Q)$(RM) -rf $@
	$(Q)$(ZIP) -r $@ $(TARGET_DIR)

$(TARGET_DIR)/src: $(TARGET_DIR)
	$(Q)$(MKDIR) $@

$(TARGET_DIR):
	$(Q)$(MKDIR) $@

################################################################################
# Specify the PHONY targets
################################################################################

.PHONY: default
default: pack

.PHONY: test
test: ;

.PHONY: pack
pack: r11922001_lab2.zip
	$(Q)$(ZIPINFO) $<

.PHONY: clean
clean:
	@echo "Cleaning up ..."
	@echo ""
	$(Q)$(RM) -rf r11922001_lab2 r11922001_lab2.zip

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

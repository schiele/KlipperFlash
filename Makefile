KLIPPER := ~/klipper

CONFIG_FILES := $(wildcard config.*)
VARIANTS := $(CONFIG_FILES:config.%=%)
DEVICES := $(wildcard /dev/serial/by-id/usb-Klipper_*)
DEVICEIDS := $(DEVICES:/dev/serial/by-id/%=%)
KLIPPERMAKE = $(MAKE) -C $(KLIPPER) KCONFIG_CONFIG:=$(CURDIR)/exp_config.$1 OUT:=$(CURDIR)/out.$1/

ifdef V
Q=
else
Q=@
MAKEFLAGS += --no-print-directory
endif

ifdef DRYRUN
D=echo [DRYRUN]
else
D=
endif

flashall: flashint startklipper
flashint: $(DEVICEIDS:%=flash.%)
buildall: $(VARIANTS:%=build.%)
all: flashall buildall

exp_config.%: config.%
	@echo Expanding $< to $@
	$(Q)cat $< > $@
	$(Q)$(call KLIPPERMAKE,$*) olddefconfig

build.%: exp_config.%
	@echo Buinding variant $*
	$(Q)$(call KLIPPERMAKE,$*)
	$(Q)touch $@

define FLASH_RULE =
flash.$1: $$(foreach t,build exp_config,$$t.$$(if $$(filter $1,$$(VARIANTS)),$1,$$(if $$(filter $(1:usb-Klipper_%=%),$$(VARIANTS)),$(1:usb-Klipper_%=%),$$(firstword $$(subst _, ,$(1:usb-Klipper_%=%)))))) stopklipper
	@echo Flashing variant $$(<:build.%=%) to $$(@:flash.%=/dev/serial/by-id/%)
	$$(Q)$$(D) $$(call KLIPPERMAKE,$$(<:build.%=%)) flash FLASH_DEVICE=$$(@:flash.%=/dev/serial/by-id/%)
endef

stopklipper:
	@echo Stopping Klipper
	$(Q)$(D) sudo systemctl stop klipper

startklipper: flashint
	@echo Starting Klipper
	$(Q)$(D) sudo systemctl start klipper

$(foreach d,$(DEVICEIDS),$(eval $(call FLASH_RULE,$(d))))

.PHONY: all buildall flashall flashint clean FORCE $(foreach d,$(DEVICEIDS),flash.$(d)) stopklipper startklipper

clean:
	@echo Cleaning up
	$(Q)rm -rf exp_config.* build.* out.*

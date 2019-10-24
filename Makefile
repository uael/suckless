.SUFFIXES:
.DEFAULT_GOAL := all

tools := dwm slstatus

%/Makefile:                 ; git submodule update --init $(@D)
%/config.h: %.config.h      ; cp $< $@
%/patched:: %.patches.patch ; touch $@; cd $(@D) && git apply ../$<
%/patched::                 ; touch $@

MFLAGS += --no-print-directory

.PHONY: $(tools)
$(tools): %: %/Makefile %/config.h %/patched
	@$(MAKE) $(MFLAGS) -C $@

.PHONY: all
all: $(tools)

.PHONY: clean
clean: ; git submodule deinit --all -f

.PHONY: install uninstall
install uninstall:
	for i in $(tools); do $(MAKE) $(MFLAGS) -C $$i $@; done

install: $(tools)

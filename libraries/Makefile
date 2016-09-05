SUBDIRS := $(wildcard */.)

all: $(SUBDIRS) global

$(SUBDIRS):
	$(MAKE) -C $@

global: global-models global-processes

global-models:
	echo "" > all.models.js;
	for dir in $(SUBDIRS); do cat $$dir/models.js >> all.models.js; done

global-processes:
	echo "" > all.processes.js;
	for dir in $(SUBDIRS); do cat $$dir/processes.js >> all.processes.js; done

clean:
	rm all.processes.js all.models.js;
	$(MAKE) clean -C $(SUBDIRS)

.PHONY: global global-processes global-models $(SUBDIRS)

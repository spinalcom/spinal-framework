
#======== HUB CONFIG =========
HUB = spinalhub
WEB = organs/browser/
JS_PORT = 8888
CPP_PORT = 8890
MONITOR_PORT = 8889
#=============================

SHELL = /bin/bash

#============================= INSTALLING ================================

# Make vars

define LIB_MAKEFILE_TXT
SUBDIRS := $$(wildcard */.)

all: $$(SUBDIRS) global

$$(SUBDIRS):
	$$(MAKE) -C $$@

global: global-models global-processes

global-models:
	echo "" > all.models.js;
	for dir in $$(SUBDIRS); do \
	  cat $$$$dir/models.js >> all.models.js; \
	done

global-processes:
	echo "" > all.processes.js;
	for dir in $$(SUBDIRS); do \
	  cat $$$$dir/processes.js >> all.processes.js; \
	done

clean:
	rm -f all.processes.js all.models.js;
	for dir in $$(SUBDIRS); do \
		$$(MAKE) -C $$$$dir clean; \
	done

.PHONY: global global-processes global-models $$(SUBDIRS) clean
endef

export LIB_MAKEFILE_TXT

LIB_MAKEFILE="$$LIB_MAKEFILE_TXT"

# Make rules

all: install

install: install-basic

install-basic:
	# nerve-center
	mkdir -p ./nerve-center 
	test -e spinalhub* && ( chmod +x spinalhub*; mv spinalhub* ./nerve-center/spinalhub ) || ( test -e ./nerve-center/spinalhub || ( echo -e "\nPlease put a spinalhub executable in this folder.\n"; false; ) )
	# libraries folder
	mkdir -p ./libraries
	@echo ${LIB_MAKEFILE} > ./libraries/Makefile
	# browser-organs
	mkdir -p ./organs
	mkdir -p ./organs/browser
	mkdir -p ./organs/browser/libJS
	cd ./organs/browser/libJS/; test -e ./spinalcore.browser.js || wget http://resources.spinalcom.com/spinalcore.browser.js;
	# generate symlink of libraries in organs
	ln -sf ../libraries ./organs/
	ln -sf ../libraries ./organs/browser/
	@echo -e "\nFramework installation succeeded!\n"

install-issim: install-basic
	# models-manager
  #TODO -> UPDATE IS-SIM REPO!
	#test -e ./models-manager/is-sim/ && ( cd models-manager/is-sim/; git pull; make; ) || ( cd models-manager/; git clone https://github.com/spinalcom/is-sim.git; cd ./is-sim; make; );
	cd ./libraries; test -e ./is-sim.config.js || ( echo > is-sim.config.js; echo -e "var MODELS = [];\nvar APPLIS = [];\nvar LIBS = [];" > is-sim.config.js; )
	# browser-organs
	test -e ./organs/browser/libJS/jquery-2.2.4.min.js || ( cd ./organs/browser/libJS/; wget https://code.jquery.com/jquery-2.2.4.min.js );
	test -e ./organs/browser/libJS/js.cookie.js || ( cd ./organs/browser/libJS/; wget https://raw.githubusercontent.com/js-cookie/js-cookie/v2.1.1/src/js.cookie.js );
	@echo -e "\nis-sim installation succeeded!\n"


#=============================== RUNNING =================================
run:
	@cd nerve-center; ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nYour hub is already running!\n" ) || (./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT} & )

run-organs-manager:
	@ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( test -e ./organs-manager/run && ( cd ./organs-manager;  echo -e "Your organs manager is now running...\n"; ./run & ) || ( echo -e "There is no organs manager executable!\n" ) ) || ( make run_with_organsmanager )


#=============================== STOPPING ================================
stop:
	@ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nYour hub is shutdown.\n"; kill -9 $$( pgrep -f ./${HUB}\ -b\ ../${WEB}\ -p\ ${JS_PORT}\ -P\ ${MONITOR_PORT}\ -q\ ${CPP_PORT} ) ) || ( echo -e "\nYour hub is not running!\n" ) 



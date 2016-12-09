
#======== HUB CONFIG =========
HUB = spinalhub
WEB = organs/browser/
JS_PORT = 8888
CPP_PORT = 8890
MONITOR_PORT = 8889
#=============================

SHELL = /bin/bash

#============================= DEFINE SPECIFIC MAKEFILES ================================

# js-libraries/ makefile------------------------------------------------------------------

define JS_LIB_MAKEFILE_TXT
FILE_BUILD_ORDER:=build.order
SUBDIRS :=`cat $$(FILE_BUILD_ORDER)`
NODEJS := $$(shell command -v nodejs 2> /dev/null)
NODE := $$(shell command -v node 2> /dev/null)

all: start install global

start:
	@echo "\033[0;33mjs-libraries folder: $$(MAKE) all\033[m"

install: build-order
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/Makefile ]; then $$(MAKE) --no-print-directory -C $$$$dir"/."; fi done

global: global-is-sim global-models global-processes

global-models: build-order
	@echo "" > all.models.js;
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/models.js ]; then cat $$$$dir/models.js >> all.models.js; fi done

global-processes: build-order
	@echo "" > all.processes.js;
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/processes.js ]; then cat $$$$dir/processes.js >> all.processes.js; fi done

global-is-sim: build-order
	@echo "" > all.is-sim.js
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then if [ -e $$$$dir/is-sim.js ]; then cat $$$$dir/is-sim.js >> all.is-sim.js; else if [ -e $$$$dir/models.js ]; then cat $$$$dir/models.js >> all.is-sim.js; fi; if [ -e $$$$dir/processes.js ]; then cat $$$$dir/processes.js >> all.is-sim.js; fi fi fi done

clean:
	@echo "\033[0;33mjs-libraries folder: $$(MAKE) clean\033[m"
	@! test -e all.processes.js || rm -f all.processes.js all.models.js;
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then $$(MAKE) --no-print-directory -C $$$$dir clean; fi done

build-order: test-node
ifdef NODE
	@! test -e "spinal_build_order.js" || node spinal_build_order.js
else
	@! test -e "spinal_build_order.js" || nodejs spinal_build_order.js
endif

test-node:
ifndef NODEJS
ifndef NODE
	@echo "\n\n\033[0;31m[ERROR] nodejs not available please install nodejs\033[m\n\n"
	@exit 1
endif
endif

.PHONY: install global global-processes global-models clean build-order test_node start
endef

export JS_LIB_MAKEFILE_TXT

JS_LIB_MAKEFILE="$$JS_LIB_MAKEFILE_TXT"


# ./organ/ makefile------------------------------------------------------------------

define ORGAN_MAKEFILE_TXT
SUBDIRS := $$(wildcard *)

all:
	@echo "\033[0;33mOrgan folder: $$(MAKE) all\033[m"
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/Makefile ]; then $$(MAKE) --no-print-directory -C $$$$dir"/."; fi done

init:
	@echo "\033[0;33mOrgan folder: $$(MAKE) init\033[m"
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/Makefile ]; then $$(MAKE) --no-print-directory -C $$$$dir"/." init; fi done

run:
	@echo "\033[0;33mOrgan folder: $$(MAKE) run\033[m"
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/Makefile ]; then $$(MAKE) --no-print-directory -C $$$$dir run; fi done

stop:
	@echo "\033[0;33mOrgan folder: $$(MAKE) stop\033[m"
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/Makefile ]; then $$(MAKE) --no-print-directory -C $$$$dir stop; fi done

clean:
	@echo "\033[0;33mOrgan folder: $$(MAKE) clean\033[m"
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/Makefile ]; then $$(MAKE) --no-print-directory -C $$$$dir clean; fi done

.PHONY: all run stop clean init
endef

export ORGAN_MAKEFILE_TXT

ORGAN_MAKEFILE="$$ORGAN_MAKEFILE_TXT"


# ./organ/browser/ makefile------------------------------------------------------------------

define ORGAN_BROWSER_MAKEFILE_TXT
SUBDIRS := $$(wildcard *)
HTML := $$(wildcard *.html)

all:
	@echo "\033[0;33mOrgan/browser folder: $$(MAKE) all\033[m"
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/Makefile ]; then $$(MAKE) --no-print-directory -C $$$$dir"/."; fi done

init:
	@echo "\033[0;33mOrgan/browser folder: $$(MAKE) init\033[m"
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/Makefile ]; then $$(MAKE) --no-print-directory -C $$$$dir"/." init; fi done

clean:
	@echo "\033[0;33mOrgan/browser folder: $$(MAKE) clean\033[m"
	@for file in $$(HTML); do $$(RM) $$$$file; done
	@for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ] && [ -e $$$$dir/Makefile ]; then $$(MAKE) --no-print-directory -C $$$$dir clean; fi done

.PHONY: all run stop clean init
endef

export ORGAN_BROWSER_MAKEFILE_TXT

ORGAN_BROWSER_MAKEFILE="$$ORGAN_BROWSER_MAKEFILE_TXT"


#============================= INSTALLING ================================

WGET := $(shell command -v wget 2> /dev/null)
CURL := $(shell command -v curl 2> /dev/null)

# Make rules

all: test_init
	@cd ./js-libraries; $(MAKE) --no-print-directory; cd ../organs/; $(MAKE) --no-print-directory;
	@echo -e "\033[0;32m[OK] make all: Done\033[m"

install:
	@echo -e "\nWrite your own installation process here ! \n"

init: test_wget_curl
	@# nerve-center
	@mkdir -p ./nerve-center

	@# js-libraries folder
	@mkdir -p ./js-libraries
	@echo ${JS_LIB_MAKEFILE} > ./js-libraries/Makefile
	@cp spinal_build_order.js js-libraries/

	@# cpp-libraries folder
	@mkdir -p ./cpp-libraries

	@# organs
	@mkdir -p ./organs
	@echo ${ORGAN_MAKEFILE} > ./organs/Makefile

	@# organs/browser
	@mkdir -p ./organs/browser
	@mkdir -p ./organs/browser/libJS
ifdef WGET
	@cd ./organs/browser/libJS/; test -e ./spinalcore.browser.js || wget http://resources.spinalcom.com/spinalcore.browser.js;
else
	@cd ./organs/browser/libJS/; test -e ./spinalcore.browser.js || curl "http://resources.spinalcom.com/spinalcore.browser.js" -o "spinalcore.browser.js"
endif
	@echo ${ORGAN_BROWSER_MAKEFILE} > ./organs/browser/Makefile

	@# generate symlink of libraries in organs
	@ln -sf ../js-libraries ./organs/
	@ln -sf ../js-libraries ./organs/browser/

	@# make init the organs
	@$(MAKE) --no-print-directory -C organs init
	@echo -e "\033[0;32m[OK] make init: Done\n\n\033[0;36mFramework installation succeeded!\n\033[m"

install-utility_issim: test_wget_curl
	@# lib_is-sim
	@test -e ./js-libraries/lib_is-sim/ && ( cd js-libraries/lib_is-sim/; git pull; ) || ( cd js-libraries/; git clone https://github.com/spinalcom/lib_is-sim.git; );

	@# utility_is-sim
	@test -e ./organs/browser/utility_is-sim/ && ( cd ./organs/browser/utility_is-sim/; git pull; ) || ( cd organs/browser/; git clone https://github.com/spinalcom/utility_is-sim.git; );

	@# LibJS
ifdef WGET
	@test -e ./organs/browser/libJS/jquery-2.2.4.min.js || ( cd ./organs/browser/libJS/; wget https://code.jquery.com/jquery-2.2.4.min.js );
	@test -e ./organs/browser/libJS/js.cookie.js || ( cd ./organs/browser/libJS/; wget https://raw.githubusercontent.com/js-cookie/js-cookie/v2.1.1/src/js.cookie.js );
else
	@test -e ./organs/browser/libJS/jquery-2.2.4.min.js || ( cd ./organs/browser/libJS/; curl "https://code.jquery.com/jquery-2.2.4.min.js" -o "jquery-2.2.4.min.js" );
	@test -e ./organs/browser/libJS/js.cookie.js || ( cd ./organs/browser/libJS/; curl "https://raw.githubusercontent.com/js-cookie/js-cookie/v2.1.1/src/js.cookie.js" -o "js.cookie.js" );
endif
	@echo -e "\033[0;32m\n[OK] make install-utility_issim: Done\n\n\033[0;36mutility_is-sim installation succeeded!\n\033[m"

install-utility_admin: test_wget_curl
	@# LibJS
ifdef WGET
	@test -e ./organs/browser/libJS/js.cookie.js || ( cd ./organs/browser/libJS/; wget https://raw.githubusercontent.com/js-cookie/js-cookie/v2.1.1/src/js.cookie.js );
else
	@test -e ./organs/browser/libJS/js.cookie.js || ( cd ./organs/browser/libJS/; curl "https://raw.githubusercontent.com/js-cookie/js-cookie/v2.1.1/src/js.cookie.js" -o "js.cookie.js" );
endif
	@# utility_is-sim
	@test -e ./organs/browser/utility_admin-dashboard/ && ( cd ./organs/browser/utility_admin-dashboard/; git pull; ) || ( cd organs/browser; git clone https://github.com/spinalcom/utility_admin-dashboard.git; );
	@echo -e "\033[0;32m\n[OK] make install-utility_admin: Done\n\n\033[0;36mutility_admin_dashboard installation succeeded!\n\033[m"

clean: test_init
	@cd ./js-libraries; $(MAKE) --no-print-directory clean; cd ../organs/; $(MAKE) --no-print-directory clean;
	@echo -e "\033[0;32m[OK] make clean: Done\033[m"

#============================== NEW ORGANS ===============================
neworgan.node:
	@mkdir -p organs/; cd ./organs/; git clone https://github.com/spinalcom/neworgan-node.git; cd neworgan-node/; make --no-print-directory update; cd ../; if [[ $${NAME} ]]; then mv neworgan-node $${NAME}; fi
	@echo -e "\033[0;32m[OK] make neworgan.node: Done\033[m"

neworgan.qt:
	@mkdir -p organs/; cd ./organs/; git clone https://github.com/spinalcom/neworgan-qt.git; cd neworgan-qt; git clone https://github.com/spinalcom/SpinalCoreQT.git ; cd ../; if [[ $${NAME} ]]; then mv neworgan-qt $${NAME}; fi
	@echo -e "\033[0;32m[OK] make neworgan.qt: Done\033[m"

neworgan.nwjs:
	@mkdir -p organs/; cd ./organs/; git clone https://github.com/spinalcom/neworgan-nwjs.git; cd neworgan-nwjs/; make --no-print-directory update; cd ../; if [[ $${NAME} ]]; then mv neworgan-nwjs $${NAME}; fi
	@echo -e "\033[0;32m[OK] make neworgan.nwjs: Done\033[m"

neworgan.browser:
	@mkdir -p organs/browser/; cd ./organs/browser/; git clone https://github.com/spinalcom/neworgan-browser.git; if [[ $${NAME} ]]; then mv neworgan-browser $${NAME}; fi
	@echo -e "\033[0;32m[OK] make neworgan.browser: Done\033[m"

#=============================== RUNNING =================================
run: hub.run organs.run

hub.run:
	@test -e ./nerve-center/spinalhub || ( mkdir -p ./nerve-center/; test -e spinalhub* && ( chmod +x spinalhub*; mv spinalhub* ./nerve-center/spinalhub ) || ( test -e ./nerve-center/spinalhub || ( echo -e "\nPlease put a spinalhub executable in this folder.\n"; false; ) ) )
	@cd nerve-center; ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nYour hub is already running!\n" ) || (./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT} & )

organs.run:
	@cd nerve-center; ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nRunning organs...\n"; sleep 3; cd ../organs/; make --no-print-directory run ) || ( echo -e "\nYou hub is not running!\n" )

#=============================== STOPPING ================================
stop: hub.stop organs.stop

hub.stop:
	@ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nYour hub is shutdown.\n"; kill -9 $$( pgrep -f ./${HUB}\ -b\ ../${WEB}\ -p\ ${JS_PORT}\ -P\ ${MONITOR_PORT}\ -q\ ${CPP_PORT} ) ) || ( echo -e "\nYour hub is not running!\n" )

organs.stop:
	@ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( cd ./organs/; make stop ) || ( echo -e "")


test_init:
	@test -e ./js-libraries/ || test -e ./organs/ || (echo -e "\n\n\033[0;31m[ERROR] Framework not initialized, please do a 'make init' first.\033[m\n\n"; exit 1)

test_wget_curl:
ifndef WGET
ifndef CURL
	@echo "\n\n\033[0;31m[ERROR] wget or curl not available please install either wget or curl\033[m\n\n"
	@exit 1
endif
endif


.PHONY: all install update clean run hub.run organs.run stop hub.stop organs.stop test_wget_curl test_init

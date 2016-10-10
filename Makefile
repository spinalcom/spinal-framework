
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
SUBDIRS := $$(wildcard */.)

all: install global

install:
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then $$(MAKE) -C $$$$dir"/."; fi done
	
global: global-models global-processes

global-models:
	echo "" > all.models.js;
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then cat $$$$dir/models.js >> all.models.js; fi done

global-processes:
	echo "" > all.processes.js;
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then cat $$$$dir/processes.js >> all.processes.js; fi done

clean:
	rm -f all.processes.js all.models.js;
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then $$(MAKE) -C $$$$dir clean; fi done

.PHONY: install global global-processes global-models clean
endef

export JS_LIB_MAKEFILE_TXT

JS_LIB_MAKEFILE="$$JS_LIB_MAKEFILE_TXT"


# ./organ/ makefile------------------------------------------------------------------

define ORGAN_MAKEFILE_TXT
SUBDIRS := $$(wildcard *)

all:
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then $$(MAKE) -C $$$$dir"/."; fi done

run:
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then $$(MAKE) -C $$$$dir run; fi done

stop:
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then $$(MAKE) -C $$$$dir stop; fi done

clean:
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then $$(MAKE) -C $$$$dir clean; fi done
	
.PHONY: all run stop clean
endef

export ORGAN_MAKEFILE_TXT

ORGAN_MAKEFILE="$$ORGAN_MAKEFILE_TXT"


# ./organ/browser/ makefile------------------------------------------------------------------

define ORGAN_BROWSER_MAKEFILE_TXT
SUBDIRS := $$(wildcard *)
HTML := $$(wildcard *.html)

all:
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then $$(MAKE) -C $$$$dir"/."; fi done

clean:
	for file in $$(HTML); do $$(RM) $$$$file; done
	for dir in $$(SUBDIRS); do if [ ! -L $$$$dir ] && [ -d $$$$dir ]; then $$(MAKE) -C $$$$dir clean; fi done
	
.PHONY: all run stop clean
endef

export ORGAN_BROWSER_MAKEFILE_TXT

ORGAN_BROWSER_MAKEFILE="$$ORGAN_BROWSER_MAKEFILE_TXT"


#============================= INSTALLING ================================

# Make rules

all:
	@cd ./js-libraries; make; cd ../organs/; make;

install: 
	@echo -e "\n Write your own installation process here ! \n"

init:
	# nerve-center
	mkdir -p ./nerve-center 
	
	# js-libraries folder
	mkdir -p ./js-libraries
	@echo ${JS_LIB_MAKEFILE} > ./js-libraries/Makefile
	
	# cpp-libraries folder
	mkdir -p ./cpp-libraries
	
	# organs
	mkdir -p ./organs
	@echo ${ORGAN_MAKEFILE} > ./organs/Makefile
	
	# organs/browser
	mkdir -p ./organs/browser
	mkdir -p ./organs/browser/libJS
	cd ./organs/browser/libJS/; test -e ./spinalcore.browser.js || wget http://resources.spinalcom.com/spinalcore.browser.js;
	@echo ${ORGAN_BROWSER_MAKEFILE} > ./organs/browser/Makefile

	# generate symlink of libraries in organs
	ln -sf ../js-libraries ./organs/
	ln -sf ../js-libraries ./organs/browser/
	@echo -e "\n Framework installation succeeded!\n"

install-utility_issim: 
	# lib_is-sim
	test -e ./js-libraries/lib_is-sim/ && ( cd js-libraries/lib_is-sim/; git pull; ) || ( cd js-libraries/; git clone https://github.com/spinalcom/lib_is-sim.git; );
	
	# utility_is-sim
	test -e ./organs/browser/utility_is-sim/ && ( cd ./organs/browser/utility_is-sim/; git pull; ) || ( cd organs/browser/; git clone https://github.com/spinalcom/utility_is-sim.git; );
	
	# LibJS
	test -e ./organs/browser/libJS/jquery-2.2.4.min.js || ( cd ./organs/browser/libJS/; wget https://code.jquery.com/jquery-2.2.4.min.js );
	test -e ./organs/browser/libJS/js.cookie.js || ( cd ./organs/browser/libJS/; wget https://raw.githubusercontent.com/js-cookie/js-cookie/v2.1.1/src/js.cookie.js );

	@echo -e "\n utility_is-sim installation succeeded!\n"
	
install-utility_admin: 
	# lib_is-sim
	test -e ./js-libraries/lib_is-sim/ && ( cd js-libraries/lib_is-sim/; git pull; ) || ( cd js-libraries/; git clone https://github.com/spinalcom/lib_is-sim.git; );
	
	# utility_is-sim
	test -e ./organs/utility_admin-dashboard/ && ( cd ./organs/utility_admin-dashboard/; git pull; ) || ( cd organs/; git clone https://github.com/spinalcom/utility_admin-dashboard.git; );

	@echo -e "\n utility_admin_dashboard installation succeeded!\n"

clean:
	@cd ./js-libraries; make clean; cd ../organs/; make clean;

	
#============================== NEW ORGANS ===============================
neworgan.node:
	@mkdir -p organs/; cd ./organs/; git clone https://github.com/spinalcom/neworgan-node.git; cd neworgan-node/; make update; cd ../; if [[ $${NAME} ]]; then mv neworgan-node $${NAME}; fi 

neworgan.qt:
	@mkdir -p organs/; cd ./organs/; git clone https://github.com/spinalcom/neworgan-qt.git; cd neworgan-qt; git clone https://github.com/spinalcom/SpinalCoreQT.git ; cd ../; if [[ $${NAME} ]]; then mv neworgan-qt $${NAME}; fi 

neworgan.nwjs:
	@mkdir -p organs/; cd ./organs/; git clone https://github.com/spinalcom/neworgan-nwjs.git; cd neworgan-nwjs/; make update; cd ../; if [[ $${NAME} ]]; then mv neworgan-nwjs $${NAME}; fi

neworgan.browser:
	@mkdir -p organs/browser/; cd ./organs/browser/; git clone https://github.com/spinalcom/neworgan-browser.git; if [[ $${NAME} ]]; then mv neworgan-browser $${NAME}; fi 
	
#=============================== RUNNING =================================
run: hub.run organs.run

hub.run:
	@test -e ./nerve-center/spinalhub || ( mkdir -p ./nerve-center/; test -e spinalhub* && ( chmod +x spinalhub*; mv spinalhub* ./nerve-center/spinalhub ) || ( test -e ./nerve-center/spinalhub || ( echo -e "\nPlease put a spinalhub executable in this folder.\n"; false; ) ) )
	@cd nerve-center; ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nYour hub is already running!\n" ) || (./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT} & )

organs.run:
	@cd nerve-center; ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nRunning organs...\n"; sleep 3; cd ../organs/; make run ) || ( echo -e "\nYou hub is not running!\n" )

#=============================== STOPPING ================================
stop: hub.stop organs.stop

hub.stop:
	@ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nYour hub is shutdown.\n"; kill -9 $$( pgrep -f ./${HUB}\ -b\ ../${WEB}\ -p\ ${JS_PORT}\ -P\ ${MONITOR_PORT}\ -q\ ${CPP_PORT} ) ) || ( echo -e "\nYour hub is not running!\n" ) 

organs.stop:
	@ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( cd ./organs/; make stop ) || ( echo -e "")


.PHONY: all install update clean run hub.run organs.run stop hub.stop organs.stop 
	
	


#======== HUB CONFIG =========
HUB = spinalhub
WEB = browser-organs/
JS_PORT = 8888
CPP_PORT = 8890
MONITOR_PORT = 8889
#=============================

SHELL = /bin/bash


all: install


#============================= INSTALLING ================================
install: install-basic

install-basic:
	# nerve-center
	mkdir -p ./nerve-center 
	test -e spinalhub* && ( chmod +x spinalhub*; mv spinalhub* ./nerve-center/spinalhub ) || ( test -e ./nerve-center/spinalhub || ( echo -e "\nPlease put a spinalhub executable in this folder.\n"; false; ) )
	# models-manager
	mkdir -p ./models-manager
	mkdir -p ./models-manager/models
	cd ./models-manager/models; test -e concat-js || ( echo > concat-js; echo -e "#!/bin/bash\nfor dir in \044(find * -type d); do tmp=\"\"; cat \044{dir}/*.js >> tmp; mv tmp \044{dir}.js; done" > concat-js; chmod +x concat-js; )
	# browser-organs
	mkdir -p ./browser-organs
	cd ./browser-organs/; ln -sf ../models-manager/
	mkdir -p ./browser-organs/libJS
	cd ./browser-organs/libJS/; test -e ./spinalcore.browser.js || wget http://resources.spinalcom.com/spinalcore.browser.js;
	@echo -e "\nFramework installation succeeded!\n"

install-issim: install-basic
	# models-manager
	test -e ./models-manager/is-sim/ && ( cd models-manager/is-sim/; git pull; make; ) || ( cd models-manager/; git clone git@github.com:spinalcom/is-sim.git; cd ./is-sim; make; );
	cd ./models-manager; test -e ./is-sim.config.js || ( echo > is-sim.config.js; echo -e "var MODELS = [];\nvar APPLIS = [];\nvar LIBS = [];" > is-sim.config.js; )
	# browser-organs
	test -e ./browser-organs/libJS/jquery-2.2.4.min.js || ( cd ./browser-organs/libJS/; wget https://code.jquery.com/jquery-2.2.4.min.js );
	test -e ./browser-organs/libJS/js.cookie.js || ( cd ./browser-organs/libJS/; wget https://raw.githubusercontent.com/js-cookie/js-cookie/v2.1.1/src/js.cookie.js );
	@echo -e "\nis-sim installation succeeded!\n"


#=============================== RUNNING =================================
run: 
	@cd nerve-center; ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nYour hub is already running!\n" ) || (./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT} & )

run-organs-manager:
	@ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( test -e ./organs-manager/run && ( cd ./organs-manager;  echo -e "Your organs manager is now running...\n"; ./run & ) || ( echo -e "There is no organs manager executable!\n" ) ) || ( make run_with_organsmanager )


#=============================== STOPPING ================================
stop:
	@ps ax | grep -v grep | grep -v grep | grep "./${HUB} -b ../${WEB} -p ${JS_PORT} -P ${MONITOR_PORT} -q ${CPP_PORT}" > /dev/null && ( echo -e "\nYour hub is shutdown.\n"; kill -9 $$( pgrep -f ./${HUB}\ -b\ ../${WEB}\ -p\ ${JS_PORT}\ -P\ ${MONITOR_PORT}\ -q\ ${CPP_PORT} ) ) || ( echo -e "\nYour hub is not running!\n" ) 



#!/bin/bash

THEME_REPO="/edx/app/themes/"$1/

update_theme_repo() {

	cd $THEME_REPO && \
		sudo -u edxapp git pull
}

compile_theme() {
	cd /edx/app/edxapp/edx-platform
	source /edx/app/edxapp/edxapp_env
	sudo -E -u edxapp env "PATH=$PATH" /edx/app/edxapp/venvs/edxapp/bin/paver update_assets $2 --settings=aws
}

restart_server() { 
	sudo /edx/bin/supervisorctl restart edxapp:$2 && sudo service memcached restart 
}


if [ "$#" -ne 2 ]; then
	echo "Usage"
	echo " "
	echo "            sudo update_theme.sh THEME_REPO_DIR_NAME {lms|cms}"
	echo " "
else
	update_theme_repo
	compile_theme
	restart_server
fi





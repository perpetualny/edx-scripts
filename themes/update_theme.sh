#!/bin/bash

update_theme_repo() { 
	sudo -H -u edxapp bash
	cd $1
	git pull
	exit
}

compile_theme() {
	sudo -H -u edxapp bash
	cd ~
	source edxapp_env
	cd edx-platform
	paver update_assets $2 --settings=aws
	exit
}

restart_server() { 
	sudo /edx/bin/supervisorctl restart edxapp:$2 && sudo service memcached restart 
}


if [ "$#" -ne 1 ]; then
	echo "Usage"
	echo " "
	echo "            sudo update_theme.sh /edx/app/themes/THEME_REPO_NAME {lms|cms}"
	echo " "
else
	update_theme_repo
	compile_theme
	restart_server
fi





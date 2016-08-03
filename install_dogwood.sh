#!/bin/bash

sudo apt-get update -y

export OPENEDX_RELEASE=named-release/dogwood.3

curl -O https://raw.githubusercontent.com/edx/configuration/master/util/install/ansible-bootstrap.sh

curl -O https://raw.githubusercontent.com/edx/configuration/$OPENEDX_RELEASE/util/install/sandbox.sh

chmod +x ansible-bootstrap.sh sandbox.sh

sudo ./ansible-bootstrap.sh

source /edx/app/edx_ansible/venvs/edx_ansible/bin/activate

sudo ./sandbox.sh

#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y 

export OPENEDX_RELEASE=named-release/dogwood

curl -O https://raw.githubusercontent.com/edx/configuration/master/util/install/ansible-bootstrap.sh

chmod +x ansible-bootstrap.sh 

# Install Ansible 
sudo ./ansible-bootstrap.sh

# Activate ansible virtualenv
source /edx/app/edx_ansible/venvs/edx_ansible/bin/activate


# Install sandbox.sh 
sudo apt-get install -y python-software-properties
sudo add-apt-repository ppa:ubuntu-toolchain-r/test

# Pre-requisites
sudo apt-get install -y build-essential software-properties-common python-software-properties curl git-core libxml2-dev libxslt1-dev python-pip python-apt python-dev python-scipy libxmlsec1-dev libfreetype6-dev swig gcc-4.8 g++-4.8
sudo pip install --upgrade pip==7.1.2
sudo pip install --upgrade setuptools==18.3.2
sudo -H pip install --upgrade virtualenv==13.1.2

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50

if [ -n "$OPENEDX_RELEASE" ]; then
  EXTRA_VARS="-e edx_platform_version=$OPENEDX_RELEASE \
      -e certs_version=$OPENEDX_RELEASE \
      -e forum_version=$OPENEDX_RELEASE \
      -e xqueue_version=$OPENEDX_RELEASE \
      -e configuration_version=$OPENEDX_RELEASE \
    "
    CONFIG_VER=$OPENEDX_RELEASE
else
	echo "OPENEDX_RELEASE is not set"
	exit
fi

# edx/configuration
cd /var/tmp
git clone https://github.com/edx/configuration
cd configuration
git checkout $CONFIG_VER
# optional.txt error de9dab6
git cherry-pick de9dab6


# Install ansible requirements 
cd /var/tmp/configuration
sudo -H pip install -r requirements.txt

# Finally, run edx_sandbox.yml playbook
cd /var/tmp/configuration/playbooks && sudo ansible-playbook -c local ./edx_sandbox.yml -i "localhost," $EXTRA_VARS


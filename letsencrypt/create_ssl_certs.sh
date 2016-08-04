#!/bin/bash

# Install Certbot (certbot.eff.org)
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto

# Shutdown Nginx
sudo service nginx stop

# Create new certificates
export TMPCMD="certonly --standalone"

# iterate through args
for var in "$@"
do
	export TMPCMD=$TMPCMD" -d ""$var"
done
echo $TMPCMD

# Fetch the certificates
sudo ./certbot-auto  $TMPCMD

# Creating dir in /etc/nginx
sudo mkdir -p /etc/nginx/certs

# linking certs from /etc/letsencrypt/live/domainname.com 
sudo ln -s /etc/letsencrypt/live/* /etc/nginx/certs/

# next steps 
#echo "Execute the following commands" 
#echo ""
#echo "openssl dhparam -out /etc/nginx/certs/DOMAIN_NAME_HERE/dhparam.pem 2048"


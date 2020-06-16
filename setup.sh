#!/bin/bash

# Camera must be activated manually via raspi-config before!
# Works with 2020-05-27-raspios-buster-lite-armhf
# raspberry pi zero w/wh


# bash <(curl -sL https://raw.githubusercontent.com/ahue/petflap-open-setup/master/setup.sh)

PFO_PATH="/home/pi/pfo"
NODE_RED_WDIR="/home/pi"

mkdir ${PFO_PATH}
cd ${PFO_PATH}

sudo apt-get update -y
sudo apt-get upgrade -y

# Install packages for wifi ap
sudo apt-get install dnsmasq hostapd -y

# # Install git
sudo apt-get install git -y

# # Install postgres
sudo apt-get install postgresql libpq-dev postgresql-client postgresql-client-common -y
# autostart?

# # Install redis
sudo apt-get install redis -y
# autostart?

# # Install motion
sudo apt-get install motion -y

# # Install mqtt publisher/subscriber
sudo apt-get install mosquitto-clients -y

# --> 14.6.: works until here

# # Install node-red
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered) --confirm-install --confirm-pi
sudo systemctl enable nodered.service

# Clone the repository
git clone https://github.com/ahue/petflap-open-setup.git .

git clone https://github.com/ahue/petflap-open-engine-node-red.git ~/.node-red/projects/petflap-open-engine

git clone https://github.com/ahue/rpi-zw-wifi-ap-switch.git wifi

git clone https://github.com/ahue/petflap-open-smartpass-ml.git smartpass/algo

# Configure node-red
cd ~/.node-red/projects/petflap-open-engine
npm install

cd ~/.node-red/
npm install bcryptjs
# Secure node-red
TIMESTAMP=$(date +%s)
echo "node-red admin password: ${TIMESTAMP}"
NR_ADMIN_PW=$(node -e "console.log(require('bcryptjs').hashSync(process.argv[1], 8));" ${TIMESTAMP} )

cd ${PFO_PATH}/config/node-red
cp settings.template.js settings.js
cp ~/.node-red/settings.js ~/.node-red/settings.js.bak
NR_ADMIN_PW=${NR_ADMIN_PW} envsubst < settings.js > ~/.node-red/settings.js
# maybe need to manipulate /lib/systemd/system/nodered.service to start the correct project!

# Set the project as active project
cat ~/.node-red/.config.json | jq '.projects = { "projects": { "petflap-open-engine": { "credentialSecret": "petflap" } }, "activeProject": "petflap-open-engine" }' > ~/.node-red/.config.json

# Create directory for logs
sudo mkdir -p /var/log/pfo
sudo chown pi:pi /var/log/pfo

# Install smartpass package
cd ${PFO_PATH}/smartpass/algo
pip3 install -e .


# Configure motion
sudo cp ${PFO_PATH}/config/motion/motion.conf /etc/motion/motion.conf
sudo cp ${PFO_PATH}/config/motion/motion /etc/default/motion
sudo systemctl enable motion

# Configure postgres
cd ${PFO_PATH}/setup/postgres
sudo su postgres psql -f pg_setup.sql
sudo su postgres psql -f create_petflap.sql -d petflap
# ggf. timezone setzen

# Make folders
mkdir -p ${PFO_PATH}/motion/thumbnails
mkdir -p ${PFO_PATH}/smartpass/model/current
mkdir -p ${PFO_PATH}/smartpass/model/new

# Put the configuration in place
cd ${PFO_PATH}/config/node-red
PFO_PATH=${PFO_PATH} envsubst < pfo_config.yaml > ${NODE_RED_WDIR}/pfo_config.yaml

#Finally set up AP
# sudo reboot
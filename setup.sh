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

# Install jq for json manipulation
sudo apt-get install jq -y





# Clone the repository
git clone https://github.com/ahue/petflap-open-setup.git setup

git clone https://github.com/ahue/rpi-zw-wifi-ap-switch.git wifi

# Configure postgres
cd ${PFO_PATH}/setup/postgres
sudo su postgres -c "psql -f pg_setup.sql"
sudo su postgres -c "psql -f drop_tables.sql -d petflap"
sudo su postgres -c "psql -f create_petflap.sql -d petflap"
# ggf. timezone setzen

# Configure motion
# Note: too early startup of motion, when postgres is not yet started can lead to crash!

# enable camera
sudo raspi-config nonint do_camera 1

mkdir -p ${PFO_PATH}/motion/thumbnails
sudo cp ${PFO_PATH}/setup/motion/motion.conf /etc/motion/motion.conf
sudo cp ${PFO_PATH}/setup/motion/motion /etc/default/motion
sudo systemctl enable motion
sudo service restart motion

# Make folders
mkdir -p ${PFO_PATH}/smartpass/model/current
mkdir -p ${PFO_PATH}/smartpass/model/new

# Install smartpass package
git clone https://github.com/ahue/petflap-open-smartpass-ml.git smartpass/algo
cd ${PFO_PATH}/smartpass/algo
pip3 install -e .

# Create directory for logs
sudo mkdir -p /var/log/pfo
sudo chown pi:pi /var/log/pfo

# Put the configuration in place
cd ${PFO_PATH}/config/node-red
PFO_PATH=${PFO_PATH} envsubst < pfo_config.yaml > ${NODE_RED_WDIR}/pfo_config.yaml

# Configure node-red
cd ~/.node-red/projects/petflap-open-engine
npm install --prefix ~/.node-red ./

# Enable node-red to run on port 80
sudo setcap 'cap_net_bind_service=+ep'  $(eval readlink -f `which node`)


# maybe issue here: bootstrap@4.5.0 requires a peer of jquery@1.9.1 - 3 but none is installed. You must install peer dependencies yourself.

# Install node-red
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered) --confirm-install --confirm-pi
# Clone the project
git clone https://github.com/ahue/petflap-open-engine-node-red.git ~/.node-red/projects/petflap-open-engine

# TODO: set timezone
cd ~/.node-red/
npm install bcryptjs

# --> 14.6.: works until here
# Secure node-red
TIMESTAMP=$(date +%s)
echo "node-red admin password: ${TIMESTAMP}"
NR_ADMIN_PW=$(node -e "console.log(require('bcryptjs').hashSync(process.argv[1], 8));" ${TIMESTAMP} )

cd ${PFO_PATH}/setup/config/node-red
# cp settings.template.js settings.js
cp ~/.node-red/settings.js ~/.node-red/settings.js.bak
NR_ADMIN_PW=${NR_ADMIN_PW} envsubst < settings.js > ~/.node-red/settings.js
# maybe need to manipulate /lib/systemd/system/nodered.service to start the correct project!

# Does not work, since config is not there yet
sudo systemctl enable nodered.service
sudo systemctl start nodered.service # needed to create .config?

while [ ! -f ~/.node-red/.config.json ]; do sleep 1; done

# Set the project as active project
jq -e '.projects = { "projects": { "petflap-open-engine": { "credentialSecret": "petflap" } }, "activeProject": "petflap-open-engine" }' ~/.node-red/.config.json > ~/.node-red/.config.tmp && cp ~/.node-red/.config.tmp ~/.node-red/.config.json

sudo systemctl restart nodered.service


#Finally set up AP
#sudo reboot
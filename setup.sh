#!/bin/bash

# Note: set the time zone with sudo dpkg-reconfigure tzdata

# Works with 2020-05-27-raspios-buster-lite-armhf
# raspberry pi zero w/wh

# bash <(curl -sL https://raw.githubusercontent.com/ahue/petflap-open-setup/master/setup.sh)

sudo apt-get update -y
sudo apt-get upgrade -y

# Install packages for wifi ap
#sudo apt-get install dnsmasq hostapd -y

# # Install git
sudo apt-get install git -y

# # Install postgres
sudo apt-get install postgresql libpq-dev postgresql-client postgresql-client-common -y

# # Install mqtt publisher/subscriber
#sudo apt-get install mosquitto-clients -y # do i still need this!

PFO_PATH="$HOME/pfo"

mkdir ${PFO_PATH}
cd ${PFO_PATH}

# Clone the repository
git clone https://github.com/ahue/petflap-open-setup.git setup

# git clone https://github.com/ahue/rpi-zw-wifi-ap-switch.git wifi

# Configure postgres
cd ${PFO_PATH}/setup/postgres
sudo su postgres -c "psql -f 01_pg_setup.sql"
sudo su postgres -c "psql -f 02_create_petflap.sql"
# ggf. timezone setzen

# Configure motion
# Note: too early startup of motion, when postgres is not yet started can lead to crash!

# enable camera
sudo raspi-config nonint do_camera 1

# # Install motion
sudo apt-get install motion -y

# Set up motion
mkdir -p ${PFO_PATH}/motion/thumbnails
sudo cp ${PFO_PATH}/setup/motion/motion.conf /etc/motion/motion.conf
sudo cp ${PFO_PATH}/setup/motion/motion /etc/default/motion
sudo systemctl enable motion
sudo service restart motion

# Make folders
mkdir -p ${PFO_PATH}/models/
mkdir -p ${PFO_PATH}/reports/

mv ${PFO_PATH}/setup/example.config.yaml ${PFO_PATH}/

# Install smartpass package
sudo apt-get install gcc libpq-dev -y
sudo apt-get install python-dev  python-pip -y
sudo apt-get install python3-dev python3-pip python3-venv python3-wheel -y

python3 -m pip install wheel
python3 -m pip install --update -r git+https://github.com/ahue/pfo-passage-monitor.git

# Create directory for logs
sudo mkdir -p /var/log/pfo
sudo chown pi:pi /var/log/pfo

# Set up services
sudo mv ${PFO_PATH}/setup/pfo.service /etc/systemd/system/pfo.service
# sudo chown root:root ??
sudo mv ${PFO_PATH}/setup/pfo_http.service /etc/systemd/system/pfo_http.service

sudo systemctl daemon-reload
sudo systemctl enable pfo.service
sudo systemctl enable pfo_http.service

# journalctl -f -u pfo.service # read logs

#Finally set up AP
#sudo reboot
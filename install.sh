#### Setup Script for RPI OS based on Debian.
## Version: 1.0
## Author: Forrest Evans
## From: https://github.com/fdevans/aquarium_dashboard

#Update Base OS
sudo apt update
sudo apt upgrade

#Configure Repos
curl https://repos.influxdata.com/influxdb.key | gpg --dearmor | sudo tee /usr/share/keyrings/influxdb-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/influxdb-archive-keyring.gpg] https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
wget -qO - https://packages.grafana.com/gpg.key | sudo gpg --dearmor --output /usr/share/keyrings/grafana.gpg
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

#Run Installation
sudo apt update
sudo apt install -y influxdb telegraf
sudo apt install -y --allow-downgrades grafana=8.4.7

#Configure Services to Start on Boot
sudo systemctl unmask influxdb
sudo systemctl enable influxdb
sudo systemctl unmask telegraf
sudo systemctl enable telegraf
sudo systemctl umask grafana-server
sudo systemctl enable grafana-server

#Start Services
sudo systemctl start influxdb
sudo systemctl start telegraf
sudo systemctl start grafana-server

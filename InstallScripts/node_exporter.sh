#!/bin/bash

# Change these before running
# "amd64" can be replaced with "arm64" for RBPi 
NODE_EXPORTER_VERSION="1.2.2"
NODE_EXPORTER_TYPE="amd64"


echo "===== INSTALLING NODE EXPORTER $NODE_EXPORTER_TYPE v$NODE_EXPORTER_VERSION ====="
echo ""

echo ""
echo "--> DOWNLOADING NODE EXPORTER..."
(cd /tmp && curl -OL https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/node_exporter-$NODE_EXPORTER_VERSION.linux-$NODE_EXPORTER_TYPE.tar.gz)

echo ""
echo "--> EXTRACTING NODE EXPORTER"
(cd /tmp && tar -xvf /tmp/node_exporter-$NODE_EXPORTER_VERSION.linux-$NODE_EXPORTER_TYPE.tar.gz)

echo ""
echo "--> ADDING NODE EXPORTER USER AND GROUP..."
sudo useradd -m node_exporter
sudo groupadd node_exporter
sudo usermod -a -G node_exporter node_exporter

echo ""
echo "--> INSTALLING NODE EXPORTER..."
sudo mv /tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-$NODE_EXPORTER_TYPE/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

echo ""
echo "--> CREATING SYSTEMD SERVICE..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF'

echo ""
echo "--> RESTARTING DAEMON..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter

echo ""
echo "--> DONE! run systemctl status node_exporter to check your install."
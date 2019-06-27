#!/bin/bash
cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

#Make service initd
echo "[Unit]
Description=PumaServer
After=mongod.target

[Service]
Type=simple
ExecStart=/usr/local/bin/puma -d
WorkingDirectory=/home/work/reddit
Restart=always
PIDFile=/home/work/puma.pid

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/puma.service

systemctl daemon-reload
systemctl enable puma.service
systemctl start puma


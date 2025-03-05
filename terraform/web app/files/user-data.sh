#!/bin/bash
echo "Update and install dependencies" > /var/log/mylog.log
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y git curl nodejs npm


echo "Clone your backend repository" >> /var/log/mylog.log
git clone https://github.com/FonzAye/test.git /opt/backend

echo "Navigate to the project directory" >> /var/log/mylog.log
cd /opt/backend

echo "Install dependencies" >> /var/log/mylog.log
sudo npm install
echo "start backend" >> /var/log/mylog.log
sudo npm start
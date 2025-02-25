#!/bin/bash
# Update and install dependencies
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y git curl nodejs npm


# Clone your backend repository
git clone https://github.com/FonzAye/test.git /opt/backend

# Navigate to the project directory
cd /opt/backend

# Install dependencies and start the backend
npm install
nohup npm start &

# # Create a dedicated system user (e.g., backenduser) for security:
# useradd -r -m -d /opt/backend -s /bin/false backenduser
# chown -R backenduser:backenduser /opt/backend

# Ensure the service keeps running
echo "[Unit]
Description=Backend Service
After=network.target

[Service]
ExecStart=/usr/bin/npm start
WorkingDirectory=/opt/backend
Restart=always
User=backenduser

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/backend.service

# Enable and start the service
systemctl daemon-reload
systemctl enable backend
systemctl start backend

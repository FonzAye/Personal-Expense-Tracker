#!/bin/bash

# Update and install dependencies
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y git curl nodejs npm


# Clone your backend repository
git clone -b client https://github.com/FonzAye/Personal-Expense-Tracker.git /opt

BACKEND_IP="${backend_ip}"

cat <<EOF > /opt/client/config.js
window.APP_CONFIG = {
    BACKEND_IP: "$BACKEND_IP"
};
EOF

sudo chmod 644 /opt/client/config.js

# Set the hyve-api directory path as a variable
API_DIR="/opt/client"

# Change to the server directory, install dependencies and start the server
cd "$API_DIR"
sudo npm install
# eval "$SERVER_COMMAND"

# Define the service file path
SERVICE_FILE="/etc/systemd/system/frontend.service"

# Write the service configuration
sudo tee $SERVICE_FILE > /dev/null <<-EOF
[Unit]
Description=Frontend Service
After=network.target

[Service]
ExecStart=/usr/bin/npx http-server -p 8080
WorkingDirectory=/opt/client
Restart=always
User=ubuntu
Environment=NODE_ENV=production
StandardOutput=file:/var/log/frontend.log
StandardError=file:/var/log/frontend-error.log

[Install]
WantedBy=multi-user.target
Alias=frontend.service
EOF

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable frontend

# Start the backend service
sudo systemctl start frontend
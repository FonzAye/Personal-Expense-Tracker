#!/bin/bash

# Update and install dependencies
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y git curl nodejs npm


# Clone your backend repository
git clone -b server https://github.com/FonzAye/Personal-Expense-Tracker.git /opt/backend

# Set the hyve-api directory path as a variable
API_DIR="/opt/backend"

# Change to the server directory, install dependencies and start the server
cd "$API_DIR"
sudo npm install
# eval "$SERVER_COMMAND"

# Define the service file path
SERVICE_FILE="/etc/systemd/system/backend.service"

# Write the service configuration
sudo tee $SERVICE_FILE > /dev/null <<-EOF
[Unit]
Description=Backend Service
After=network.target

[Service]
ExecStart=/usr/bin/npm start
WorkingDirectory=/opt/backend
Restart=always
User=ubuntu
Environment=NODE_ENV=production
StandardOutput=file:/var/log/backend.log
StandardError=file:/var/log/backend-error.log

[Install]
WantedBy=multi-user.target
Alias=backend.service
EOF

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable backend

# Start the backend service
sudo systemctl start backend
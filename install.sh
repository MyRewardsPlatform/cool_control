#!/bin/bash

# Paths to the scripts
PWM_FAN_SCRIPT_PATH="./"
PWM_FAN_CONTROL_SCRIPT_PATH="./"
SERVICE_FILE_PATH="./cool_control.service"

# Destination paths
DEST_PATH="/usr/local/bin"
SERVICE_PATH="/etc/systemd/system"
CONFIG_PATH="/boot/config.txt"

# Copy the scripts to the destination path
cp "$PWM_FAN_SCRIPT_PATH/cool_control-control.sh" "$DEST_PATH"
cp "$PWM_FAN_CONTROL_SCRIPT_PATH/cool_control.service" "$SERVICE_PATH"

# Set the necessary permissions
chmod +x "$DEST_PATH/cool_control-control.sh"

# Update config.txt with dtoverlay setting if not already present
if ! grep -q "^dtoverlay=cooling_fan" "$CONFIG_PATH"; then
    echo -e "\n# PWM Fan Configuration" | sudo tee -a "$CONFIG_PATH"
    echo "dtoverlay=cooling_fan" | sudo tee -a "$CONFIG_PATH"
    echo "PWM fan overlay added to config.txt"
fi

# Reload the systemd daemon
systemctl daemon-reload

# Enable the service to start on boot
systemctl enable cool_control.service

echo "PWM fan setup completed successfully."
 
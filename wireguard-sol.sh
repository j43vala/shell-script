
#!/bin/bash
# Detect the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Install and configure UFW
sudo apt install ufw
sudo ufw enable
sudo ufw status
sudo ufw allow 22
sudo ufw allow 5000

# Install Git
sudo apt install git

# Clone the repository
git clone https://github.com/j43vala/wzero-edge-app.git
# Navigate to the cloned repository
cd "$SCRIPT_DIR/wzero-edge-app"

# Pull the latest changes from the repository
git pull

# Set up Python venv
if [ ! -d "ENV" ]; then
    python -m venv ENV
fi
. ENV/bin/activate

# Install Python dependencies including necessary dependencies for psutil
sudo apt-get install gcc python3-dev
pip install -r requirements.txt

# Navigate to the service file directory
cd service_files

# Enable system services
sudo systemctl enable "$SCRIPT_DIR/wzero-edge-app/service_files/app_mb_hybrid.service"
sudo systemctl enable "$SCRIPT_DIR/wzero-edge-app/service_files/app_be.service"

# Start systemd services
sudo systemctl start app_be.service

# Add logrotate configuration for your logs
LOGROTATE_CONF="/etc/logrotate.d/custom_logs"

# Create logrotate configuration file or overwrite if exists
echo "/var/log/journal/*/*.journal /var/log/*.log {" | sudo tee "$LOGROTATE_CONF" > /dev/null
echo "    size 30M" | sudo tee -a "$LOGROTATE_CONF" > /dev/null
echo "    rotate 5" | sudo tee -a "$LOGROTATE_CONF" > /dev/null
echo "    compress" | sudo tee -a "$LOGROTATE_CONF" > /dev/null
echo "    missingok" | sudo tee -a "$LOGROTATE_CONF" > /dev/null
echo "    notifempty" | sudo tee -a "$LOGROTATE_CONF" > /dev/null
echo "    copytruncate" | sudo tee -a "$LOGROTATE_CONF" > /dev/null
echo "}" | sudo tee -a "$LOGROTATE_CONF" > /dev/null

# Force log rotation to test the configuration
sudo logrotate -vf "$LOGROTATE_CONF"
#-------------------------------------------------------------------------------
# wireguard solution - 

# Find and replace the WireGuard configuration file dynamically
WG_CONF=$(find "$SCRIPT_DIR" -name '*.conf' -type f | head -n 1)

if [ -n "$WG_CONF" ]; then
    # Check if the existing configuration is different
    if ! cmp -s "$WG_CONF" /etc/wireguard/wg0.conf; then
        # Install wireguard and configure
        sudo apt install wireguard

        # Copy the WireGuard configuration file to /etc/wireguard/
        sudo cp "$WG_CONF" /etc/wireguard/wg0.conf

        # Install openresolv
        sudo apt install openresolv

        # Down the WireGuard interface
        sudo wg-quick down wg0

        # Start the WireGuard interface
        sudo wg-quick up wg0

        echo "WireGuard configuration updated."
    else
        echo "WireGuard configuration is already up to date."
    fi
else
    echo "WireGuard configuration file not found!"
fi

#---------------------------------------------------------------------------------------

# Update system packages
sudo apt-get update
sudo apt-get upgrade
!/bin/bash
Detect the current directory of the script



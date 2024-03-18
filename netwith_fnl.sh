
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
# sudo systemctl enable "$SCRIPT_DIR/wzero-edge-app/service_files/app_mb_hybrid.service"
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
# netbird solution - 

sudo apt install ca-certificates curl gnupg -y
curl -sSL https://pkgs.netbird.io/debian/public.key | sudo gpg --dearmor --output /usr/share/keyrings/netbird-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/netbird-archive-keyring.gpg] https://pkgs.netbird.io/debian stable main' | sudo tee /etc/apt/sources.list.d/netbird.list

sudo apt-get update


sudo apt-get install netbird

netbird up --management-url https://net.urjapravah.com -k 8EE64EE5-8D7F-4F29-AB80-1217AF574F5F
#---------------------------------------------------------------------------------------

# Update system packages
sudo apt-get update
sudo apt-get upgrade
!/bin/bash
Detect the current directory of the script


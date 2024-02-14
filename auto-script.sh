#!/bin/bash
# Install and configure UFW
sudo apt install ufw
sudo ufw enable
sudo ufw status
sudo ufw allow 22
sudo ufw allow 5000

# Install Git and clone the repository
sudo apt install git
git clone https://github.com/j43vala/Data_read_register_sqlite_pg_frontend.git

# Navigate to the cloned repository
cd Data_read_register_sqlite_pg_frontend

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
sudo systemctl enable /home/wzero/Data_read_register_sqlite_pg_frontend/service_files/app_mb_hybrid.service
sudo systemctl enable /home/wzero/Data_read_register_sqlite_pg_frontend/service_files/app_be.service

# Start systemd services
# sudo systemctl start app_mb_hybrid.service
sudo systemctl start app_be.service

# Add logrotate configuration for your logs
LOGROTATE_CONF="/etc/logrotate.d/custom_logs"

# Create logrotate configuration file
echo "/path/to/your/logfile {" | sudo tee "$LOGROTATE_CONF"
echo "    size 30M" | sudo tee -a "$LOGROTATE_CONF"
echo "    rotate 5" | sudo tee -a "$LOGROTATE_CONF"
echo "    compress" | sudo tee -a "$LOGROTATE_CONF"
echo "    missingok" | sudo tee -a "$LOGROTATE_CONF"
echo "    notifempty" | sudo tee -a "$LOGROTATE_CONF"
echo "    copytruncate" | sudo tee -a "$LOGROTATE_CONF"
echo "}" | sudo tee -a "$LOGROTATE_CONF"

# Force log rotation to test the configuration
sudo logrotate -vf /etc/logrotate.conf

# Update system packages
sudo apt-get update
sudo apt-get upgrade
#!/bin/bash
# Detect the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


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

sudo apt-get update
sudo apt-get upgrade

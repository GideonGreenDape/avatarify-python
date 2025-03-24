 #!/usr/bin/env bash

# Check prerequisites
command -v conda >/dev/null 2>&1 || { echo >&2 "conda not found. Please refer to the README and install Miniconda."; exit 1; }
command -v git >/dev/null 2>&1 || { echo >&2 "git not found. Please refer to the README and install Git."; exit 1; }

# Source settings.sh if it exists
if [ -f "scripts/settings.sh" ]; then
    source scripts/settings.sh
else
    echo "settings.sh file not found!"
fi

# v4l2loopback
if [[ ! $@ =~ "no-vcam" ]]; then
    if [ ! -d "v4l2loopback" ]; then
        git clone https://github.com/alievk/v4l2loopback.git
    fi
    echo "--- Installing v4l2loopback (sudo privilege required)"
    cd v4l2loopback
    make || { echo "make failed!"; exit 1; }
    sudo make install || { echo "sudo make install failed!"; exit 1; }
    sudo depmod -a
    cd ..
fi

# Initialize conda
if command -v conda >/dev/null 2>&1; then
    source $(conda info --base)/etc/profile.d/conda.sh
else
    echo "Conda is not available, please install Conda first!"
    exit 1
fi

# Check if CONDA_ENV_NAME is set
if [ -z "$CONDA_ENV_NAME" ]; then
    echo "CONDA_ENV_NAME is not set!"
    exit 1
fi

# Create and activate the Conda environment
conda create -y -n $CONDA_ENV_NAME python=3.7
conda activate $CONDA_ENV_NAME

# Install pip and set up dependencies via pip (since we will rely on requirements.txt)
pip install --upgrade pip

# Install dependencies from requirements.txt
if [ ! -f "requirements.txt" ]; then
    echo "requirements.txt not found!"
    exit 1
fi
pip install -r requirements.txt || { echo "pip install failed!"; exit 1; }

# FOMM repository
rm -rf fomm 2> /dev/null
git clone https://github.com/alievk/first-order-model.git fomm

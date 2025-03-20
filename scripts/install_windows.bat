@echo off

REM Check prerequisites
call conda --version >nul 2>&1 && ( echo conda found ) || ( echo conda not found. Please refer to the README and install Miniconda. && exit /B 1)
REM call git --version >nul 2>&1 && ( echo git found ) || ( echo git not found. Please refer to the README and install Git. && exit /B 1)

call scripts/settings_windows.bat

REM Create and activate Conda environment
call conda create -y -n %CONDA_ENV_NAME% python=3.7
call conda activate %CONDA_ENV_NAME%

REM Install dependencies
call conda install -y numpy=1.19.0 scikit-image python-blosc=1.7.0 -c conda-forge

REM Fix: Try installing PyTorch via Conda first, fallback to Pip if necessary
call conda install -y pytorch=1.7.1 torchvision cudatoolkit=11.0 -c pytorch || (
    echo PyTorch not found in Conda. Installing via Pip...
    call pip install torch==1.7.1+cu110 torchvision==0.8.2+cu110 -f https://download.pytorch.org/whl/torch_stable.html
)

call conda install -y -c anaconda git

REM Clone First Order Motion Model (FOMM)
call rmdir fomm /s /q
call git clone https://github.com/alievk/first-order-model.git fomm

REM Install Python dependencies (remove invalid --use-feature=2020-resolver flag)
call pip install -r fomm/requirements.txt


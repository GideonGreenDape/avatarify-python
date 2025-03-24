@echo off

REM Check prerequisites
call conda --version >nul 2>&1 && ( echo conda found ) || ( echo conda not found. Please refer to the README and install Miniconda. && exit /B 1)
call git --version >nul 2>&1 && ( echo git found ) || ( echo git not found. Please refer to the README and install Git. && exit /B 1)

REM Ensure settings_windows.bat exists
if not exist scripts\settings_windows.bat (
    echo settings_windows.bat not found!
    exit /B 1
)
call scripts\settings_windows.bat

REM Create and activate conda environment
call conda create -y -n %CONDA_ENV_NAME% python=3.7
call conda activate %CONDA_ENV_NAME%

REM Install dependencies from requirements.txt using pip
call pip install --upgrade pip
call pip install -r requirements.txt

REM ### FOMM ###
if exist fomm (
    call rmdir fomm /s /q
)
call git clone https://github.com/alievk/first-order-model.git fomm

echo Installation complete!

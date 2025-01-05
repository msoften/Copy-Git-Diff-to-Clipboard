@echo off
REM @batdoc Title: Git Diff Install Script
REM @batdoc Description: This script installs the git-diff.bat script to a folder in the system's PATH.

REM Define the installation directory
set INSTALL_DIR=%USERPROFILE%\Scripts

REM Create the installation directory if it doesn't exist
if not exist "%INSTALL_DIR%" (
    echo Creating installation directory: %INSTALL_DIR%
    mkdir "%INSTALL_DIR%"
)

REM Copy git-diff.bat to the installation directory
echo Installing git-diff.bat to %INSTALL_DIR%
copy "git-diff.bat" "%INSTALL_DIR%\git-diff.bat"

REM Check if the installation directory is in the system's PATH
echo Checking if %INSTALL_DIR% is in PATH...
echo %PATH% | findstr /i "%INSTALL_DIR%" >nul
if %errorlevel% neq 0 (
    echo %INSTALL_DIR% not found in PATH. Adding it now...
    REM Add the installation directory to the PATH (for the current user)
    setx PATH "%PATH%;%INSTALL_DIR%"
    echo %INSTALL_DIR% added to PATH.
) else (
    echo %INSTALL_DIR% is already in PATH.
)

REM Provide feedback to the user
echo Installation complete. You can now run git-diff.bat from any location in the command line.

pause

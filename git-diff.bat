@echo off
setlocal enabledelayedexpansion

REM Check if Git repository
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo This is not a Git repository. Exiting...
    exit /b 1
)

REM Initialize variables
set "diff_type="
set "files="

REM Parse arguments
:parse_args
if "%1"=="" goto check_diff
if "%1"=="--cached" (
    set "diff_type=--cached"
    shift
    goto parse_args
) else if "%1"=="--all" (
    set "diff_type=HEAD"
    shift
    goto parse_args
) else (
    if defined files (
        set "files=!files! %1"
    ) else (
        set "files=%1"
    )
    shift
    goto parse_args
)

:check_diff
set "temp_file=%TEMP%\git_diff_temp.txt"

REM Check if files are untracked
if defined files (
    git ls-files --error-unmatch !files! >nul 2>&1
    if !errorlevel! neq 0 (
        echo Some specified files are untracked. Add them first using: git add ^<file^>
        exit /b 1
    )
)

REM Get diff output
if "%diff_type%"=="--cached" (
    if defined files (
        git diff --cached !files! > "%temp_file%"
    ) else (
        git diff --cached > "%temp_file%"
    )
) else if "%diff_type%"=="HEAD" (
    if defined files (
        git diff HEAD !files! > "%temp_file%"
    ) else (
        git diff HEAD > "%temp_file%"
    )
) else (
    if defined files (
        git diff !files! > "%temp_file%"
    ) else (
        git diff > "%temp_file%"
    )
)

REM Check for changes
for %%I in ("%temp_file%") do set "size=%%~zI"
if !size! equ 0 (
    if defined files (
        echo No changes found for specified files
    ) else (
        echo No changes found
    )
    del "%temp_file%"
    exit /b 1
)

REM Copy to clipboard and cleanup
type "%temp_file%" | clip
del "%temp_file%"

REM Show feedback
if defined files (
    echo Git diff for specified files copied to clipboard
) else (
    echo Git diff copied to clipboard
)

endlocal

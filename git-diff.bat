@echo off
REM @batdoc
REM @title Git Diff to Clipboard Utility
REM @description Copies Git diff output to clipboard and optionally saves to file
REM @author ChatGPT
REM @version 1.0.0
REM
REM @usage
REM   git-diff [options] [files...]
REM
REM @options
REM   --cached     Show staged changes only
REM   --all        Show all changes (staged and unstaged)
REM   --file, -f   Save diff output to timestamped file in diffs/ directory
REM
REM @examples
REM   git-diff                     # Copy unstaged changes to clipboard
REM   git-diff --cached           # Copy staged changes
REM   git-diff file1.txt         # Copy changes for specific file
REM   git-diff -f                # Save diff to file and copy to clipboard
REM   git-diff --cached -f       # Save staged changes to file
REM   git-diff --all src/*.js -f # Save all changes for JS files
REM
REM @notes
REM   - Creates diffs/ directory if saving to file
REM   - Skips empty diffs
REM   - Handles untracked files gracefully
REM   - File naming: diff_YYYYMMDD_HHMM.diff
REM @end
REM ========================================================

setlocal enabledelayedexpansion

REM Verify Git repository
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo This is not a Git repository. Exiting...
    exit /b 1
)

REM Initialize variables
set "diff_type="      REM Stores --cached or HEAD for diff type
set "files="          REM Stores file arguments
set "save_file="      REM Flag for file saving option

REM Parse all command arguments
:parse_args
if "%1"=="" goto check_diff
if "%1"=="--cached" (
    set "diff_type=--cached"
    shift
) else if "%1"=="--all" (
    set "diff_type=HEAD"
    shift
) else if "%1"=="--file" (
    set "save_file=1"
    shift
) else if "%1"=="-f" (
    set "save_file=1"
    shift
) else (
    if defined files (
        set "files=!files! %1"
    ) else (
        set "files=%1"
    )
    shift
)
goto parse_args

:check_diff
REM Setup file saving if enabled
if defined save_file (
    set "diff_dir=%~dp0diffs"
    if not exist "!diff_dir!" mkdir "!diff_dir!"
    set "diff_file=!diff_dir!\diff_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%.diff"
    set "diff_file=!diff_file: =0!"
)

REM Validate tracked files
if defined files (
    git ls-files --error-unmatch !files! >nul 2>&1
    if !errorlevel! neq 0 (
        echo Some specified files are untracked. Add them first using: git add ^<file^>
        exit /b 1
    )
)

REM Execute git diff based on options
if "%diff_type%"=="--cached" (
    if defined files (
        git diff --cached !files! > "!diff_file!"
    ) else (
        git diff --cached > "!diff_file!"
    )
) else if "%diff_type%"=="HEAD" (
    if defined files (
        git diff HEAD !files! > "!diff_file!"
    ) else (
        git diff HEAD > "!diff_file!"
    )
) else (
    if defined files (
        git diff !files! > "!diff_file!"
    ) else (
        git diff > "!diff_file!"
    )
)

REM Handle empty diffs when saving to file
if defined save_file (
    for %%I in ("!diff_file!") do set "size=%%~zI"
    if !size! equ 0 (
        if defined files (
            echo No changes found for specified files
        ) else (
            echo No changes found
        )
        del "!diff_file!"
        exit /b 1
    )
    type "!diff_file!" | clip
    echo Diff saved to: !diff_file!
) else (
    git diff %diff_type% !files! | clip
)

echo Git diff copied to clipboard

endlocal

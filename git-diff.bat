@echo off
REM @batdoc Title: Git Diff to Clipboard
REM @batdoc Description: This script copies the Git diff output to the clipboard.
REM @batdoc Usage: git-diff.bat [--cached | --all] [file1 file2 ...]
REM @batdoc Parameters:
REM @batdoc --cached  Show the diff for staged changes
REM @batdoc --all     Show the diff for all changes (including staged and unstaged)
REM @batdoc file1, file2, ... Optional file paths to get diff for specific files
REM @batdoc Example: git-diff.bat --cached file1.txt src/file2.js

setlocal enabledelayedexpansion

REM Check if the current directory is a Git repository
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    REM @batdoc Error: This directory is not a Git repository.
    echo This is not a Git repository. Exiting...
    exit /b
)

REM Initialize variables
set "diff_type="
set "files="

REM Parse arguments
:parse_args
if "%1"=="" goto execute_diff
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

:execute_diff
REM Execute git diff based on arguments
if "%diff_type%"=="--cached" (
    REM @batdoc Action: Show the staged changes for specified files.
    if defined files (
        git diff --cached !files! | clip
    ) else (
        git diff --cached | clip
    )
) else if "%diff_type%"=="HEAD" (
    REM @batdoc Action: Show the diff for all changes for specified files.
    if defined files (
        git diff HEAD !files! | clip
    ) else (
        git diff HEAD | clip
    )
) else (
    REM @batdoc Action: Show the unstaged changes for specified files.
    if defined files (
        git diff !files! | clip
    ) else (
        git diff | clip
    )
)

REM Provide feedback to the user
if defined files (
    echo Git diff for specified files copied to clipboard!
) else (
    echo Git diff copied to clipboard!
)

endlocal
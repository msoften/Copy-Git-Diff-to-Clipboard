# Git Diff to Clipboard Utility

A Windows batch script utility that simplifies copying Git diff output to your clipboard. This tool
makes it easy to share code changes with colleagues or paste diffs into documents and messages.

## Features

- Copy unstaged changes to clipboard
- Copy staged changes to clipboard using `--cached` flag
- Copy all changes (both staged and unstaged) using `--all` flag
- Automatic PATH configuration during installation
- Error handling for non-Git repositories

## Installation

1. Download both script files:
    - `install-git-diff.bat`
    - `git-diff.bat`

2. Run the installation script:
   ```batch
   install-git-diff.bat
   ```

The installer will:

- Create a Scripts directory in your user profile if it doesn't exist (`%USERPROFILE%\Scripts`)
- Copy `git-diff.bat` to the Scripts directory
- Add the Scripts directory to your PATH (if not already present)
- Provide feedback about the installation process

## Usage

Once installed, you can use the script from any Git repository using the following commands:

```batch
# Copy unstaged changes to clipboard
git-diff

# Copy staged changes to clipboard
git-diff --cached

# Copy all changes (staged + unstaged) to clipboard
git-diff --all

# Copy changes and save to file
git-diff --file  # or -f
git-diff --cached --file file1.txt
git-diff --all -f src/*.js

# Copy all changes for specific files
git-diff --all file1.txt src/file2.js
```

### Examples

1. When you want to share uncommitted changes:
   ```batch
   cd your-repo
   git-diff
   ```

2. When you want to share staged changes:
   ```batch
   cd your-repo
   git-diff --cached
   ```

3. When you want to share all changes:
   ```batch
   cd your-repo
   git-diff --all
   ```

4. When you want to share changes for specific files:
   ```batch
   cd your-repo
   git-diff src/main.js test/utils.js
   ```

5. When you want to share staged changes for specific files:
   ```batch
   cd your-repo
   git-diff --cached config.json src/*.ts
   ```

Note: You can use wildcards and paths in file specifications, following Git's standard pattern
matching.

## Error Handling

The script includes error checking to ensure it's being used correctly:

- Verifies that the current directory is a Git repository
- Provides clear feedback when copying diff to clipboard
- Shows helpful error messages when something goes wrong

## System Requirements

- Windows operating system
- Git installed and accessible from command line
- Write permissions to `%USERPROFILE%\Scripts` directory

## Technical Details

### install-git-diff.bat

The installation script:

- Uses `%USERPROFILE%\Scripts` as the installation directory
- Creates the directory if it doesn't exist
- Adds the directory to the user's PATH
- Preserves existing PATH entries
- Provides visual feedback during installation

### git-diff.bat

The main utility script:

- Accepts command-line arguments for different diff types
- Uses Git's built-in diff commands
- Pipes output directly to the Windows clipboard
- Includes error handling for non-Git repositories
- Provides immediate feedback upon completion

## Troubleshooting

If you encounter issues:

1. Ensure Git is properly installed and accessible from command line
2. Verify the Scripts directory is in your PATH:
   ```batch
   echo %PATH%
   ```
3. Check if the script is properly installed:
   ```batch
   where git-diff.bat
   ```
4. Make sure you're running the command from within a Git repository

## Contributing

Feel free to fork this repository and submit pull requests with improvements. Some areas for
potential enhancement:

- Additional diff options
- Colored output support
- Custom installation directory support
- Integration with other Git commands

## License

These scripts are provided as-is under the MIT License. Feel free to modify and distribute them
according to your needs.

## Acknowledgments

This tool was created to streamline the process of sharing Git diffs in Windows environments,
inspired by the need for quick and easy code change sharing in development teams.
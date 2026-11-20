# FileGuard – File Integrity & Recovery System

A Bash-based file integrity monitoring, backup, and recovery system that helps users track file changes, protect important files, and restore deleted or modified files.

## 1. Project Overview

FileGuard is a command-line application developed using Bash scripting and Unix utilities. It monitors a user-registered directory by calculating SHA-256 checksums of files and comparing them with previously stored checksums.

Whenever a file is added, modified, or deleted, FileGuard identifies the change and records it in an activity log. Users can also mark important files as protected, create timestamped backups, and restore files from previously created backups.

## 2. Objectives

- Monitor files and detect unauthorized or unexpected changes.
- Maintain file integrity using SHA-256 checksums.
- Identify and track added, modified, and deleted files.
- Maintain a list of protected files.
- Create and manage timestamped backups.
- Restore files from previously created backups.
- Maintain a chronological record of file activities.
- Generate an integrity report of the registered directory.

## 3. Features

### 1. Directory Registration
Allows users to register a directory for monitoring. The selected directory is validated and its path is stored for future operations.

### 2. File Integrity Scanner
Uses SHA-256 checksums to identify changes in files by comparing the current file hashes with the previously stored baseline.

Detects:
- Added files
- Modified files
- Deleted files
- Unchanged files

### 3. Protected File Management
Allows users to mark important files as protected, remove protection, and view the protected file list.

Modifications or deletions involving protected files are reported separately by the scanner.

### 4. Backup Management
Creates timestamped backups of the registered directory and allows users to view available backups.

### 5. File Restoration
Allows users to select a backup and restore a specific file to its original location within the registered directory.

### 6. Change Timeline
Displays previously recorded file activities in reverse chronological order using the activity log.

### 7. Integrity Report
Generates a summary containing:
- Registered directory
- Total number of files
- Number of protected files
- Number of available backups
- Number of recorded changes

## 4. Technologies and Unix Commands Used

| Technology / Command | Purpose |
|---|---|
| Bash Shell | Main scripting language |
| `sha256sum` | Generates SHA-256 file checksums |
| `find` | Searches and lists files |
| `grep` | Searches for matching file paths |
| `awk` | Processes text and hash data |
| `sort` | Sorts change records |
| `cp` | Copies files and creates backups |
| `mkdir` | Creates directories |
| `wc` | Counts files and log entries |
| `date` | Generates timestamps |
| `cat` | Reads stored file data |
| `mapfile` | Loads backup entries into arrays |

## 5. Project Structure

```text
FileGuard/
│
├── fileguard.sh
│
├── modules/
│   ├── registration.sh
│   ├── scanner.sh
│   ├── protection.sh
│   ├── backup.sh
│   ├── restore.sh
│   └── reports.sh
│
├── data/
│   ├── baseline/
│   │   └── hashes.txt
│   ├── protected/
│   │   └── protected_files.txt
│   ├── registered_directory.txt
│   └── activity.log
│
├── backups/
│
├── reports/
│
├── test_files/
│
└── README.md
```

### Main Files

- `fileguard.sh` – Main application and menu-driven interface.
- `registration.sh` – Handles directory registration and validation.
- `scanner.sh` – Performs file integrity checks and detects changes.
- `protection.sh` – Manages protected files.
- `backup.sh` – Creates and lists backups.
- `restore.sh` – Restores files from selected backups.
- `reports.sh` – Displays the change timeline and integrity report.

## 6. Requirements

- Linux environment or Unix-compatible shell.
- Bash.
- Standard Unix utilities.
- `sha256sum` command.

The project can be executed using GitHub Codespaces or a Linux terminal.

## 7. Installation and Execution

**Step 1: Clone the repository**

```bash
git clone <repository-url>
```

**Step 2: Navigate to the project directory**

```bash
cd FileGuard
```

**Step 3: Give execution permission**

```bash
chmod +x fileguard.sh
```

**Step 4: Run the application**

```bash
./fileguard.sh
```

Alternatively:

```bash
bash fileguard.sh
```

## 8. Application Workflow

1. Launch FileGuard.
2. Register a directory to monitor.
3. Perform an initial scan to establish the file hash baseline.
4. Manage important files using the protection menu.
5. Scan the directory to identify file changes.
6. Create backups of the registered directory.
7. Restore individual files when required.
8. View the change timeline and generate an integrity report.

## 9. Testing

The following scenarios were tested during development:

| Test Scenario | Expected Result |
|---|---|
| Register a valid directory | Directory registered successfully |
| Add a new file | File detected as ADDED |
| Modify an existing file | File detected as MODIFIED |
| Delete an existing file | File detected as DELETED |
| Modify a protected file | Protected modification reported |
| Create a backup | Timestamped backup created |
| View backups | Available backups displayed |
| Restore a deleted file | File restored successfully |
| View change timeline | Recorded activities displayed |
| Generate integrity report | Directory summary displayed |

All the above test scenarios were successfully verified.

## 10. Limitations

- File changes are detected when the user manually runs a scan; monitoring is not continuous.
- File integrity is based on SHA-256 checksum comparison.
- Protected files are monitored and specially reported; protection does not prevent modifications.
- Restoration is performed for individual files rather than automatically recovering an entire directory.
- The application is designed for local directory monitoring and backup management.

## 11. Future Enhancements

- Automated periodic scanning.
- Email or desktop notifications for detected changes.
- Backup compression and storage optimization.
- Detailed report export.

## 12. Conclusion

FileGuard demonstrates the use of Bash scripting and Unix utilities to develop a practical file integrity and recovery system. It combines checksum-based change detection, protected file management, timestamped backups, file restoration, and activity logging in a single command-line application.

The project provides practical experience with shell scripting concepts such as functions, loops, conditional statements, arrays, file handling, command execution, and directory management.
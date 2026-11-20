
#!/bin/bash

# ==========================================
# FILEGUARD
# File Integrity Monitoring and Recovery
# ==========================================

# Project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Application directories
DATA_DIR="$PROJECT_DIR/data"
MODULE_DIR="$PROJECT_DIR/modules"
BACKUP_DIR="$PROJECT_DIR/backups"
REPORT_DIR="$PROJECT_DIR/reports"

# Load application modules
source "$MODULE_DIR/registration.sh"
source "$MODULE_DIR/protection.sh"
source "$MODULE_DIR/scanner.sh"
source "$MODULE_DIR/backup.sh"
source "$MODULE_DIR/restore.sh"
source "$MODULE_DIR/reports.sh"
# ==========================================
# DISPLAY APPLICATION HEADER
# ==========================================

show_header() {
    clear

    echo "=================================================="
    echo "                  FILEGUARD"
    echo "       FILE INTEGRITY & RECOVERY SYSTEM"
    echo "=================================================="
    echo
    echo "  Protect your files | Track changes | Recover"
    echo
    echo "  Date: $(date '+%d-%m-%Y')"
    echo "  Time: $(date '+%H:%M:%S')"
    echo
    echo "=================================================="
}

# ==========================================
# DISPLAY MAIN MENU
# ==========================================

show_menu() {

    echo
    echo "                 MAIN MENU"
    echo "--------------------------------------------------"
    echo "  1. Register a Directory"
    echo "  2. Scan for File Changes"
    echo "  3. Manage Protected Files"
    echo "  4. Create Backup"
    echo "  5. Restore a File"
    echo "  6. View Change Timeline"
    echo "  7. Generate Integrity Report"
    echo "  8. Exit"
    echo "--------------------------------------------------"

}

# ==========================================
# EXIT APPLICATION
# ==========================================

exit_application() {
    echo
    echo "=================================================="
    echo "       Thank you for using FileGuard!"
    echo "       Your files deserve protection."
    echo "=================================================="
    exit 0
}

# ==========================================
# MAIN APPLICATION LOOP
# ==========================================

main() {

    while true
    do

        show_header
        show_menu

        echo
        read -r -p "Enter your choice [1-8]: " choice

        case "$choice" in

            1)
                register_directory
                ;;

            2)
                scan_files
                ;;

            3)
                manage_protected_files
                ;;

            4)
                backup_menu
                ;;

            5)
                restore_file
                ;;

            6)
                view_timeline
                ;;

            7)
                generate_integrity_report
                ;;

            8)
                exit_application
                ;;

            *)
                echo
                echo "[ERROR] Invalid choice!"
                echo "Please enter a number between 1 and 8."
                ;;

        esac

        echo
        read -r -p "Press Enter to return to the main menu..." pause

    done
}

# ==========================================
# START APPLICATION
# ==========================================

main

#!/bin/bash

# ==========================================
# FILEGUARD - BACKUP MANAGEMENT
# ==========================================

create_backup() {

    # Check whether a directory is registered
    if [[ ! -f "$DATA_DIR/registered_directory.txt" ]]; then
        echo "[ERROR] Please register a directory first."
        return
    fi

    target_dir=$(cat "$DATA_DIR/registered_directory.txt")

    if [[ ! -d "$target_dir" ]]; then
        echo "[ERROR] Registered directory is unavailable."
        return
    fi

    # Prevent backup storage from being inside the monitored folder
    case "$BACKUP_DIR/" in
        "$target_dir/"*)
            echo "[ERROR] Backup folder cannot be inside the registered directory."
            return
            ;;
    esac

    # Create a timestamp for this backup
    timestamp=$(date '+%Y%m%d_%H%M%S')

    snapshot_dir="$BACKUP_DIR/backup_$timestamp"

    echo
    echo "=================================================="
    echo "                 CREATING BACKUP"
    echo "=================================================="
    echo "Source: $target_dir"
    echo

    # Create the backup folder
    mkdir -p "$snapshot_dir"

    # Copy all files, including hidden files
    if cp -a "$target_dir/." "$snapshot_dir/"; then

        file_count=$(find "$snapshot_dir" -type f | wc -l)

        echo "[SUCCESS] Backup created successfully."
        echo "Backup name: backup_$timestamp"
        echo "Files copied: $file_count"
        echo "Saved at: $snapshot_dir"

    else

        echo "[ERROR] Backup failed."
        rm -rf -- "$snapshot_dir"

    fi
}

view_backups() {

    echo
    echo "=================================================="
    echo "                 AVAILABLE BACKUPS"
    echo "=================================================="

    mkdir -p "$BACKUP_DIR"

    count=0

    while IFS= read -r backup
    do
        ((count++))
        file_count=$(find "$backup" -type f | wc -l)

        echo "$count. $(basename "$backup")"
        echo "   Files: $file_count"
        echo

    done < <(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -name 'backup_*' | sort)

    if [[ "$count" -eq 0 ]]; then
        echo "No backups available."
    fi
}

backup_menu() {

    while true
    do
        echo
        echo "=================================================="
        echo "                 BACKUP MANAGER"
        echo "=================================================="
        echo "1. Create a Backup"
        echo "2. View Available Backups"
        echo "3. Return to Main Menu"
        echo "=================================================="

        read -r -p "Enter your choice [1-3]: " choice

        case "$choice" in

            1)
                create_backup
                ;;

            2)
                view_backups
                ;;

            3)
                return
                ;;

            *)
                echo "[ERROR] Invalid choice."
                ;;
        esac

        echo
        read -r -p "Press Enter to continue..."
    done
}
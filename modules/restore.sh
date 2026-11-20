#!/bin/bash

# ==========================================
# FILEGUARD - FILE RESTORE SYSTEM
# ==========================================

restore_file() {

    echo
    echo "=================================================="
    echo "                  RESTORE FILE"
    echo "=================================================="

    # Check registered directory
    if [[ ! -f "$DATA_DIR/registered_directory.txt" ]]; then
        echo "[ERROR] Please register a directory first."
        return
    fi

    target_dir=$(cat "$DATA_DIR/registered_directory.txt")

    if [[ ! -d "$target_dir" ]]; then
        echo "[ERROR] Registered directory is unavailable."
        return
    fi

    # Find available backups
    mapfile -t backups < <(
        find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 \
        -type d -name 'backup_*' | sort
    )

    if [[ ${#backups[@]} -eq 0 ]]; then
        echo "[ERROR] No backups available."
        return
    fi

    # Display backups
    echo
    echo "Available Backups:"
    echo

    for i in "${!backups[@]}"
    do
        echo "$((i + 1)). $(basename "${backups[$i]}")"
    done

    echo
    read -r -p "Select backup number: " choice

    if [[ ! "$choice" =~ ^[0-9]+$ ]] ||
       (( choice < 1 || choice > ${#backups[@]} )); then
        echo "[ERROR] Invalid backup selection."
        return
    fi

    selected_backup="${backups[$((choice - 1))]}"

    # Ask for the file to restore
    echo
    read -r -p "Enter file name to restore: " file_name

    if [[ -z "$file_name" ]]; then
        echo "[ERROR] File name cannot be empty."
        return
    fi

    # Only accept relative paths inside the backup
    case "$file_name" in
        /*|..|../*|*/../*|*/..)
            echo "[ERROR] Invalid file path."
            return
            ;;
    esac

    backup_file="$selected_backup/$file_name"
    destination="$target_dir/$file_name"

    if [[ ! -f "$backup_file" ]]; then
        echo "[ERROR] File not found in selected backup."
        return
    fi

    # Ask before overwriting an existing file
    if [[ -e "$destination" ]]; then
        echo
        echo "[WARNING] This file already exists."
        read -r -p "Do you want to overwrite it? (y/n): " confirm

        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            echo "[INFO] Restore cancelled."
            return
        fi
    fi

    # Create destination folder if needed
    mkdir -p "$(dirname "$destination")"

    # Restore the file
    if cp -p -- "$backup_file" "$destination"; then
        echo
        echo "[SUCCESS] File restored successfully."
        echo "Restored file: $destination"
    else
        echo "[ERROR] File restoration failed."
    fi
}

#!/bin/bash

# ==========================================
# DIRECTORY REGISTRATION MODULE
# ==========================================

register_directory() {

    echo
    echo "=================================================="
    echo "             DIRECTORY REGISTRATION"
    echo "=================================================="

    # Ask the user for a directory path
    echo
    read -r -p "Enter the directory path to monitor: " target_dir

    # Remove unnecessary trailing slashes
    target_dir="${target_dir%/}"

    # Check whether the user entered a path
    if [[ -z "$target_dir" ]]; then
        echo
        echo "[ERROR] No directory path entered."
        return
    fi

    # Check whether the directory exists
    if [[ ! -d "$target_dir" ]]; then
        echo
        echo "[ERROR] Directory does not exist."
        return
    fi

    # Convert the path into an absolute path
    target_dir="$(cd "$target_dir" 2>/dev/null && pwd -P)" || {
        echo
        echo "[ERROR] Cannot access this directory."
        return
    }

    # Prevent FileGuard from monitoring its own internal folders
case "$target_dir" in

    "$PROJECT_DIR"|\
    "$DATA_DIR"|"$DATA_DIR/"*|\
    "$MODULE_DIR"|"$MODULE_DIR/"*|\
    "$BACKUP_DIR"|"$BACKUP_DIR/"*|\
    "$REPORT_DIR"|"$REPORT_DIR/"*)

        echo
        echo "[ERROR] This is a FileGuard internal directory."
        echo "Please select a different directory."
        return
        ;;

esac

    # Check directory read and execute permissions
    if [[ ! -r "$target_dir" || ! -x "$target_dir" ]]; then
        echo
        echo "[ERROR] You do not have sufficient permission."
        return
    fi

    # Save the registered directory
    echo "$target_dir" > "$DATA_DIR/registered_directory.txt"

    echo
    echo "--------------------------------------------------"
    echo "[SUCCESS] Directory registered successfully!"
    echo "--------------------------------------------------"
    echo "Registered path: $target_dir"
    echo
    echo "FileGuard is now ready to monitor this directory."

}

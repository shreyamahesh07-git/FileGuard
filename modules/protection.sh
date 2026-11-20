#!/bin/bash

# ==========================================
# FILEGUARD - PROTECTED FILE MANAGEMENT
# ==========================================

manage_protected_files() {
protected_dir="$DATA_DIR/protected"
protected_file="$protected_dir/protected_files.txt"

# Load the registered directory
if [[ ! -f "$DATA_DIR/registered_directory.txt" ]]; then
    echo "[ERROR] No directory registered."
    echo "Please register a directory first."
    return
fi

target_dir=$(cat "$DATA_DIR/registered_directory.txt")

if [[ ! -d "$target_dir" ]]; then
    echo "[ERROR] Registered directory is unavailable."
    return
fi

mkdir -p "$protected_dir"
touch "$protected_file"

    while true
    do
        echo
        echo "=================================================="
        echo "             PROTECTED FILE MANAGER"
        echo "=================================================="
        echo "1. Protect a File"
        echo "2. Remove File Protection"
        echo "3. View Protected Files"
        echo "4. Return to Main Menu"
        echo "=================================================="

        read -r -p "Enter your choice [1-4]: " choice

        case "$choice" in

            1)
                echo
                read -r -p "Enter file path to protect: " input_file

                if [[ -z "$input_file" ]]; then
                    echo "[ERROR] File path cannot be empty."
                    continue
                fi

                # Resolve the file path
                if [[ "$input_file" = /* ]]; then
                    file_path=$(realpath -e -- "$input_file" 2>/dev/null)
                else
                    file_path=$(realpath -e -- "$target_dir/$input_file" 2>/dev/null)
                fi

                if [[ -z "$file_path" || ! -f "$file_path" ]]; then
                    echo "[ERROR] File does not exist."
                    continue
                fi

                # Ensure file belongs to registered directory
                case "$file_path" in
                    "$target_dir"/*)
                        ;;
                    *)
                        echo "[ERROR] File is outside the registered directory."
                        continue
                        ;;
                esac

                # Check for duplicate protection
                if grep -Fqx -- "$file_path" "$protected_file"; then
                    echo "[INFO] This file is already protected."
                else
                    printf '%s\n' "$file_path" >> "$protected_file"
                    echo "[SUCCESS] File protected successfully."
                fi
                ;;

            2)
                echo
                echo "Enter the file path exactly as shown in the protected files list."
                read -r -p "File path to unprotect: " input_file

                if [[ "$input_file" = /* ]]; then
                    file_path=$(realpath -m -- "$input_file")
                else
                    file_path=$(realpath -m -- "$target_dir/$input_file")
                fi

                if grep -Fqx -- "$file_path" "$protected_file"; then
                    grep -Fvx -- "$file_path" "$protected_file" > "$protected_dir/temp.txt"
                    mv "$protected_dir/temp.txt" "$protected_file"
                    echo "[SUCCESS] File protection removed."
                else
                    echo "[ERROR] File is not in the protected list."
                fi
                ;;

            3)
                echo
                echo "------------- PROTECTED FILES -------------"

                if [[ ! -s "$protected_file" ]]; then
                    echo "No files are currently protected."
                else
                    count=1
                    while IFS= read -r file_path
                    do
                        echo "$count. $file_path"
                        ((count++))
                    done < "$protected_file"
                fi
                ;;

            4)
                return
                ;;

            *)
                echo "[ERROR] Invalid choice. Enter 1-4."
                ;;

        esac

        echo
        read -r -p "Press Enter to continue..."
    done
}
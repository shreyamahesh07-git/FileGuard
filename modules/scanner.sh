
#!/bin/bash

# ==========================================
# FILEGUARD - FILE INTEGRITY SCANNER
# ==========================================

scan_files() {

    echo
    echo "=================================================="
    echo "              FILE INTEGRITY SCANNER"
    echo "=================================================="

    # Check registered directory
    if [[ ! -f "$DATA_DIR/registered_directory.txt" ]]; then
        echo
        echo "[ERROR] No directory registered."
        echo "Please register a directory first."
        return
    fi

    # Read registered directory
    target_dir="$(cat "$DATA_DIR/registered_directory.txt")"

    # Check directory availability
    if [[ ! -d "$target_dir" ]]; then
        echo
        echo "[ERROR] Registered directory unavailable."
        return
    fi

    # Check read permission
    if [[ ! -r "$target_dir" || ! -x "$target_dir" ]]; then
        echo
        echo "[ERROR] Cannot access registered directory."
        return
    fi

    mkdir -p "$DATA_DIR/baseline"

    baseline_file="$DATA_DIR/baseline/hashes.txt"
    temp_file="$DATA_DIR/baseline/current_hashes.txt"

    # Generate current hashes
    > "$temp_file"

    echo
    echo "Scanning directory: $target_dir"
    echo

    while IFS= read -r -d '' file
    do

        hash=$(sha256sum "$file" | awk '{print $1}')

        printf '%s  %s\n' "$hash" "$file" >> "$temp_file"

    done < <(find "$target_dir" -type f -print0)

    # Count current files
    file_count=$(wc -l < "$temp_file")

    # Create initial baseline if one does not exist
    if [[ ! -f "$baseline_file" ]]; then

        mv "$temp_file" "$baseline_file"

        echo "[SUCCESS] Initial baseline created."
        echo "Files scanned: $file_count"
        return

    fi

    # Initialize counters
    added=0
    modified=0
    deleted=0
    unchanged=0

    # Create activity log
    log_file="$DATA_DIR/activity.log"
    touch "$log_file"

    echo "---------------- DETECTED CHANGES ----------------"
    echo

    # Compare current files with previous baseline
    while IFS= read -r line
    do

        current_hash="${line:0:64}"
        file="${line:66}"

        old_hash=""

        # Find the previous hash for this exact path
        while IFS= read -r baseline_line
        do

            stored_hash="${baseline_line:0:64}"
            stored_path="${baseline_line:66}"

            if [[ "$stored_path" == "$file" ]]; then
                old_hash="$stored_hash"
                break
            fi

        done < "$baseline_file"

        if [[ -z "$old_hash" ]]; then

            echo "[ADDED] $file"
            ((added++))
            echo "$(date '+%d-%m-%Y %H:%M:%S') | ADDED | $file" >> "$log_file"

        elif [[ "$current_hash" != "$old_hash" ]]; then

    if [[ -f "$DATA_DIR/protected/protected_files.txt" ]] &&
       grep -Fqx -- "$file" "$DATA_DIR/protected/protected_files.txt"; then

        echo "[PROTECTED FILE MODIFIED] $file"
        echo "$(date '+%d-%m-%Y %H:%M:%S') | PROTECTED FILE MODIFIED | $file" >> "$log_file"

    else

        echo "[MODIFIED] $file"
        echo "$(date '+%d-%m-%Y %H:%M:%S') | MODIFIED | $file" >> "$log_file"

    fi

    ((modified++))

        else

            echo "[UNCHANGED] $file"
            ((unchanged++))

        fi

    done < "$temp_file"

    # Detect deleted files
    while IFS= read -r line
    do

        old_path="${line:66}"

        if [[ ! -f "$old_path" ]]; then

    if [[ -f "$DATA_DIR/protected/protected_files.txt" ]] &&
       grep -Fqx -- "$old_path" "$DATA_DIR/protected/protected_files.txt"; then

        echo "[PROTECTED FILE DELETED] $old_path"
        echo "$(date '+%d-%m-%Y %H:%M:%S') | PROTECTED FILE DELETED | $old_path" >> "$log_file"

    else

        echo "[DELETED] $old_path"
        echo "$(date '+%d-%m-%Y %H:%M:%S') | DELETED | $old_path" >> "$log_file"

    fi

    ((deleted++))

fi
    done < "$baseline_file"

    # Update baseline to current state
    mv "$temp_file" "$baseline_file"

    echo
    echo "=================================================="
    echo "                 SCAN SUMMARY"
    echo "=================================================="
    echo "Added files:     $added"
    echo "Modified files:  $modified"
    echo "Deleted files:   $deleted"
    echo "Unchanged files: $unchanged"
    echo "=================================================="

    echo
    echo "[SUCCESS] Integrity scan completed."

}

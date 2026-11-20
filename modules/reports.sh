#!/bin/bash

# ==========================================
# FILEGUARD - CHANGE TIMELINE
# ==========================================

view_timeline() {

    log_file="$DATA_DIR/activity.log"

    echo
    echo "=================================================="
    echo "                  CHANGE TIMELINE"
    echo "=================================================="

    if [[ ! -f "$log_file" || ! -s "$log_file" ]]; then
        echo "No file changes have been recorded yet."
        return
    fi

    echo
    echo "Recorded File Changes:"
    echo

    sort -r "$log_file"

    echo
    echo "=================================================="
    echo "             END OF CHANGE TIMELINE"
    echo "=================================================="
}
generate_integrity_report() {

    echo
    echo "=================================================="
    echo "                 INTEGRITY REPORT"
    echo "=================================================="

    if [[ ! -f "$DATA_DIR/registered_directory.txt" ]]; then
        echo "[ERROR] No directory registered."
        return
    fi

    target_dir=$(cat "$DATA_DIR/registered_directory.txt")

    if [[ ! -d "$target_dir" ]]; then
        echo "[ERROR] Registered directory is unavailable."
        return
    fi

    file_count=$(find "$target_dir" -type f | wc -l)

    protected_file="$DATA_DIR/protected/protected_files.txt"

    if [[ -f "$protected_file" ]]; then
        protected_count=$(wc -l < "$protected_file")
    else
        protected_count=0
    fi

    mkdir -p "$BACKUP_DIR"

    backup_count=$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 \
        -type d -name 'backup_*' | wc -l)

    if [[ -f "$DATA_DIR/activity.log" ]]; then
        change_count=$(wc -l < "$DATA_DIR/activity.log")
    else
        change_count=0
    fi

    echo
    echo "Registered Directory : $target_dir"
    echo "Total Files          : $file_count"
    echo "Protected Files      : $protected_count"
    echo "Available Backups    : $backup_count"
    echo "Recorded Changes     : $change_count"

    echo
    echo "=================================================="
    echo "           END OF INTEGRITY REPORT"
    echo "=================================================="
}
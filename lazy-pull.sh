#!/bin/bash

# Default values
DEFAULT_REPO_CONFIG="/home/$USER/projects/default/projects_config.txt"   # Default config path
DEFAULT_LOG_FILE="/home/$USER/projects/default/log_file.txt"             # Default log file path
DEFAULT_EMAIL_NOTIFICATION="your-email@example.com"                      # Default email

# Parse command-line arguments
while getopts "c:l:e:" opt; do
    case $opt in
        c) REPO_CONFIG=$OPTARG ;;
        l) LOG_FILE=$OPTARG ;;
        e) EMAIL_NOTIFICATION=$OPTARG ;;
        \?) echo "Invalid option -$OPTARG" >&2 ;;
    esac
done

# Use default values if arguments are not provided
REPO_CONFIG="${REPO_CONFIG:-$DEFAULT_REPO_CONFIG}"
LOG_FILE="${LOG_FILE:-$DEFAULT_LOG_FILE}"
EMAIL_NOTIFICATION="${EMAIL_NOTIFICATION:-$DEFAULT_EMAIL_NOTIFICATION}"

# Function to perform git pull
git_pull() {
    local repo_dir=$1
    local branch_name=$2

    echo "[$(date)] INFO: Navigating to repository directory: $repo_dir" | tee -a "$LOG_FILE"
    cd "$repo_dir" || {
        echo "[$(date)] ERROR: Failed to navigate to repository directory: $repo_dir" | tee -a "$LOG_FILE"
        return 1
    }

    if [ ! -d .git ]; then
        echo "[$(date)] ERROR: $repo_dir is not a valid Git repository." | tee -a "$LOG_FILE"
        return 1
    fi

    echo "[$(date)] INFO: Switching to branch $branch_name" | tee -a "$LOG_FILE"
    git checkout "$branch_name" >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "[$(date)] ERROR: Failed to switch to branch $branch_name." | tee -a "$LOG_FILE"
        return 1
    fi

    echo "[$(date)] INFO: Pulling latest changes from $branch_name" | tee -a "$LOG_FILE"
    git pull origin "$branch_name" >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        echo "[$(date)] SUCCESS: Successfully pulled latest changes from $branch_name." | tee -a "$LOG_FILE"
    else
        echo "[$(date)] ERROR: Failed to pull latest changes from $branch_name. Check logs." | tee -a "$LOG_FILE"
        echo "[$(date)] ERROR: Pull failed. Check logs." | mail -s "Git Pull Failure" "$EMAIL_NOTIFICATION"  # Optional Email Notification
        return 1
    fi
}

# Main Execution
while IFS=, read -r REPO_DIR BRANCH_NAMES
do
    echo "[$(date)] INFO: Processing repository: $REPO_DIR" | tee -a "$LOG_FILE"
    
    # Check if the directory is a Git repository
    if [ ! -d "$REPO_DIR/.git" ]; then
        echo "[$(date)] ERROR: $REPO_DIR is not a valid Git repository." | tee -a "$LOG_FILE"
        continue
    fi
    
    # Pull latest changes from all specified branches
    for BRANCH_NAME in ${BRANCH_NAMES// / }; do
        git_pull "$REPO_DIR" "$BRANCH_NAME"
    done
done < "$REPO_CONFIG"

# Log a success message to console and the log file
echo "[$(date)] Pull process completed successfully for all projects." | tee -a "$LOG_FILE"

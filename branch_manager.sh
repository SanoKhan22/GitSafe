#!/bin/bash

# Git Branch Manager
# A comprehensive branch management system for safe Git operations
# Version: 1.0.0

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# =============================================================================
# GLOBAL VARIABLES AND CONFIGURATION
# =============================================================================

# Script metadata
readonly SCRIPT_NAME="branch_manager"
readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configuration paths
readonly CONFIG_DIR="$HOME/.config/branch_manager"
readonly CONFIG_FILE="$CONFIG_DIR/config"
readonly LOG_DIR="$CONFIG_DIR/logs"
readonly LOG_FILE="$LOG_DIR/branch_manager.log"
readonly BACKUP_DIR="$CONFIG_DIR/backups"

# Default configuration values
declare -A DEFAULT_CONFIG=(
    ["DEFAULT_BASE_BRANCH"]="main"
    ["DEFAULT_WORKFLOW"]="github-flow"
    ["AUTO_CLEANUP_MERGED"]="true"
    ["CONFLICT_RESOLUTION_TOOL"]="code --wait"
    ["BACKUP_RETENTION_DAYS"]="7"
    ["LOG_LEVEL"]="INFO"
    ["AUTO_FETCH"]="true"
    ["REQUIRE_CONFIRMATION"]="true"
)

# Workflow patterns
declare -A WORKFLOW_PATTERNS=(
    ["github-flow"]="feature/,hotfix/"
    ["gitflow"]="feature/,develop/,release/,hotfix/"
    ["custom"]="feat/,fix/,chore/"
)

# Current configuration (loaded from file)
declare -A CONFIG

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# =============================================================================
# LOGGING INFRASTRUCTURE
# =============================================================================

# Initialize logging system
init_logging() {
    # Create log directory if it doesn't exist
    mkdir -p "$LOG_DIR"
    
    # Create log file if it doesn't exist
    if [[ ! -f "$LOG_FILE" ]]; then
        touch "$LOG_FILE"
    fi
    
    # Log script startup (after file is created)
    log_info "Branch Manager v$SCRIPT_VERSION started"
    log_info "Log file: $LOG_FILE"
}

# Log message with timestamp and level
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Ensure log directory exists before writing
    mkdir -p "$LOG_DIR"
    
    # Write to log file
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    # Also output to stderr for ERROR and WARN levels
    case "$level" in
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message" >&2
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} $message" >&2
            ;;
        "INFO")
            if [[ "${CONFIG[LOG_LEVEL]:-INFO}" != "ERROR" ]]; then
                echo -e "${BLUE}[INFO]${NC} $message"
            fi
            ;;
        "DEBUG")
            if [[ "${CONFIG[LOG_LEVEL]:-INFO}" == "DEBUG" ]]; then
                echo -e "${PURPLE}[DEBUG]${NC} $message"
            fi
            ;;
    esac
}

# Convenience logging functions
log_error() { log_message "ERROR" "$1"; }
log_warn() { log_message "WARN" "$1"; }
log_info() { log_message "INFO" "$1"; }
log_debug() { log_message "DEBUG" "$1"; }

# Log operation with structured format for audit trail
log_operation() {
    local operation="$1"
    local branch="${2:-}"
    local status="$3"
    local details="${4:-}"
    
    # Use enhanced logging
    log_detailed_operation "$operation" "$branch" "$status" "$details"
}

# =============================================================================
# CONFIGURATION SYSTEM
# =============================================================================

# Create default configuration file
create_default_config() {
    mkdir -p "$CONFIG_DIR"
    
    cat > "$CONFIG_FILE" << EOF
# Git Branch Manager Configuration
# This file contains default settings for branch operations

# Default base branch for new feature branches
DEFAULT_BASE_BRANCH=${DEFAULT_CONFIG[DEFAULT_BASE_BRANCH]}

# Workflow pattern (github-flow, gitflow, custom)
DEFAULT_WORKFLOW=${DEFAULT_CONFIG[DEFAULT_WORKFLOW]}

# Automatically cleanup merged branches
AUTO_CLEANUP_MERGED=${DEFAULT_CONFIG[AUTO_CLEANUP_MERGED]}

# Conflict resolution tool command
CONFLICT_RESOLUTION_TOOL="${DEFAULT_CONFIG[CONFLICT_RESOLUTION_TOOL]}"

# Backup retention in days
BACKUP_RETENTION_DAYS=${DEFAULT_CONFIG[BACKUP_RETENTION_DAYS]}

# Logging level (DEBUG, INFO, WARN, ERROR)
LOG_LEVEL=${DEFAULT_CONFIG[LOG_LEVEL]}

# Automatically fetch from remote before operations
AUTO_FETCH=${DEFAULT_CONFIG[AUTO_FETCH]}

# Require confirmation for destructive operations
REQUIRE_CONFIRMATION=${DEFAULT_CONFIG[REQUIRE_CONFIRMATION]}
EOF

    log_info "Created default configuration at $CONFIG_FILE"
}

# Load configuration from file
load_configuration() {
    # Initialize CONFIG with defaults
    for key in "${!DEFAULT_CONFIG[@]}"; do
        CONFIG["$key"]="${DEFAULT_CONFIG[$key]}"
    done
    
    # Create config file if it doesn't exist
    if [[ ! -f "$CONFIG_FILE" ]]; then
        log_info "Configuration file not found, creating default configuration"
        create_default_config
    fi
    
    # Source the configuration file
    if [[ -r "$CONFIG_FILE" ]]; then
        # Read configuration safely
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^[[:space:]]*# ]] && continue
            [[ -z "$key" ]] && continue
            
            # Remove leading/trailing whitespace
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            
            # Remove quotes from value if present
            value="${value%\"}"
            value="${value#\"}"
            
            # Store in CONFIG array
            CONFIG["$key"]="$value"
        done < "$CONFIG_FILE"
        
        log_debug "Configuration loaded from $CONFIG_FILE"
    else
        log_warn "Cannot read configuration file $CONFIG_FILE, using defaults"
    fi
}

# Display current configuration
show_configuration() {
    echo -e "${WHITE}Current Configuration:${NC}"
    echo "======================="
    
    for key in "${!CONFIG[@]}"; do
        echo -e "${CYAN}$key${NC}: ${CONFIG[$key]}"
    done
    
    echo ""
    echo -e "${WHITE}Available Workflow Patterns:${NC}"
    for pattern in "${!WORKFLOW_PATTERNS[@]}"; do
        echo -e "${CYAN}$pattern${NC}: ${WORKFLOW_PATTERNS[$pattern]}"
    done
}

# =============================================================================
# ERROR HANDLING AND CLEANUP
# =============================================================================

# Global error handler
error_handler() {
    local line_number="$1"
    local error_code="$2"
    local command="$3"
    
    log_error "Script failed at line $line_number with exit code $error_code"
    log_error "Failed command: $command"
    
    # Perform cleanup if needed
    cleanup_on_error
    
    exit "$error_code"
}

# Cleanup function for error conditions
cleanup_on_error() {
    log_info "Performing error cleanup..."
    
    # Add any necessary cleanup operations here
    # For example: restore from backup, reset repository state, etc.
    
    log_info "Error cleanup completed"
}

# Set up error handling
trap 'error_handler ${LINENO} $? "$BASH_COMMAND"' ERR

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Check if we're in a Git repository
check_git_repository() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a Git repository. Please run this script from within a Git repository."
        exit 1
    fi
    
    log_debug "Git repository detected"
}

# Get current branch name
get_current_branch() {
    git branch --show-current 2>/dev/null || {
        log_error "Unable to determine current branch"
        return 1
    }
}

# Check if branch exists
branch_exists() {
    local branch_name="$1"
    git show-ref --verify --quiet "refs/heads/$branch_name" 2>/dev/null
}

# Display comprehensive script usage
show_usage() {
    echo -e "${WHITE}Git Branch Manager v$SCRIPT_VERSION${NC}"
    echo -e "${WHITE}======================================${NC}"
    echo ""
    echo -e "${CYAN}DESCRIPTION:${NC}"
    echo "    A comprehensive branch management system for safe Git operations"
    echo "    with intelligent conflict resolution and seamless GitHub integration."
    echo ""
    
    echo -e "${CYAN}USAGE:${NC}"
    echo "    $0 [COMMAND] [OPTIONS]"
    echo "    $0                      # Interactive mode (recommended for beginners)"
    echo ""
    
    echo -e "${CYAN}CORE COMMANDS:${NC}"
    echo "    create <branch-name>    Create a new feature branch"
    echo "    switch <branch-name>    Switch to an existing branch"
    echo "    merge <source> [target] Merge a branch into target branch"
    echo "    sync [branch]           Synchronize with remote repository"
    echo "    status [--all]          Show branch status information"
    echo "    cleanup [target]        Clean up merged branches"
    echo "    push [message]          Commit and push changes to remote repository"
    echo ""
    
    echo -e "${CYAN}WORKFLOW COMMANDS:${NC}"
    echo "    workflow complete-feature       Complete feature development workflow"
    echo "    workflow merge-and-push <src>   Merge branch and push to GitHub"
    echo "    workflow setup-config           Set up shared configuration"
    echo ""
    
    echo -e "${CYAN}UTILITY COMMANDS:${NC}"
    echo "    config                  Show current configuration"
    echo "    help                    Show this help message"
    echo "    version                 Show version information"
    echo ""
    
    echo -e "${CYAN}GLOBAL OPTIONS:${NC}"
    echo "    -h, --help              Show command-specific help"
    echo "    -v, --version           Show version information"
    echo "    --debug                 Enable debug logging"
    echo "    --no-confirm            Skip confirmation prompts"
    echo "    --no-fetch              Skip automatic fetching"
    echo "    --workflow=<name>       Use specific workflow (github-flow, gitflow, custom)"
    echo "    --base=<branch>         Override default base branch"
    echo ""
    
    echo -e "${CYAN}COMMAND-SPECIFIC OPTIONS:${NC}"
    echo ""
    echo -e "${YELLOW}create:${NC}"
    echo "    --workflow-type=<type>  Create workflow-specific branch (feature, hotfix, release)"
    echo "    --base=<branch>         Create from specific base branch"
    echo ""
    echo -e "${YELLOW}merge:${NC}"
    echo "    --strategy=<type>       Merge strategy (auto, fast-forward, merge-commit)"
    echo "    --no-sync              Skip syncing target branch"
    echo "    --workflow-validate    Enable workflow validation"
    echo ""
    echo -e "${YELLOW}sync:${NC}"
    echo "    --strategy=<type>       Sync strategy (auto, pull, rebase)"
    echo ""
    echo -e "${YELLOW}status:${NC}"
    echo "    --all                   Show all branches"
    echo "    --remote                Include remote branch information"
    echo "    --verbose               Show detailed information"
    echo ""
    echo -e "${YELLOW}cleanup:${NC}"
    echo "    --auto                  Auto-confirm all deletions"
    echo "    --dry-run               Show what would be deleted without deleting"
    echo ""
    
    echo -e "${CYAN}WORKFLOW EXAMPLES:${NC}"
    echo ""
    echo -e "${YELLOW}GitHub Flow:${NC}"
    echo "    $0 create feature/user-login"
    echo "    $0 merge feature/user-login main"
    echo "    $0 cleanup"
    echo ""
    echo -e "${YELLOW}GitFlow:${NC}"
    echo "    $0 create --workflow-type=feature shopping-cart"
    echo "    $0 merge feature/shopping-cart develop"
    echo "    $0 create --workflow-type=release v1.2.0"
    echo ""
    echo -e "${YELLOW}Advanced:${NC}"
    echo "    $0 create feature/api --base=develop --no-confirm"
    echo "    $0 merge feature/api main --strategy=fast-forward"
    echo "    $0 status --all --verbose --remote"
    echo "    $0 workflow complete-feature"
    echo ""
    
    echo -e "${CYAN}INTERACTIVE MODE:${NC}"
    echo "    Run without arguments for a beautiful menu-driven interface:"
    echo "    $0"
    echo ""
    echo "    Features:"
    echo "    • Branch Operations    - Create, switch, list, manage branches"
    echo "    • Merge Operations     - Interactive merging with conflict resolution"
    echo "    • Remote Sync          - Upstream management and synchronization"
    echo "    • Repository Status    - Health checks and detailed information"
    echo "    • Cleanup Operations   - Branch cleanup, backups, rollback points"
    echo "    • Configuration        - Settings and workflow management"
    echo "    • Help & Information   - Usage examples and troubleshooting"
    echo ""
    
    echo -e "${CYAN}CONFIGURATION:${NC}"
    echo "    Configuration file: $CONFIG_FILE"
    echo "    Log file: $LOG_FILE"
    echo "    Operations log: $LOG_DIR/operations.log"
    echo "    Backups: $BACKUP_DIR"
    echo ""
    
    echo -e "${CYAN}GETTING HELP:${NC}"
    echo "    Command help:       $0 <command> --help"
    echo "    Interactive help:   $0 → Help & Information"
    echo "    Workflow examples:  $0 → Help & Information → Workflow examples"
    echo "    Troubleshooting:    $0 → Help & Information → Troubleshooting guide"
    echo "    Configuration:      See CONFIGURATION.md"
    echo "    Full documentation: See README.md"
    echo ""
    
    echo -e "${CYAN}SUPPORT:${NC}"
    echo "    • Generate diagnostic report: Interactive menu → Cleanup → Logging → Generate report"
    echo "    • Enable debug mode: $0 --debug <command>"
    echo "    • Check operation logs: $LOG_DIR/operations.log"
    echo "    • Repository health check: Interactive menu → Repository Status → Repository health check"
}

# Display version information
show_version() {
    echo -e "${WHITE}Git Branch Manager${NC}"
    echo -e "Version: ${CYAN}$SCRIPT_VERSION${NC}"
    echo -e "Configuration: ${CYAN}$CONFIG_FILE${NC}"
    echo -e "Logs: ${CYAN}$LOG_FILE${NC}"
}

# =============================================================================
# SAFETY CHECKS AND VALIDATION MODULE
# =============================================================================

# Working tree validation functions

# Check for uncommitted changes in the working tree
check_uncommitted_changes() {
    log_debug "Checking for uncommitted changes..."
    
    # Check if there are any changes in the working tree
    if ! git diff-index --quiet HEAD --; then
        return 0  # Has uncommitted changes
    else
        return 1  # No uncommitted changes
    fi
}

# Check for staged files
check_staged_files() {
    log_debug "Checking for staged files..."
    
    # Check if there are any staged changes
    if ! git diff-index --quiet --cached HEAD --; then
        return 0  # Has staged files
    else
        return 1  # No staged files
    fi
}

# Check for untracked files
check_untracked_files() {
    log_debug "Checking for untracked files..."
    
    # Get list of untracked files
    local untracked_files
    untracked_files=$(git ls-files --others --exclude-standard)
    
    if [[ -n "$untracked_files" ]]; then
        return 0  # Has untracked files
    else
        return 1  # No untracked files
    fi
}

# Get detailed working tree status
get_working_tree_status() {
    local status_info=""
    
    # Check for uncommitted changes
    if check_uncommitted_changes; then
        local modified_files
        modified_files=$(git diff --name-only)
        status_info+="Modified files: $(echo "$modified_files" | wc -l)\n"
        if [[ "${CONFIG[LOG_LEVEL]}" == "DEBUG" ]]; then
            status_info+="  Files: $(echo "$modified_files" | tr '\n' ' ')\n"
        fi
    fi
    
    # Check for staged files
    if check_staged_files; then
        local staged_files
        staged_files=$(git diff --cached --name-only)
        status_info+="Staged files: $(echo "$staged_files" | wc -l)\n"
        if [[ "${CONFIG[LOG_LEVEL]}" == "DEBUG" ]]; then
            status_info+="  Files: $(echo "$staged_files" | tr '\n' ' ')\n"
        fi
    fi
    
    # Check for untracked files
    if check_untracked_files; then
        local untracked_files
        untracked_files=$(git ls-files --others --exclude-standard)
        status_info+="Untracked files: $(echo "$untracked_files" | wc -l)\n"
        if [[ "${CONFIG[LOG_LEVEL]}" == "DEBUG" ]]; then
            status_info+="  Files: $(echo "$untracked_files" | tr '\n' ' ')\n"
        fi
    fi
    
    echo -e "$status_info"
}

# Validate that working tree is clean
validate_clean_working_tree() {
    log_debug "Validating clean working tree..."
    
    local has_changes=false
    local status_report=""
    
    # Check all types of changes
    if check_uncommitted_changes; then
        has_changes=true
        status_report+="- Uncommitted changes detected\n"
    fi
    
    if check_staged_files; then
        has_changes=true
        status_report+="- Staged files detected\n"
    fi
    
    if check_untracked_files; then
        has_changes=true
        status_report+="- Untracked files detected\n"
    fi
    
    if [[ "$has_changes" == true ]]; then
        log_warn "Working tree is not clean:"
        echo -e "$status_report"
        echo -e "\nDetailed status:"
        get_working_tree_status
        return 1  # Working tree is not clean
    else
        log_info "Working tree is clean"
        return 0  # Working tree is clean
    fi
}

# Prompt user for action when working tree is dirty
handle_dirty_working_tree() {
    local operation="$1"
    
    echo -e "${YELLOW}Warning: Working tree has uncommitted changes${NC}"
    echo "The following operation requires a clean working tree: $operation"
    echo ""
    get_working_tree_status
    echo ""
    echo "Choose an action:"
    echo "1) Stash changes and continue"
    echo "2) Commit changes and continue"
    echo "3) Show detailed status"
    echo "4) Cancel operation"
    
    while true; do
        read -p "Enter your choice (1-4): " choice
        case $choice in
            1)
                log_info "Stashing changes..."
                if git stash push -m "Auto-stash before $operation"; then
                    log_info "Changes stashed successfully"
                    return 0
                else
                    log_error "Failed to stash changes"
                    return 1
                fi
                ;;
            2)
                echo "Please commit your changes manually and then retry the operation."
                return 1
                ;;
            3)
                echo -e "\n${WHITE}Detailed Git Status:${NC}"
                git status
                echo ""
                continue
                ;;
            4)
                log_info "Operation cancelled by user"
                return 1
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, or 4."
                continue
                ;;
        esac
    done
}

# Repository state validation functions

# Check if repository structure is valid
validate_repository_structure() {
    log_debug "Validating Git repository structure..."
    
    # Check if .git directory exists and is valid
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Invalid Git repository structure"
        return 1
    fi
    
    # Check repository integrity using git fsck
    log_debug "Running repository integrity check..."
    if ! git fsck --quiet 2>/dev/null; then
        log_warn "Repository integrity issues detected"
        echo "Running detailed integrity check..."
        git fsck 2>&1 | head -10
        echo "Consider running 'git fsck --full' for complete analysis"
        return 1
    fi
    
    log_debug "Repository structure is valid"
    return 0
}

# Check if we're in a detached HEAD state
check_detached_head() {
    log_debug "Checking for detached HEAD state..."
    
    local current_branch
    current_branch=$(git branch --show-current 2>/dev/null)
    
    if [[ -z "$current_branch" ]]; then
        return 0  # In detached HEAD state
    else
        return 1  # Not in detached HEAD state
    fi
}

# Handle detached HEAD state
handle_detached_head() {
    local current_commit
    current_commit=$(git rev-parse --short HEAD)
    
    echo -e "${YELLOW}Warning: You are in a detached HEAD state${NC}"
    echo "Current commit: $current_commit"
    echo ""
    echo "In detached HEAD state, you are not on any branch."
    echo "Any commits you make will be lost when you switch branches."
    echo ""
    echo "Choose an action:"
    echo "1) Create a new branch from current commit"
    echo "2) Switch to an existing branch (will lose any uncommitted changes)"
    echo "3) Show available branches"
    echo "4) Cancel operation"
    
    while true; do
        read -p "Enter your choice (1-4): " choice
        case $choice in
            1)
                read -p "Enter new branch name: " branch_name
                if [[ -n "$branch_name" ]]; then
                    if git checkout -b "$branch_name"; then
                        log_info "Created and switched to new branch: $branch_name"
                        return 0
                    else
                        log_error "Failed to create branch: $branch_name"
                        return 1
                    fi
                else
                    echo "Branch name cannot be empty"
                    continue
                fi
                ;;
            2)
                echo "Available branches:"
                git branch -a
                read -p "Enter branch name to switch to: " branch_name
                if [[ -n "$branch_name" ]]; then
                    if git checkout "$branch_name"; then
                        log_info "Switched to branch: $branch_name"
                        return 0
                    else
                        log_error "Failed to switch to branch: $branch_name"
                        return 1
                    fi
                else
                    echo "Branch name cannot be empty"
                    continue
                fi
                ;;
            3)
                echo -e "\n${WHITE}Available branches:${NC}"
                git branch -a
                echo ""
                continue
                ;;
            4)
                log_info "Operation cancelled by user"
                return 1
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, or 4."
                continue
                ;;
        esac
    done
}

# Validate remote repository connectivity
validate_remote_connectivity() {
    log_debug "Validating remote repository connectivity..."
    
    # Get list of remotes
    local remotes
    remotes=$(git remote 2>/dev/null)
    
    if [[ -z "$remotes" ]]; then
        log_warn "No remote repositories configured"
        return 1
    fi
    
    # Test connectivity to each remote
    local connectivity_issues=false
    for remote in $remotes; do
        log_debug "Testing connectivity to remote: $remote"
        
        # Get remote URL
        local remote_url
        remote_url=$(git remote get-url "$remote" 2>/dev/null)
        
        if [[ -z "$remote_url" ]]; then
            log_warn "No URL configured for remote: $remote"
            connectivity_issues=true
            continue
        fi
        
        # Test connectivity with a timeout
        if timeout 10 git ls-remote "$remote" > /dev/null 2>&1; then
            log_debug "Remote '$remote' is accessible"
        else
            log_warn "Cannot connect to remote '$remote' ($remote_url)"
            connectivity_issues=true
        fi
    done
    
    if [[ "$connectivity_issues" == true ]]; then
        return 1
    else
        log_debug "All remotes are accessible"
        return 0
    fi
}

# Get remote repository status
get_remote_status() {
    local remotes
    remotes=$(git remote 2>/dev/null)
    
    if [[ -z "$remotes" ]]; then
        echo "No remote repositories configured"
        return
    fi
    
    echo -e "${WHITE}Remote Repository Status:${NC}"
    echo "========================="
    
    for remote in $remotes; do
        local remote_url
        remote_url=$(git remote get-url "$remote" 2>/dev/null)
        
        echo -e "${CYAN}Remote:${NC} $remote"
        echo -e "${CYAN}URL:${NC} $remote_url"
        
        # Test connectivity
        if timeout 5 git ls-remote "$remote" > /dev/null 2>&1; then
            echo -e "${CYAN}Status:${NC} ${GREEN}Connected${NC}"
        else
            echo -e "${CYAN}Status:${NC} ${RED}Connection failed${NC}"
        fi
        echo ""
    done
}

# Comprehensive repository state validation
validate_repository_state() {
    log_info "Performing comprehensive repository state validation..."
    
    local validation_passed=true
    
    # Check repository structure
    if ! validate_repository_structure; then
        validation_passed=false
    fi
    
    # Check for detached HEAD
    if check_detached_head; then
        log_warn "Repository is in detached HEAD state"
        if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
            if ! handle_detached_head; then
                validation_passed=false
            fi
        else
            validation_passed=false
        fi
    fi
    
    # Check remote connectivity (non-blocking)
    if ! validate_remote_connectivity; then
        log_warn "Remote connectivity issues detected (non-blocking)"
        # Don't fail validation for remote issues
    fi
    
    if [[ "$validation_passed" == true ]]; then
        log_info "Repository state validation passed"
        return 0
    else
        log_error "Repository state validation failed"
        return 1
    fi
}

# Backup and restore system

# Generate unique backup ID
generate_backup_id() {
    local operation="$1"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local current_branch
    current_branch=$(get_current_branch 2>/dev/null || echo "unknown")
    
    echo "${operation}_${current_branch}_${timestamp}"
}

# Create backup before destructive operations
create_safety_backup() {
    local operation="$1"
    local backup_id
    backup_id=$(generate_backup_id "$operation")
    local backup_path="$BACKUP_DIR/$backup_id"
    
    log_info "Creating safety backup for operation: $operation"
    log_debug "Backup ID: $backup_id"
    
    # Create backup directory
    mkdir -p "$backup_path"
    
    # Create backup metadata
    cat > "$backup_path/metadata.txt" << EOF
Backup ID: $backup_id
Operation: $operation
Timestamp: $(date '+%Y-%m-%d %H:%M:%S')
Current Branch: $(get_current_branch 2>/dev/null || echo "unknown")
Repository: $(git remote get-url origin 2>/dev/null || echo "local")
Git Commit: $(git rev-parse HEAD 2>/dev/null || echo "unknown")
Working Directory: $(pwd)
EOF
    
    # Backup current branch state
    local current_branch
    current_branch=$(get_current_branch 2>/dev/null)
    if [[ -n "$current_branch" ]]; then
        echo "$current_branch" > "$backup_path/current_branch.txt"
    fi
    
    # Backup stash if it exists
    if git stash list | grep -q .; then
        log_debug "Backing up stash..."
        git stash list > "$backup_path/stash_list.txt"
    fi
    
    # Backup uncommitted changes if any
    if check_uncommitted_changes || check_staged_files; then
        log_debug "Backing up uncommitted changes..."
        
        # Create a temporary stash for backup purposes
        if git stash push -m "Backup stash for $backup_id" --include-untracked; then
            echo "Backup stash created" > "$backup_path/uncommitted_backup.txt"
            # Restore the stash immediately (it's still in stash list)
            git stash pop
        fi
    fi
    
    # Backup branch list
    git branch -a > "$backup_path/branches.txt" 2>/dev/null
    
    # Backup remote information
    git remote -v > "$backup_path/remotes.txt" 2>/dev/null
    
    # Log the backup creation
    log_operation "CREATE_BACKUP" "$current_branch" "SUCCESS" "Backup ID: $backup_id"
    
    echo "$backup_id"
}

# List available backups
list_backups() {
    echo -e "${WHITE}Available Backups:${NC}"
    echo "=================="
    
    if [[ ! -d "$BACKUP_DIR" ]] || [[ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
        echo "No backups found"
        return
    fi
    
    local backup_count=0
    for backup_path in "$BACKUP_DIR"/*; do
        if [[ -d "$backup_path" ]] && [[ -f "$backup_path/metadata.txt" ]]; then
            backup_count=$((backup_count + 1))
            local backup_id
            backup_id=$(basename "$backup_path")
            
            echo -e "${CYAN}$backup_count.${NC} $backup_id"
            
            # Show metadata
            if [[ -f "$backup_path/metadata.txt" ]]; then
                grep -E "^(Operation|Timestamp|Current Branch):" "$backup_path/metadata.txt" | sed 's/^/   /'
            fi
            echo ""
        fi
    done
    
    if [[ $backup_count -eq 0 ]]; then
        echo "No valid backups found"
    fi
}

# Restore from backup
restore_from_backup() {
    local backup_id="$1"
    local backup_path="$BACKUP_DIR/$backup_id"
    
    if [[ ! -d "$backup_path" ]]; then
        log_error "Backup not found: $backup_id"
        return 1
    fi
    
    if [[ ! -f "$backup_path/metadata.txt" ]]; then
        log_error "Invalid backup: missing metadata"
        return 1
    fi
    
    log_info "Restoring from backup: $backup_id"
    
    # Show backup information
    echo -e "${WHITE}Backup Information:${NC}"
    cat "$backup_path/metadata.txt"
    echo ""
    
    # Confirm restoration
    if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
        read -p "Are you sure you want to restore from this backup? (y/N): " confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            log_info "Restore cancelled by user"
            return 1
        fi
    fi
    
    # Restore current branch if available
    if [[ -f "$backup_path/current_branch.txt" ]]; then
        local backup_branch
        backup_branch=$(cat "$backup_path/current_branch.txt")
        
        if [[ -n "$backup_branch" ]] && branch_exists "$backup_branch"; then
            log_info "Switching to backed up branch: $backup_branch"
            if ! git checkout "$backup_branch"; then
                log_warn "Failed to switch to backed up branch"
            fi
        fi
    fi
    
    # Restore uncommitted changes if they were backed up
    if [[ -f "$backup_path/uncommitted_backup.txt" ]]; then
        log_info "Checking for backed up uncommitted changes..."
        
        # Look for the backup stash
        local backup_stash
        backup_stash=$(git stash list | grep "Backup stash for $backup_id" | head -1)
        
        if [[ -n "$backup_stash" ]]; then
            local stash_index
            stash_index=$(echo "$backup_stash" | cut -d: -f1)
            
            echo "Found backed up changes in stash: $stash_index"
            read -p "Restore uncommitted changes? (y/N): " restore_changes
            
            if [[ "$restore_changes" == "y" || "$restore_changes" == "Y" ]]; then
                if git stash pop "$stash_index"; then
                    log_info "Uncommitted changes restored"
                else
                    log_warn "Failed to restore uncommitted changes"
                fi
            fi
        fi
    fi
    
    log_operation "RESTORE_BACKUP" "$(get_current_branch 2>/dev/null)" "SUCCESS" "Backup ID: $backup_id"
    log_info "Backup restoration completed"
    
    return 0
}

# Clean up old backups based on retention policy
cleanup_old_backups() {
    local retention_days="${CONFIG[BACKUP_RETENTION_DAYS]}"
    
    log_info "Cleaning up backups older than $retention_days days..."
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_debug "No backup directory found"
        return 0
    fi
    
    local deleted_count=0
    
    # Find and delete old backups
    while IFS= read -r -d '' backup_path; do
        if [[ -d "$backup_path" ]]; then
            # Check if backup is older than retention period
            if [[ $(find "$backup_path" -maxdepth 0 -mtime +$retention_days) ]]; then
                local backup_id
                backup_id=$(basename "$backup_path")
                
                log_debug "Deleting old backup: $backup_id"
                
                if rm -rf "$backup_path"; then
                    deleted_count=$((deleted_count + 1))
                    log_debug "Deleted backup: $backup_id"
                else
                    log_warn "Failed to delete backup: $backup_id"
                fi
            fi
        fi
    done < <(find "$BACKUP_DIR" -maxdepth 1 -type d -print0 2>/dev/null)
    
    if [[ $deleted_count -gt 0 ]]; then
        log_info "Cleaned up $deleted_count old backups"
    else
        log_debug "No old backups to clean up"
    fi
    
    return 0
}

# Interactive backup management
manage_backups() {
    while true; do
        echo -e "${WHITE}Backup Management${NC}"
        echo "================="
        echo "1) List backups"
        echo "2) Restore from backup"
        echo "3) Clean up old backups"
        echo "4) Back to main menu"
        echo ""
        
        read -p "Enter your choice (1-4): " choice
        
        case $choice in
            1)
                echo ""
                list_backups
                echo ""
                ;;
            2)
                echo ""
                list_backups
                echo ""
                read -p "Enter backup ID to restore: " backup_id
                if [[ -n "$backup_id" ]]; then
                    restore_from_backup "$backup_id"
                else
                    echo "Backup ID cannot be empty"
                fi
                echo ""
                ;;
            3)
                cleanup_old_backups
                echo ""
                ;;
            4)
                return 0
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, or 4."
                echo ""
                ;;
        esac
    done
}

# =============================================================================
# REMOTE SYNCHRONIZATION MODULE
# =============================================================================

# Remote fetch and sync functions

# Fetch latest changes from all remotes
fetch_remote_changes() {
    local remote="${1:-}"
    
    if [[ -n "$remote" ]]; then
        log_info "Fetching changes from remote: $remote"
        
        if ! git fetch "$remote" 2>/dev/null; then
            log_error "Failed to fetch from remote: $remote"
            return 1
        fi
        
        log_debug "Successfully fetched from remote: $remote"
    else
        log_info "Fetching changes from all remotes..."
        
        # Get list of remotes
        local remotes
        remotes=$(git remote 2>/dev/null)
        
        if [[ -z "$remotes" ]]; then
            log_warn "No remote repositories configured"
            return 1
        fi
        
        local fetch_failed=false
        for remote in $remotes; do
            log_debug "Fetching from remote: $remote"
            
            if git fetch "$remote" 2>/dev/null; then
                log_debug "Successfully fetched from remote: $remote"
            else
                log_warn "Failed to fetch from remote: $remote"
                fetch_failed=true
            fi
        done
        
        if [[ "$fetch_failed" == true ]]; then
            log_warn "Some remote fetch operations failed"
            return 1
        fi
    fi
    
    log_info "Remote fetch completed successfully"
    return 0
}

# Check if branch has upstream configured
has_upstream() {
    local branch_name="${1:-$(get_current_branch)}"
    
    if [[ -z "$branch_name" ]]; then
        return 1
    fi
    
    # Check if upstream is configured
    if git rev-parse --abbrev-ref "$branch_name@{upstream}" >/dev/null 2>&1; then
        return 0  # Has upstream
    else
        return 1  # No upstream
    fi
}

# Get upstream branch name
get_upstream_branch() {
    local branch_name="${1:-$(get_current_branch)}"
    
    if [[ -z "$branch_name" ]]; then
        return 1
    fi
    
    git rev-parse --abbrev-ref "$branch_name@{upstream}" 2>/dev/null || return 1
}

# Check branch status relative to upstream
get_branch_sync_status() {
    local branch_name="${1:-$(get_current_branch)}"
    
    if [[ -z "$branch_name" ]]; then
        echo "unknown"
        return 1
    fi
    
    if ! has_upstream "$branch_name"; then
        echo "no-upstream"
        return 0
    fi
    
    local upstream
    upstream=$(get_upstream_branch "$branch_name")
    
    if [[ -z "$upstream" ]]; then
        echo "no-upstream"
        return 0
    fi
    
    # Get commit counts
    local ahead behind
    ahead=$(git rev-list --count "$upstream..$branch_name" 2>/dev/null || echo "0")
    behind=$(git rev-list --count "$branch_name..$upstream" 2>/dev/null || echo "0")
    
    if [[ "$ahead" -eq 0 && "$behind" -eq 0 ]]; then
        echo "up-to-date"
    elif [[ "$ahead" -gt 0 && "$behind" -eq 0 ]]; then
        echo "ahead"
    elif [[ "$ahead" -eq 0 && "$behind" -gt 0 ]]; then
        echo "behind"
    else
        echo "diverged"
    fi
}

# Get detailed branch sync information
get_branch_sync_details() {
    local branch_name="${1:-$(get_current_branch)}"
    
    if [[ -z "$branch_name" ]]; then
        echo "Error: Unable to determine branch name"
        return 1
    fi
    
    echo -e "${WHITE}Branch Sync Status: $branch_name${NC}"
    echo "================================="
    
    if ! has_upstream "$branch_name"; then
        echo -e "${YELLOW}No upstream branch configured${NC}"
        return 0
    fi
    
    local upstream
    upstream=$(get_upstream_branch "$branch_name")
    echo -e "${CYAN}Upstream:${NC} $upstream"
    
    local status
    status=$(get_branch_sync_status "$branch_name")
    
    case "$status" in
        "up-to-date")
            echo -e "${CYAN}Status:${NC} ${GREEN}Up to date${NC}"
            ;;
        "ahead")
            local ahead_count
            ahead_count=$(git rev-list --count "$upstream..$branch_name" 2>/dev/null || echo "0")
            echo -e "${CYAN}Status:${NC} ${BLUE}Ahead by $ahead_count commits${NC}"
            ;;
        "behind")
            local behind_count
            behind_count=$(git rev-list --count "$branch_name..$upstream" 2>/dev/null || echo "0")
            echo -e "${CYAN}Status:${NC} ${YELLOW}Behind by $behind_count commits${NC}"
            ;;
        "diverged")
            local ahead_count behind_count
            ahead_count=$(git rev-list --count "$upstream..$branch_name" 2>/dev/null || echo "0")
            behind_count=$(git rev-list --count "$branch_name..$upstream" 2>/dev/null || echo "0")
            echo -e "${CYAN}Status:${NC} ${RED}Diverged${NC} (ahead by $ahead_count, behind by $behind_count)"
            ;;
        *)
            echo -e "${CYAN}Status:${NC} ${RED}Unknown${NC}"
            ;;
    esac
    
    # Show last sync time if available
    local git_dir
    git_dir=$(git rev-parse --git-dir 2>/dev/null || echo ".git")
    local last_fetch
    last_fetch=$(stat -c %Y "$git_dir/FETCH_HEAD" 2>/dev/null || echo "0")
    if [[ "$last_fetch" -gt 0 ]]; then
        local last_fetch_date
        last_fetch_date=$(date -d "@$last_fetch" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "unknown")
        echo -e "${CYAN}Last fetch:${NC} $last_fetch_date"
    fi
}

# Sync branch with upstream
sync_with_upstream() {
    local branch_name="${1:-$(get_current_branch)}"
    local strategy="${2:-auto}"  # auto, pull, rebase
    
    if [[ -z "$branch_name" ]]; then
        log_error "Unable to determine branch name"
        return 1
    fi
    
    log_info "Syncing branch '$branch_name' with upstream..."
    
    # Check if upstream exists
    if ! has_upstream "$branch_name"; then
        log_warn "No upstream branch configured for '$branch_name'"
        return 1
    fi
    
    # Fetch latest changes first
    if [[ "${CONFIG[AUTO_FETCH]}" == "true" ]]; then
        if ! fetch_remote_changes; then
            log_warn "Failed to fetch remote changes, continuing with sync..."
        fi
    fi
    
    # Check current sync status
    local sync_status
    sync_status=$(get_branch_sync_status "$branch_name")
    
    case "$sync_status" in
        "up-to-date")
            log_info "Branch '$branch_name' is already up to date"
            return 0
            ;;
        "ahead")
            log_info "Branch '$branch_name' is ahead of upstream - no sync needed"
            return 0
            ;;
        "behind")
            log_info "Branch '$branch_name' is behind upstream - syncing..."
            ;;
        "diverged")
            log_warn "Branch '$branch_name' has diverged from upstream"
            ;;
        *)
            log_error "Unable to determine sync status for branch '$branch_name'"
            return 1
            ;;
    esac
    
    # Ensure working tree is clean before sync
    if ! validate_clean_working_tree; then
        if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
            if ! handle_dirty_working_tree "sync with upstream"; then
                return 1
            fi
        else
            log_error "Working tree must be clean for sync operation"
            return 1
        fi
    fi
    
    # Perform sync based on strategy
    case "$strategy" in
        "pull"|"auto")
            log_info "Pulling changes from upstream..."
            if git pull --ff-only; then
                log_info "Successfully synced with upstream using fast-forward"
                log_operation "SYNC_UPSTREAM" "$branch_name" "SUCCESS" "Fast-forward pull"
                return 0
            else
                log_warn "Fast-forward pull failed, trying merge..."
                if git pull --no-ff; then
                    log_info "Successfully synced with upstream using merge"
                    log_operation "SYNC_UPSTREAM" "$branch_name" "SUCCESS" "Merge pull"
                    return 0
                else
                    log_error "Failed to sync with upstream"
                    log_operation "SYNC_UPSTREAM" "$branch_name" "FAILED" "Pull failed"
                    return 1
                fi
            fi
            ;;
        "rebase")
            log_info "Rebasing onto upstream..."
            local upstream
            upstream=$(get_upstream_branch "$branch_name")
            
            if git rebase "$upstream"; then
                log_info "Successfully rebased onto upstream"
                log_operation "SYNC_UPSTREAM" "$branch_name" "SUCCESS" "Rebase"
                return 0
            else
                log_error "Rebase failed - manual intervention required"
                log_operation "SYNC_UPSTREAM" "$branch_name" "FAILED" "Rebase failed"
                return 1
            fi
            ;;
        *)
            log_error "Unknown sync strategy: $strategy"
            return 1
            ;;
    esac
}

# Handle sync conflicts and provide user options
handle_sync_conflicts() {
    local branch_name="${1:-$(get_current_branch)}"
    
    echo -e "${YELLOW}Sync conflicts detected for branch: $branch_name${NC}"
    
    # Show current status
    get_branch_sync_details "$branch_name"
    echo ""
    
    echo "Choose a sync strategy:"
    echo "1) Pull with merge (creates merge commit)"
    echo "2) Rebase onto upstream (linear history)"
    echo "3) Show detailed diff"
    echo "4) Cancel sync operation"
    
    while true; do
        read -p "Enter your choice (1-4): " choice
        case $choice in
            1)
                if sync_with_upstream "$branch_name" "pull"; then
                    return 0
                else
                    echo "Pull with merge failed"
                    return 1
                fi
                ;;
            2)
                if sync_with_upstream "$branch_name" "rebase"; then
                    return 0
                else
                    echo "Rebase failed - you may need to resolve conflicts manually"
                    return 1
                fi
                ;;
            3)
                local upstream
                upstream=$(get_upstream_branch "$branch_name")
                if [[ -n "$upstream" ]]; then
                    echo -e "\n${WHITE}Diff between $branch_name and $upstream:${NC}"
                    git diff "$branch_name..$upstream" --stat
                    echo ""
                    read -p "Show detailed diff? (y/N): " show_detail
                    if [[ "$show_detail" == "y" || "$show_detail" == "Y" ]]; then
                        git diff "$branch_name..$upstream"
                    fi
                fi
                echo ""
                continue
                ;;
            4)
                log_info "Sync operation cancelled by user"
                return 1
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, or 4."
                continue
                ;;
        esac
    done
}

# Upstream tracking management functions

# Set up upstream tracking for a branch
setup_upstream_tracking() {
    local branch_name="${1:-$(get_current_branch)}"
    local remote="${2:-origin}"
    local remote_branch="${3:-$branch_name}"
    
    if [[ -z "$branch_name" ]]; then
        log_error "Unable to determine branch name"
        return 1
    fi
    
    log_info "Setting up upstream tracking for branch '$branch_name'"
    log_debug "Remote: $remote, Remote branch: $remote_branch"
    
    # Check if remote exists
    if ! git remote | grep -q "^$remote$"; then
        log_error "Remote '$remote' does not exist"
        return 1
    fi
    
    # Check if remote branch exists
    if ! git ls-remote --heads "$remote" | grep -q "refs/heads/$remote_branch$"; then
        log_warn "Remote branch '$remote/$remote_branch' does not exist"
        
        if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
            read -p "Create remote branch '$remote/$remote_branch'? (y/N): " create_remote
            if [[ "$create_remote" != "y" && "$create_remote" != "Y" ]]; then
                log_info "Upstream tracking setup cancelled"
                return 1
            fi
            
            # Push current branch to create remote branch
            log_info "Creating remote branch '$remote/$remote_branch'..."
            if git push -u "$remote" "$branch_name:$remote_branch"; then
                log_info "Remote branch created and upstream tracking set up"
                log_operation "SETUP_UPSTREAM" "$branch_name" "SUCCESS" "Created remote branch $remote/$remote_branch"
                return 0
            else
                log_error "Failed to create remote branch"
                return 1
            fi
        else
            return 1
        fi
    fi
    
    # Set up upstream tracking
    if git branch --set-upstream-to="$remote/$remote_branch" "$branch_name"; then
        log_info "Upstream tracking set up: $branch_name -> $remote/$remote_branch"
        log_operation "SETUP_UPSTREAM" "$branch_name" "SUCCESS" "Tracking $remote/$remote_branch"
        return 0
    else
        log_error "Failed to set up upstream tracking"
        log_operation "SETUP_UPSTREAM" "$branch_name" "FAILED" "Could not track $remote/$remote_branch"
        return 1
    fi
}

# Remove upstream tracking from a branch
remove_upstream_tracking() {
    local branch_name="${1:-$(get_current_branch)}"
    
    if [[ -z "$branch_name" ]]; then
        log_error "Unable to determine branch name"
        return 1
    fi
    
    if ! has_upstream "$branch_name"; then
        log_info "Branch '$branch_name' has no upstream tracking configured"
        return 0
    fi
    
    local upstream
    upstream=$(get_upstream_branch "$branch_name")
    
    log_info "Removing upstream tracking from branch '$branch_name'"
    log_debug "Current upstream: $upstream"
    
    if git branch --unset-upstream "$branch_name"; then
        log_info "Upstream tracking removed from branch '$branch_name'"
        log_operation "REMOVE_UPSTREAM" "$branch_name" "SUCCESS" "Removed tracking for $upstream"
        return 0
    else
        log_error "Failed to remove upstream tracking"
        log_operation "REMOVE_UPSTREAM" "$branch_name" "FAILED" "Could not remove tracking"
        return 1
    fi
}

# Auto-configure upstream for new branches
auto_configure_upstream() {
    local branch_name="${1:-$(get_current_branch)}"
    local base_branch="${2:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    
    if [[ -z "$branch_name" ]]; then
        log_error "Unable to determine branch name"
        return 1
    fi
    
    # Skip if upstream is already configured
    if has_upstream "$branch_name"; then
        log_debug "Branch '$branch_name' already has upstream tracking configured"
        return 0
    fi
    
    log_info "Auto-configuring upstream for new branch '$branch_name'"
    
    # Get the default remote (usually 'origin')
    local default_remote
    default_remote=$(git remote | head -1)
    
    if [[ -z "$default_remote" ]]; then
        log_warn "No remote repositories configured - skipping upstream setup"
        return 1
    fi
    
    # Check if this is a feature branch that should track a remote branch
    local workflow="${CONFIG[DEFAULT_WORKFLOW]}"
    local branch_prefixes="${WORKFLOW_PATTERNS[$workflow]}"
    
    # Check if branch follows naming convention
    local should_track=false
    IFS=',' read -ra prefixes <<< "$branch_prefixes"
    for prefix in "${prefixes[@]}"; do
        if [[ "$branch_name" == $prefix* ]]; then
            should_track=true
            break
        fi
    done
    
    if [[ "$should_track" == true ]]; then
        log_info "Branch follows workflow naming convention - setting up upstream tracking"
        
        # Try to set up upstream tracking
        if setup_upstream_tracking "$branch_name" "$default_remote" "$branch_name"; then
            return 0
        else
            log_debug "Could not auto-configure upstream - branch may not exist on remote"
            return 1
        fi
    else
        log_debug "Branch does not follow workflow naming convention - skipping upstream setup"
        return 0
    fi
}

# Show comprehensive branch status with upstream information
show_branch_status() {
    local show_all="${1:-false}"
    
    echo -e "${WHITE}Branch Status Report${NC}"
    echo "===================="
    echo ""
    
    # Current branch information
    local current_branch
    current_branch=$(get_current_branch 2>/dev/null)
    
    if [[ -n "$current_branch" ]]; then
        echo -e "${WHITE}Current Branch:${NC} ${GREEN}$current_branch${NC}"
        get_branch_sync_details "$current_branch"
        echo ""
    fi
    
    # Show all branches if requested
    if [[ "$show_all" == "true" ]]; then
        echo -e "${WHITE}All Branches:${NC}"
        echo "============="
        
        # Get all local branches
        local branches
        branches=$(git branch --format='%(refname:short)' 2>/dev/null)
        
        for branch in $branches; do
            if [[ "$branch" == "$current_branch" ]]; then
                continue  # Skip current branch (already shown above)
            fi
            
            echo -e "\n${CYAN}Branch:${NC} $branch"
            
            if has_upstream "$branch"; then
                local upstream status
                upstream=$(get_upstream_branch "$branch")
                status=$(get_branch_sync_status "$branch")
                
                echo -e "${CYAN}Upstream:${NC} $upstream"
                
                case "$status" in
                    "up-to-date")
                        echo -e "${CYAN}Status:${NC} ${GREEN}Up to date${NC}"
                        ;;
                    "ahead")
                        local ahead_count
                        ahead_count=$(git rev-list --count "$upstream..$branch" 2>/dev/null || echo "0")
                        echo -e "${CYAN}Status:${NC} ${BLUE}Ahead by $ahead_count commits${NC}"
                        ;;
                    "behind")
                        local behind_count
                        behind_count=$(git rev-list --count "$branch..$upstream" 2>/dev/null || echo "0")
                        echo -e "${CYAN}Status:${NC} ${YELLOW}Behind by $behind_count commits${NC}"
                        ;;
                    "diverged")
                        local ahead_count behind_count
                        ahead_count=$(git rev-list --count "$upstream..$branch" 2>/dev/null || echo "0")
                        behind_count=$(git rev-list --count "$branch..$upstream" 2>/dev/null || echo "0")
                        echo -e "${CYAN}Status:${NC} ${RED}Diverged${NC} (ahead by $ahead_count, behind by $behind_count)"
                        ;;
                esac
            else
                echo -e "${CYAN}Upstream:${NC} ${YELLOW}Not configured${NC}"
            fi
        done
    fi
    
    # Remote information
    echo -e "\n${WHITE}Remote Repositories:${NC}"
    echo "===================="
    get_remote_status
}

# Interactive upstream management
manage_upstream_tracking() {
    local current_branch
    current_branch=$(get_current_branch 2>/dev/null)
    
    while true; do
        echo -e "${WHITE}Upstream Tracking Management${NC}"
        echo "============================"
        
        if [[ -n "$current_branch" ]]; then
            echo -e "Current branch: ${GREEN}$current_branch${NC}"
            
            if has_upstream "$current_branch"; then
                local upstream
                upstream=$(get_upstream_branch "$current_branch")
                echo -e "Current upstream: ${CYAN}$upstream${NC}"
            else
                echo -e "Current upstream: ${YELLOW}Not configured${NC}"
            fi
        fi
        
        echo ""
        echo "1) Show branch status"
        echo "2) Set up upstream tracking"
        echo "3) Remove upstream tracking"
        echo "4) Sync with upstream"
        echo "5) Show all branches with upstream info"
        echo "6) Back to main menu"
        echo ""
        
        read -p "Enter your choice (1-6): " choice
        
        case $choice in
            1)
                echo ""
                if [[ -n "$current_branch" ]]; then
                    get_branch_sync_details "$current_branch"
                else
                    echo "Unable to determine current branch"
                fi
                echo ""
                ;;
            2)
                echo ""
                read -p "Enter branch name (or press Enter for current branch): " branch_name
                if [[ -z "$branch_name" ]]; then
                    branch_name="$current_branch"
                fi
                
                if [[ -n "$branch_name" ]]; then
                    read -p "Enter remote name (default: origin): " remote_name
                    remote_name="${remote_name:-origin}"
                    
                    read -p "Enter remote branch name (default: $branch_name): " remote_branch
                    remote_branch="${remote_branch:-$branch_name}"
                    
                    setup_upstream_tracking "$branch_name" "$remote_name" "$remote_branch"
                else
                    echo "No branch specified"
                fi
                echo ""
                ;;
            3)
                echo ""
                read -p "Enter branch name (or press Enter for current branch): " branch_name
                if [[ -z "$branch_name" ]]; then
                    branch_name="$current_branch"
                fi
                
                if [[ -n "$branch_name" ]]; then
                    remove_upstream_tracking "$branch_name"
                else
                    echo "No branch specified"
                fi
                echo ""
                ;;
            4)
                echo ""
                if [[ -n "$current_branch" ]]; then
                    if has_upstream "$current_branch"; then
                        local status
                        status=$(get_branch_sync_status "$current_branch")
                        
                        if [[ "$status" == "diverged" ]]; then
                            handle_sync_conflicts "$current_branch"
                        else
                            sync_with_upstream "$current_branch"
                        fi
                    else
                        echo "Current branch has no upstream tracking configured"
                    fi
                else
                    echo "Unable to determine current branch"
                fi
                echo ""
                ;;
            5)
                echo ""
                show_branch_status "true"
                echo ""
                ;;
            6)
                return 0
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, 4, 5, or 6."
                echo ""
                ;;
        esac
    done
}

# =============================================================================
# BRANCH CREATION AND SWITCHING OPERATIONS
# =============================================================================

# Branch creation functions

# Validate branch name according to workflow conventions
validate_branch_name() {
    local branch_name="$1"
    local workflow="${CONFIG[DEFAULT_WORKFLOW]}"
    
    if [[ -z "$branch_name" ]]; then
        log_error "Branch name cannot be empty"
        return 1
    fi
    
    # Check for invalid characters
    if [[ ! "$branch_name" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
        log_error "Branch name contains invalid characters. Use only letters, numbers, hyphens, underscores, and forward slashes."
        return 1
    fi
    
    # Check for Git-reserved names
    local reserved_names=("HEAD" "master" "main" "origin" "upstream")
    for reserved in "${reserved_names[@]}"; do
        if [[ "$branch_name" == "$reserved" ]]; then
            log_error "Branch name '$branch_name' is reserved"
            return 1
        fi
    done
    
    # Validate against workflow naming conventions
    local branch_prefixes="${WORKFLOW_PATTERNS[$workflow]}"
    local follows_convention=false
    
    IFS=',' read -ra prefixes <<< "$branch_prefixes"
    for prefix in "${prefixes[@]}"; do
        if [[ "$branch_name" == $prefix* ]]; then
            follows_convention=true
            break
        fi
    done
    
    if [[ "$follows_convention" == false ]]; then
        log_warn "Branch name '$branch_name' does not follow $workflow workflow conventions"
        echo -e "${YELLOW}Expected prefixes for $workflow:${NC} $branch_prefixes"
        
        if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
            read -p "Continue with non-standard branch name? (y/N): " confirm
            if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
                log_info "Branch creation cancelled"
                return 1
            fi
        fi
    fi
    
    log_debug "Branch name '$branch_name' validation passed"
    return 0
}

# Handle duplicate branch names
handle_duplicate_branch() {
    local branch_name="$1"
    
    echo -e "${YELLOW}Branch '$branch_name' already exists${NC}"
    echo ""
    echo "Choose an action:"
    echo "1) Switch to existing branch"
    echo "2) Create variant with suffix (e.g., ${branch_name}-v2)"
    echo "3) Delete existing branch and create new one"
    echo "4) Show existing branch info"
    echo "5) Cancel operation"
    
    while true; do
        read -p "Enter your choice (1-5): " choice
        case $choice in
            1)
                log_info "Switching to existing branch: $branch_name"
                if switch_to_branch "$branch_name"; then
                    return 0
                else
                    return 1
                fi
                ;;
            2)
                local counter=2
                local variant_name="${branch_name}-v${counter}"
                
                while branch_exists "$variant_name"; do
                    counter=$((counter + 1))
                    variant_name="${branch_name}-v${counter}"
                done
                
                echo "Suggested variant name: $variant_name"
                read -p "Use this name or enter custom variant: " custom_name
                
                if [[ -n "$custom_name" ]]; then
                    variant_name="$custom_name"
                fi
                
                if branch_exists "$variant_name"; then
                    echo "Branch '$variant_name' also exists. Please try again."
                    continue
                fi
                
                log_info "Creating variant branch: $variant_name"
                echo "$variant_name"  # Return the new name
                return 0
                ;;
            3)
                echo -e "${RED}Warning: This will permanently delete the existing branch${NC}"
                read -p "Are you sure you want to delete '$branch_name'? (y/N): " confirm
                
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    if git branch -D "$branch_name"; then
                        log_info "Deleted existing branch: $branch_name"
                        return 0
                    else
                        log_error "Failed to delete existing branch"
                        return 1
                    fi
                else
                    echo "Branch deletion cancelled"
                    continue
                fi
                ;;
            4)
                echo -e "\n${WHITE}Branch Information: $branch_name${NC}"
                echo "================================="
                
                # Show branch details
                local last_commit
                last_commit=$(git log -1 --format="%h %s" "$branch_name" 2>/dev/null || echo "No commits")
                echo -e "${CYAN}Last commit:${NC} $last_commit"
                
                local commit_date
                commit_date=$(git log -1 --format="%ci" "$branch_name" 2>/dev/null || echo "Unknown")
                echo -e "${CYAN}Last modified:${NC} $commit_date"
                
                if has_upstream "$branch_name"; then
                    local upstream
                    upstream=$(get_upstream_branch "$branch_name")
                    echo -e "${CYAN}Upstream:${NC} $upstream"
                    
                    local status
                    status=$(get_branch_sync_status "$branch_name")
                    echo -e "${CYAN}Sync status:${NC} $status"
                fi
                
                echo ""
                continue
                ;;
            5)
                log_info "Branch creation cancelled by user"
                return 1
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, 4, or 5."
                continue
                ;;
        esac
    done
}

# Create a new branch safely
create_branch() {
    local branch_name="$1"
    local base_branch="${2:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    local skip_sync="${3:-false}"
    
    if [[ -z "$branch_name" ]]; then
        log_error "Branch name is required"
        return 1
    fi
    
    log_info "Creating new branch: $branch_name from $base_branch"
    
    # Validate branch name
    if ! validate_branch_name "$branch_name"; then
        return 1
    fi
    
    # Handle duplicate branch names
    if branch_exists "$branch_name"; then
        local result
        result=$(handle_duplicate_branch "$branch_name")
        local exit_code=$?
        
        if [[ $exit_code -eq 0 && "$result" != "$branch_name" ]]; then
            # User chose to create a variant
            branch_name="$result"
        elif [[ $exit_code -eq 0 ]]; then
            # User chose to switch to existing branch or delete and recreate
            return 0
        else
            # User cancelled or operation failed
            return 1
        fi
    fi
    
    # Ensure working tree is clean
    if ! validate_clean_working_tree; then
        if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
            if ! handle_dirty_working_tree "branch creation"; then
                return 1
            fi
        else
            log_error "Working tree must be clean for branch creation"
            return 1
        fi
    fi
    
    # Validate repository state
    if ! validate_repository_state; then
        log_error "Repository state validation failed"
        return 1
    fi
    
    # Check if base branch exists
    if ! branch_exists "$base_branch"; then
        log_error "Base branch '$base_branch' does not exist"
        return 1
    fi
    
    # Sync base branch with remote if enabled
    if [[ "$skip_sync" == "false" && "${CONFIG[AUTO_FETCH]}" == "true" ]]; then
        log_info "Syncing base branch '$base_branch' with remote..."
        
        # Switch to base branch temporarily if not already on it
        local current_branch
        current_branch=$(get_current_branch)
        local switched_to_base=false
        
        if [[ "$current_branch" != "$base_branch" ]]; then
            if git checkout "$base_branch" 2>/dev/null; then
                switched_to_base=true
                log_debug "Switched to base branch for sync"
            else
                log_warn "Could not switch to base branch for sync"
            fi
        fi
        
        # Sync with upstream if configured
        if has_upstream "$base_branch"; then
            if ! sync_with_upstream "$base_branch"; then
                log_warn "Failed to sync base branch with upstream"
            fi
        else
            log_debug "Base branch has no upstream - skipping sync"
        fi
        
        # Switch back to original branch if we switched
        if [[ "$switched_to_base" == true && "$current_branch" != "$base_branch" ]]; then
            if git checkout "$current_branch" 2>/dev/null; then
                log_debug "Switched back to original branch"
            fi
        fi
    fi
    
    # Create backup before branch creation
    local backup_id
    backup_id=$(create_safety_backup "CREATE_BRANCH")
    
    # Create the new branch
    log_info "Creating branch '$branch_name' from '$base_branch'..."
    
    if git checkout -b "$branch_name" "$base_branch"; then
        log_info "Successfully created and switched to branch: $branch_name"
        
        # Auto-configure upstream tracking if applicable
        auto_configure_upstream "$branch_name" "$base_branch"
        
        # Log the operation
        log_operation "CREATE_BRANCH" "$branch_name" "SUCCESS" "Created from $base_branch"
        
        return 0
    else
        log_error "Failed to create branch: $branch_name"
        log_operation "CREATE_BRANCH" "$branch_name" "FAILED" "Could not create from $base_branch"
        
        # Offer to restore from backup
        if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
            read -p "Restore from backup? (y/N): " restore
            if [[ "$restore" == "y" || "$restore" == "Y" ]]; then
                restore_from_backup "$backup_id"
            fi
        fi
        
        return 1
    fi
}

# Interactive branch creation
interactive_branch_creation() {
    echo -e "${WHITE}Interactive Branch Creation${NC}"
    echo "==========================="
    echo ""
    
    # Get branch name
    read -p "Enter new branch name: " branch_name
    if [[ -z "$branch_name" ]]; then
        echo "Branch name cannot be empty"
        return 1
    fi
    
    # Get base branch
    echo ""
    echo "Available branches:"
    git branch -a | grep -v "HEAD" | sed 's/^..//' | head -10
    echo ""
    
    read -p "Enter base branch (default: ${CONFIG[DEFAULT_BASE_BRANCH]}): " base_branch
    base_branch="${base_branch:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    
    # Confirm creation
    echo ""
    echo -e "${WHITE}Branch Creation Summary:${NC}"
    echo -e "${CYAN}New branch:${NC} $branch_name"
    echo -e "${CYAN}Base branch:${NC} $base_branch"
    echo -e "${CYAN}Auto-sync base:${NC} ${CONFIG[AUTO_FETCH]}"
    echo ""
    
    read -p "Create this branch? (Y/n): " confirm
    if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
        log_info "Branch creation cancelled"
        return 1
    fi
    
    # Create the branch
    create_branch "$branch_name" "$base_branch"
}

# Branch switching functions

# Validate target branch for switching
validate_target_branch() {
    local target_branch="$1"
    
    if [[ -z "$target_branch" ]]; then
        log_error "Target branch name is required"
        return 1
    fi
    
    # Check if target branch exists locally
    if branch_exists "$target_branch"; then
        log_debug "Target branch '$target_branch' exists locally"
        return 0
    fi
    
    # Check if target branch exists on remote
    local remotes
    remotes=$(git remote 2>/dev/null)
    
    for remote in $remotes; do
        if git ls-remote --heads "$remote" | grep -q "refs/heads/$target_branch$"; then
            log_info "Target branch '$target_branch' exists on remote '$remote'"
            
            if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
                read -p "Create local branch '$target_branch' tracking '$remote/$target_branch'? (Y/n): " create_local
                if [[ "$create_local" != "n" && "$create_local" != "N" ]]; then
                    if git checkout -b "$target_branch" "$remote/$target_branch"; then
                        log_info "Created local branch '$target_branch' tracking '$remote/$target_branch'"
                        return 0
                    else
                        log_error "Failed to create local branch from remote"
                        return 1
                    fi
                fi
            fi
            return 1
        fi
    done
    
    log_error "Target branch '$target_branch' does not exist locally or on any remote"
    return 1
}

# Manage stash during branch switching
manage_stash_for_switch() {
    local operation="$1"  # "create" or "restore"
    local stash_message="$2"
    
    case "$operation" in
        "create")
            log_info "Stashing uncommitted changes..."
            if git stash push -m "$stash_message" --include-untracked; then
                log_info "Changes stashed successfully"
                echo "stash_created"
                return 0
            else
                log_error "Failed to stash changes"
                return 1
            fi
            ;;
        "restore")
            # Look for the specific stash
            local stash_ref
            stash_ref=$(git stash list | grep "$stash_message" | head -1 | cut -d: -f1)
            
            if [[ -n "$stash_ref" ]]; then
                read -p "Restore stashed changes? (Y/n): " restore_stash
                if [[ "$restore_stash" != "n" && "$restore_stash" != "N" ]]; then
                    if git stash pop "$stash_ref"; then
                        log_info "Stashed changes restored"
                        return 0
                    else
                        log_warn "Failed to restore stashed changes - they remain in stash"
                        return 1
                    fi
                else
                    log_info "Stashed changes left in stash for later"
                    return 0
                fi
            else
                log_debug "No matching stash found"
                return 0
            fi
            ;;
        *)
            log_error "Invalid stash operation: $operation"
            return 1
            ;;
    esac
}

# Handle uncommitted changes during branch switch
handle_uncommitted_changes_for_switch() {
    local target_branch="$1"
    local current_branch
    current_branch=$(get_current_branch)
    
    echo -e "${YELLOW}Uncommitted changes detected${NC}"
    echo "Current branch: $current_branch"
    echo "Target branch: $target_branch"
    echo ""
    
    # Show current status
    get_working_tree_status
    echo ""
    
    echo "Choose how to handle uncommitted changes:"
    echo "1) Stash changes and switch (recommended)"
    echo "2) Commit changes and switch"
    echo "3) Discard changes and switch (DANGEROUS)"
    echo "4) Show detailed diff"
    echo "5) Cancel switch operation"
    
    while true; do
        read -p "Enter your choice (1-5): " choice
        case $choice in
            1)
                local stash_message="Auto-stash before switching to $target_branch"
                if manage_stash_for_switch "create" "$stash_message"; then
                    echo "stash_created:$stash_message"
                    return 0
                else
                    return 1
                fi
                ;;
            2)
                echo ""
                echo "Please commit your changes manually:"
                echo "  git add ."
                echo "  git commit -m \"Your commit message\""
                echo ""
                echo "Then retry the branch switch operation."
                return 1
                ;;
            3)
                echo -e "${RED}WARNING: This will permanently discard all uncommitted changes!${NC}"
                read -p "Are you absolutely sure? Type 'yes' to confirm: " confirm
                
                if [[ "$confirm" == "yes" ]]; then
                    if git reset --hard HEAD && git clean -fd; then
                        log_warn "Uncommitted changes discarded"
                        return 0
                    else
                        log_error "Failed to discard changes"
                        return 1
                    fi
                else
                    echo "Discard operation cancelled"
                    continue
                fi
                ;;
            4)
                echo -e "\n${WHITE}Detailed diff of uncommitted changes:${NC}"
                git diff --stat
                echo ""
                read -p "Show full diff? (y/N): " show_full
                if [[ "$show_full" == "y" || "$show_full" == "Y" ]]; then
                    git diff
                fi
                echo ""
                continue
                ;;
            5)
                log_info "Branch switch cancelled by user"
                return 1
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, 4, or 5."
                continue
                ;;
        esac
    done
}

# Switch to target branch safely
switch_to_branch() {
    local target_branch="$1"
    local force_switch="${2:-false}"
    
    if [[ -z "$target_branch" ]]; then
        log_error "Target branch name is required"
        return 1
    fi
    
    local current_branch
    current_branch=$(get_current_branch)
    
    if [[ "$current_branch" == "$target_branch" ]]; then
        log_info "Already on branch: $target_branch"
        return 0
    fi
    
    log_info "Switching from '$current_branch' to '$target_branch'"
    
    # Validate target branch
    if ! validate_target_branch "$target_branch"; then
        return 1
    fi
    
    # Check for uncommitted changes
    local stash_info=""
    if check_uncommitted_changes || check_staged_files || check_untracked_files; then
        if [[ "$force_switch" == "false" ]]; then
            local result
            result=$(handle_uncommitted_changes_for_switch "$target_branch")
            local exit_code=$?
            
            if [[ $exit_code -ne 0 ]]; then
                return 1
            fi
            
            # Check if stash was created
            if [[ "$result" == stash_created:* ]]; then
                stash_info="${result#stash_created:}"
            fi
        fi
    fi
    
    # Create backup before switching
    local backup_id
    backup_id=$(create_safety_backup "SWITCH_BRANCH")
    
    # Perform the branch switch
    log_info "Switching to branch: $target_branch"
    
    if git checkout "$target_branch"; then
        log_info "Successfully switched to branch: $target_branch"
        
        # Update working tree and show status
        local new_branch
        new_branch=$(get_current_branch)
        
        echo -e "\n${WHITE}Branch Switch Summary:${NC}"
        echo -e "${CYAN}Previous branch:${NC} $current_branch"
        echo -e "${CYAN}Current branch:${NC} $new_branch"
        
        # Show branch sync status
        if has_upstream "$new_branch"; then
            local sync_status
            sync_status=$(get_branch_sync_status "$new_branch")
            echo -e "${CYAN}Sync status:${NC} $sync_status"
            
            if [[ "$sync_status" == "behind" || "$sync_status" == "diverged" ]]; then
                echo -e "${YELLOW}Note: Branch is not up to date with upstream${NC}"
                
                if [[ "${CONFIG[AUTO_FETCH]}" == "true" ]]; then
                    read -p "Sync with upstream now? (y/N): " sync_now
                    if [[ "$sync_now" == "y" || "$sync_now" == "Y" ]]; then
                        sync_with_upstream "$new_branch"
                    fi
                fi
            fi
        fi
        
        # Offer to restore stash if one was created
        if [[ -n "$stash_info" ]]; then
            echo ""
            manage_stash_for_switch "restore" "$stash_info"
        fi
        
        # Log the operation
        log_operation "SWITCH_BRANCH" "$target_branch" "SUCCESS" "From $current_branch"
        
        return 0
    else
        log_error "Failed to switch to branch: $target_branch"
        log_operation "SWITCH_BRANCH" "$target_branch" "FAILED" "From $current_branch"
        
        # Offer to restore from backup
        if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
            read -p "Restore from backup? (y/N): " restore
            if [[ "$restore" == "y" || "$restore" == "Y" ]]; then
                restore_from_backup "$backup_id"
            fi
        fi
        
        return 1
    fi
}

# Interactive branch switching
interactive_branch_switching() {
    echo -e "${WHITE}Interactive Branch Switching${NC}"
    echo "============================"
    echo ""
    
    local current_branch
    current_branch=$(get_current_branch)
    echo -e "Current branch: ${GREEN}$current_branch${NC}"
    echo ""
    
    # Show available branches
    echo -e "${WHITE}Available branches:${NC}"
    local branch_count=0
    while IFS= read -r branch; do
        branch_count=$((branch_count + 1))
        if [[ "$branch" == "$current_branch" ]]; then
            echo -e "${branch_count}. ${GREEN}$branch${NC} (current)"
        else
            echo -e "${branch_count}. $branch"
            
            # Show sync status if has upstream
            if has_upstream "$branch"; then
                local status
                status=$(get_branch_sync_status "$branch")
                case "$status" in
                    "up-to-date") echo -e "   ${GREEN}↑ up to date${NC}" ;;
                    "ahead") echo -e "   ${BLUE}↑ ahead${NC}" ;;
                    "behind") echo -e "   ${YELLOW}↓ behind${NC}" ;;
                    "diverged") echo -e "   ${RED}↕ diverged${NC}" ;;
                esac
            fi
        fi
    done < <(git branch --format='%(refname:short)' | head -20)
    
    echo ""
    echo "Enter branch number, branch name, or 'q' to quit:"
    read -p "> " selection
    
    if [[ "$selection" == "q" || "$selection" == "Q" ]]; then
        return 0
    fi
    
    local target_branch=""
    
    # Check if selection is a number
    if [[ "$selection" =~ ^[0-9]+$ ]]; then
        target_branch=$(git branch --format='%(refname:short)' | sed -n "${selection}p")
        if [[ -z "$target_branch" ]]; then
            echo "Invalid branch number: $selection"
            return 1
        fi
    else
        target_branch="$selection"
    fi
    
    if [[ "$target_branch" == "$current_branch" ]]; then
        echo "Already on branch: $target_branch"
        return 0
    fi
    
    # Confirm switch
    echo ""
    echo -e "${WHITE}Branch Switch Summary:${NC}"
    echo -e "${CYAN}From:${NC} $current_branch"
    echo -e "${CYAN}To:${NC} $target_branch"
    echo ""
    
    read -p "Switch to this branch? (Y/n): " confirm
    if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
        log_info "Branch switch cancelled"
        return 1
    fi
    
    # Perform the switch
    switch_to_branch "$target_branch"
}

# =============================================================================
# MERGE OPERATIONS AND CONFLICT RESOLUTION
# =============================================================================

# Merge operations functions

# Check if fast-forward merge is possible
can_fast_forward() {
    local source_branch="$1"
    local target_branch="$2"
    
    if [[ -z "$source_branch" || -z "$target_branch" ]]; then
        return 1
    fi
    
    # Check if target is an ancestor of source
    if git merge-base --is-ancestor "$target_branch" "$source_branch"; then
        # Check if source is ahead of target
        local ahead_count
        ahead_count=$(git rev-list --count "$target_branch..$source_branch" 2>/dev/null || echo "0")
        
        if [[ "$ahead_count" -gt 0 ]]; then
            return 0  # Fast-forward is possible
        fi
    fi
    
    return 1  # Fast-forward is not possible
}

# Validate merge prerequisites
validate_merge_prerequisites() {
    local source_branch="$1"
    local target_branch="$2"
    
    log_debug "Validating merge prerequisites..."
    
    # Ensure working tree is clean
    if ! validate_clean_working_tree; then
        log_error "Working tree must be clean for merge operations"
        return 1
    fi
    
    # Validate repository state
    if ! validate_repository_state; then
        log_error "Repository state validation failed"
        return 1
    fi
    
    # Check if source branch exists
    if ! branch_exists "$source_branch"; then
        log_error "Source branch '$source_branch' does not exist"
        return 1
    fi
    
    # Check if target branch exists
    if ! branch_exists "$target_branch"; then
        log_error "Target branch '$target_branch' does not exist"
        return 1
    fi
    
    # Check if branches are different
    if [[ "$source_branch" == "$target_branch" ]]; then
        log_error "Cannot merge branch into itself"
        return 1
    fi
    
    # Check if source and target are the same commit
    local source_commit target_commit
    source_commit=$(git rev-parse "$source_branch" 2>/dev/null)
    target_commit=$(git rev-parse "$target_branch" 2>/dev/null)
    
    if [[ "$source_commit" == "$target_commit" ]]; then
        log_info "Source and target branches are at the same commit - no merge needed"
        return 2  # Special return code for "no merge needed"
    fi
    
    log_debug "Merge prerequisites validation passed"
    return 0
}

# Sync target branch before merge
sync_target_branch_for_merge() {
    local target_branch="$1"
    local current_branch
    current_branch=$(get_current_branch)
    
    log_info "Syncing target branch '$target_branch' before merge..."
    
    # Switch to target branch temporarily
    if [[ "$current_branch" != "$target_branch" ]]; then
        if ! git checkout "$target_branch" 2>/dev/null; then
            log_error "Failed to switch to target branch for sync"
            return 1
        fi
    fi
    
    # Sync with upstream if configured
    if has_upstream "$target_branch"; then
        if ! sync_with_upstream "$target_branch"; then
            log_warn "Failed to sync target branch with upstream"
            
            # Switch back to original branch
            if [[ "$current_branch" != "$target_branch" ]]; then
                git checkout "$current_branch" 2>/dev/null
            fi
            return 1
        fi
    else
        log_debug "Target branch has no upstream - skipping sync"
    fi
    
    # Switch back to original branch
    if [[ "$current_branch" != "$target_branch" ]]; then
        if ! git checkout "$current_branch" 2>/dev/null; then
            log_error "Failed to switch back to original branch"
            return 1
        fi
    fi
    
    log_info "Target branch sync completed"
    return 0
}

# Perform fast-forward merge
perform_fast_forward_merge() {
    local source_branch="$1"
    local target_branch="$2"
    
    log_info "Performing fast-forward merge: $source_branch -> $target_branch"
    
    # Switch to target branch
    if ! git checkout "$target_branch"; then
        log_error "Failed to switch to target branch: $target_branch"
        return 1
    fi
    
    # Perform fast-forward merge
    if git merge --ff-only "$source_branch"; then
        log_info "Fast-forward merge completed successfully"
        log_operation "MERGE_FAST_FORWARD" "$source_branch->$target_branch" "SUCCESS" "Fast-forward merge"
        return 0
    else
        log_error "Fast-forward merge failed"
        log_operation "MERGE_FAST_FORWARD" "$source_branch->$target_branch" "FAILED" "Fast-forward failed"
        return 1
    fi
}

# Perform regular merge with commit
perform_merge_commit() {
    local source_branch="$1"
    local target_branch="$2"
    local merge_message="$3"
    
    log_info "Performing merge commit: $source_branch -> $target_branch"
    
    # Switch to target branch
    if ! git checkout "$target_branch"; then
        log_error "Failed to switch to target branch: $target_branch"
        return 1
    fi
    
    # Prepare merge message
    if [[ -z "$merge_message" ]]; then
        merge_message="Merge branch '$source_branch' into $target_branch"
    fi
    
    # Perform merge
    if git merge --no-ff -m "$merge_message" "$source_branch"; then
        log_info "Merge commit completed successfully"
        log_operation "MERGE_COMMIT" "$source_branch->$target_branch" "SUCCESS" "Merge commit created"
        return 0
    else
        log_error "Merge commit failed"
        log_operation "MERGE_COMMIT" "$source_branch->$target_branch" "FAILED" "Merge commit failed"
        return 1
    fi
}

# Show merge preview
show_merge_preview() {
    local source_branch="$1"
    local target_branch="$2"
    
    echo -e "${WHITE}Merge Preview${NC}"
    echo "============="
    echo -e "${CYAN}Source branch:${NC} $source_branch"
    echo -e "${CYAN}Target branch:${NC} $target_branch"
    echo ""
    
    # Show commits that will be merged
    local commit_count
    commit_count=$(git rev-list --count "$target_branch..$source_branch" 2>/dev/null || echo "0")
    echo -e "${CYAN}Commits to merge:${NC} $commit_count"
    
    if [[ "$commit_count" -gt 0 ]]; then
        echo ""
        echo -e "${WHITE}Recent commits from $source_branch:${NC}"
        git log --oneline --graph "$target_branch..$source_branch" | head -10
    fi
    
    # Check merge type
    if can_fast_forward "$source_branch" "$target_branch"; then
        echo -e "\n${CYAN}Merge type:${NC} ${GREEN}Fast-forward${NC} (clean linear history)"
    else
        echo -e "\n${CYAN}Merge type:${NC} ${YELLOW}Merge commit${NC} (will create merge commit)"
    fi
    
    # Show file changes
    echo -e "\n${CYAN}Files changed:${NC}"
    git diff --name-status "$target_branch..$source_branch" | head -10
    
    local total_files
    total_files=$(git diff --name-only "$target_branch..$source_branch" | wc -l)
    if [[ "$total_files" -gt 10 ]]; then
        echo "... and $((total_files - 10)) more files"
    fi
}

# Main merge function
merge_branch() {
    local source_branch="$1"
    local target_branch="${2:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    local merge_strategy="${3:-auto}"  # auto, fast-forward, merge-commit
    local skip_sync="${4:-false}"
    
    if [[ -z "$source_branch" ]]; then
        log_error "Source branch name is required"
        return 1
    fi
    
    log_info "Starting merge operation: $source_branch -> $target_branch"
    
    # Validate merge prerequisites
    local validation_result
    validate_merge_prerequisites "$source_branch" "$target_branch"
    validation_result=$?
    
    case $validation_result in
        0)
            log_debug "Merge prerequisites validated"
            ;;
        1)
            log_error "Merge prerequisites validation failed"
            return 1
            ;;
        2)
            log_info "No merge needed - branches are at the same commit"
            return 0
            ;;
    esac
    
    # Sync target branch with remote if enabled
    if [[ "$skip_sync" == "false" && "${CONFIG[AUTO_FETCH]}" == "true" ]]; then
        if ! sync_target_branch_for_merge "$target_branch"; then
            if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
                read -p "Target branch sync failed. Continue with merge? (y/N): " continue_merge
                if [[ "$continue_merge" != "y" && "$continue_merge" != "Y" ]]; then
                    log_info "Merge cancelled due to sync failure"
                    return 1
                fi
            else
                log_error "Target branch sync failed - aborting merge"
                return 1
            fi
        fi
    fi
    
    # Show merge preview
    echo ""
    show_merge_preview "$source_branch" "$target_branch"
    echo ""
    
    # Confirm merge if required
    if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
        read -p "Proceed with merge? (Y/n): " confirm_merge
        if [[ "$confirm_merge" == "n" || "$confirm_merge" == "N" ]]; then
            log_info "Merge cancelled by user"
            return 1
        fi
    fi
    
    # Create backup before merge
    local backup_id
    backup_id=$(create_safety_backup "MERGE_BRANCH")
    
    # Determine merge strategy
    local actual_strategy="$merge_strategy"
    if [[ "$merge_strategy" == "auto" ]]; then
        if can_fast_forward "$source_branch" "$target_branch"; then
            actual_strategy="fast-forward"
        else
            actual_strategy="merge-commit"
        fi
    fi
    
    # Perform merge based on strategy
    case "$actual_strategy" in
        "fast-forward")
            if perform_fast_forward_merge "$source_branch" "$target_branch"; then
                echo -e "\n${GREEN}Fast-forward merge completed successfully!${NC}"
                return 0
            else
                log_error "Fast-forward merge failed"
                return 1
            fi
            ;;
        "merge-commit")
            local merge_message="Merge branch '$source_branch' into $target_branch"
            if perform_merge_commit "$source_branch" "$target_branch" "$merge_message"; then
                echo -e "\n${GREEN}Merge commit completed successfully!${NC}"
                return 0
            else
                log_error "Merge commit failed"
                return 1
            fi
            ;;
        *)
            log_error "Unknown merge strategy: $actual_strategy"
            return 1
            ;;
    esac
}

# Interactive merge operation
interactive_merge() {
    echo -e "${WHITE}Interactive Merge Operation${NC}"
    echo "==========================="
    echo ""
    
    local current_branch
    current_branch=$(get_current_branch)
    echo -e "Current branch: ${GREEN}$current_branch${NC}"
    echo ""
    
    # Get source branch
    echo -e "${WHITE}Available branches to merge:${NC}"
    local branch_count=0
    while IFS= read -r branch; do
        if [[ "$branch" != "$current_branch" ]]; then
            branch_count=$((branch_count + 1))
            echo -e "${branch_count}. $branch"
        fi
    done < <(git branch --format='%(refname:short)')
    
    echo ""
    read -p "Enter source branch name or number: " source_selection
    
    local source_branch=""
    if [[ "$source_selection" =~ ^[0-9]+$ ]]; then
        # User entered a number
        local selected_count=0
        while IFS= read -r branch; do
            if [[ "$branch" != "$current_branch" ]]; then
                selected_count=$((selected_count + 1))
                if [[ "$selected_count" -eq "$source_selection" ]]; then
                    source_branch="$branch"
                    break
                fi
            fi
        done < <(git branch --format='%(refname:short)')
        
        if [[ -z "$source_branch" ]]; then
            echo "Invalid branch number: $source_selection"
            return 1
        fi
    else
        source_branch="$source_selection"
    fi
    
    # Get target branch
    echo ""
    read -p "Enter target branch (default: $current_branch): " target_branch
    target_branch="${target_branch:-$current_branch}"
    
    # Confirm merge details
    echo ""
    echo -e "${WHITE}Merge Summary:${NC}"
    echo -e "${CYAN}Source branch:${NC} $source_branch"
    echo -e "${CYAN}Target branch:${NC} $target_branch"
    echo ""
    
    read -p "Proceed with merge? (Y/n): " confirm
    if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
        log_info "Merge cancelled"
        return 1
    fi
    
    # Perform the merge
    merge_branch "$source_branch" "$target_branch"
}

# Conflict detection and resolution functions

# Detect merge conflicts
detect_merge_conflicts() {
    log_debug "Detecting merge conflicts..."
    
    # Check if we're in a merge state
    if [[ ! -f ".git/MERGE_HEAD" ]]; then
        return 1  # No merge in progress
    fi
    
    # Get list of conflicted files
    local conflicted_files
    conflicted_files=$(git diff --name-only --diff-filter=U 2>/dev/null)
    
    if [[ -n "$conflicted_files" ]]; then
        return 0  # Conflicts detected
    else
        return 1  # No conflicts
    fi
}

# Get list of conflicted files
get_conflicted_files() {
    git diff --name-only --diff-filter=U 2>/dev/null
}

# Categorize conflict complexity
categorize_conflict() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        echo "missing"
        return
    fi
    
    # Count conflict markers
    local conflict_markers
    conflict_markers=$(grep -c "^<<<<<<<\|^=======\|^>>>>>>>" "$file" 2>/dev/null || echo "0")
    
    # Analyze conflict content
    local conflict_lines
    conflict_lines=$(git diff --no-index /dev/null "$file" 2>/dev/null | grep -c "^[+-]" || echo "0")
    
    # Simple heuristics for categorization
    if [[ "$conflict_markers" -le 3 && "$conflict_lines" -le 10 ]]; then
        echo "simple"
    elif [[ "$conflict_markers" -le 10 && "$conflict_lines" -le 50 ]]; then
        echo "moderate"
    else
        echo "complex"
    fi
}

# Check if conflict is auto-resolvable (whitespace/formatting)
is_auto_resolvable() {
    local file="$1"
    
    # Extract conflict sections
    local temp_ours temp_theirs
    temp_ours=$(mktemp)
    temp_theirs=$(mktemp)
    
    # Extract "ours" and "theirs" versions
    sed -n '/^<<<<<<< /,/^=======/p' "$file" | sed '1d;$d' > "$temp_ours"
    sed -n '/^=======/,/^>>>>>>> /p' "$file" | sed '1d;$d' > "$temp_theirs"
    
    # Compare ignoring whitespace
    if diff -w "$temp_ours" "$temp_theirs" >/dev/null 2>&1; then
        rm -f "$temp_ours" "$temp_theirs"
        return 0  # Auto-resolvable (whitespace only)
    fi
    
    rm -f "$temp_ours" "$temp_theirs"
    return 1  # Not auto-resolvable
}

# Automatically resolve simple conflicts
auto_resolve_conflict() {
    local file="$1"
    local resolution_strategy="${2:-ours}"  # ours, theirs, whitespace
    
    log_info "Auto-resolving conflict in: $file"
    
    case "$resolution_strategy" in
        "whitespace")
            # For whitespace-only conflicts, prefer "ours" version
            if is_auto_resolvable "$file"; then
                # Extract "ours" version and replace file content
                local temp_file
                temp_file=$(mktemp)
                
                # Remove conflict markers and keep "ours" version
                sed '/^<<<<<<< /,/^=======/!d; /^<<<<<<< /d; /^=======/d' "$file" > "$temp_file"
                sed '/^=======/,/^>>>>>>> /d' "$file" >> "$temp_file"
                
                if mv "$temp_file" "$file"; then
                    git add "$file"
                    log_info "Auto-resolved whitespace conflict in: $file"
                    return 0
                else
                    rm -f "$temp_file"
                    return 1
                fi
            fi
            ;;
        "ours")
            # Keep our version
            git checkout --ours "$file" && git add "$file"
            log_info "Auto-resolved conflict using 'ours' strategy: $file"
            return 0
            ;;
        "theirs")
            # Keep their version
            git checkout --theirs "$file" && git add "$file"
            log_info "Auto-resolved conflict using 'theirs' strategy: $file"
            return 0
            ;;
        *)
            log_error "Unknown resolution strategy: $resolution_strategy"
            return 1
            ;;
    esac
    
    return 1
}

# Launch merge tool for manual resolution
launch_merge_tool() {
    local file="$1"
    local merge_tool="${CONFIG[CONFLICT_RESOLUTION_TOOL]}"
    
    log_info "Launching merge tool for: $file"
    log_debug "Merge tool command: $merge_tool"
    
    # Check if merge tool is available
    local tool_command
    tool_command=$(echo "$merge_tool" | cut -d' ' -f1)
    
    if ! command -v "$tool_command" >/dev/null 2>&1; then
        log_warn "Configured merge tool '$tool_command' not found"
        
        # Try common merge tools
        local common_tools=("code" "subl" "vim" "nano")
        for tool in "${common_tools[@]}"; do
            if command -v "$tool" >/dev/null 2>&1; then
                log_info "Using fallback merge tool: $tool"
                merge_tool="$tool"
                break
            fi
        done
    fi
    
    # Launch the merge tool
    if eval "$merge_tool \"$file\""; then
        log_info "Merge tool launched successfully"
        return 0
    else
        log_error "Failed to launch merge tool"
        return 1
    fi
}

# Show conflict details
show_conflict_details() {
    local file="$1"
    
    echo -e "${WHITE}Conflict Details: $file${NC}"
    echo "================================="
    
    local category
    category=$(categorize_conflict "$file")
    echo -e "${CYAN}Complexity:${NC} $category"
    
    local conflict_count
    conflict_count=$(grep -c "^<<<<<<<" "$file" 2>/dev/null || echo "0")
    echo -e "${CYAN}Conflict sections:${NC} $conflict_count"
    
    if is_auto_resolvable "$file"; then
        echo -e "${CYAN}Auto-resolvable:${NC} ${GREEN}Yes${NC} (whitespace/formatting only)"
    else
        echo -e "${CYAN}Auto-resolvable:${NC} ${RED}No${NC} (manual resolution required)"
    fi
    
    echo ""
    echo -e "${WHITE}Conflict preview:${NC}"
    echo "=================="
    
    # Show first few lines of conflict
    grep -A 5 -B 5 "^<<<<<<<\|^=======\|^>>>>>>>" "$file" | head -20
    
    local total_conflict_lines
    total_conflict_lines=$(grep -c "^<<<<<<<\|^=======\|^>>>>>>>" "$file" 2>/dev/null || echo "0")
    if [[ "$total_conflict_lines" -gt 20 ]]; then
        echo "... (showing first 20 lines of conflicts)"
    fi
}

# Interactive conflict resolution
resolve_conflicts_interactively() {
    local conflicted_files
    conflicted_files=$(get_conflicted_files)
    
    if [[ -z "$conflicted_files" ]]; then
        log_info "No conflicts to resolve"
        return 0
    fi
    
    echo -e "${WHITE}Interactive Conflict Resolution${NC}"
    echo "==============================="
    echo ""
    
    local file_count
    file_count=$(echo "$conflicted_files" | wc -l)
    echo -e "${YELLOW}Found $file_count conflicted files${NC}"
    echo ""
    
    local resolved_count=0
    local file_number=1
    
    for file in $conflicted_files; do
        echo -e "${WHITE}File $file_number of $file_count: $file${NC}"
        echo "================================="
        
        show_conflict_details "$file"
        echo ""
        
        echo "Choose resolution strategy:"
        echo "1) Auto-resolve (keep ours)"
        echo "2) Auto-resolve (keep theirs)"
        echo "3) Auto-resolve (whitespace only)"
        echo "4) Launch merge tool"
        echo "5) Show detailed diff"
        echo "6) Skip this file"
        echo "7) Abort conflict resolution"
        
        while true; do
            read -p "Enter your choice (1-7): " choice
            case $choice in
                1)
                    if auto_resolve_conflict "$file" "ours"; then
                        resolved_count=$((resolved_count + 1))
                        echo -e "${GREEN}Resolved using 'ours' strategy${NC}"
                        break
                    else
                        echo -e "${RED}Auto-resolution failed${NC}"
                        continue
                    fi
                    ;;
                2)
                    if auto_resolve_conflict "$file" "theirs"; then
                        resolved_count=$((resolved_count + 1))
                        echo -e "${GREEN}Resolved using 'theirs' strategy${NC}"
                        break
                    else
                        echo -e "${RED}Auto-resolution failed${NC}"
                        continue
                    fi
                    ;;
                3)
                    if auto_resolve_conflict "$file" "whitespace"; then
                        resolved_count=$((resolved_count + 1))
                        echo -e "${GREEN}Resolved whitespace conflict${NC}"
                        break
                    else
                        echo -e "${RED}Not a whitespace-only conflict${NC}"
                        continue
                    fi
                    ;;
                4)
                    launch_merge_tool "$file"
                    echo ""
                    read -p "Press Enter after resolving conflicts in the merge tool..."
                    
                    # Check if conflicts are resolved
                    if ! grep -q "^<<<<<<<\|^=======\|^>>>>>>>" "$file" 2>/dev/null; then
                        git add "$file"
                        resolved_count=$((resolved_count + 1))
                        echo -e "${GREEN}Conflicts resolved manually${NC}"
                        break
                    else
                        echo -e "${YELLOW}Conflicts still present in file${NC}"
                        continue
                    fi
                    ;;
                5)
                    echo -e "\n${WHITE}Detailed conflict diff:${NC}"
                    git diff "$file" || true
                    echo ""
                    continue
                    ;;
                6)
                    echo -e "${YELLOW}Skipped file: $file${NC}"
                    break
                    ;;
                7)
                    echo -e "${RED}Conflict resolution aborted${NC}"
                    return 1
                    ;;
                *)
                    echo "Invalid choice. Please enter 1, 2, 3, 4, 5, 6, or 7."
                    continue
                    ;;
            esac
        done
        
        file_number=$((file_number + 1))
        echo ""
    done
    
    echo -e "${WHITE}Conflict Resolution Summary${NC}"
    echo "==========================="
    echo -e "${CYAN}Total files:${NC} $file_count"
    echo -e "${CYAN}Resolved:${NC} $resolved_count"
    echo -e "${CYAN}Remaining:${NC} $((file_count - resolved_count))"
    
    if [[ "$resolved_count" -eq "$file_count" ]]; then
        echo -e "\n${GREEN}All conflicts resolved!${NC}"
        return 0
    else
        echo -e "\n${YELLOW}Some conflicts remain unresolved${NC}"
        return 1
    fi
}

# Validate that all conflicts are resolved
validate_conflict_resolution() {
    log_debug "Validating conflict resolution..."
    
    if detect_merge_conflicts; then
        local remaining_conflicts
        remaining_conflicts=$(get_conflicted_files)
        log_warn "Unresolved conflicts remain in files:"
        echo "$remaining_conflicts"
        return 1
    fi
    
    # Check for conflict markers in all files
    local files_with_markers
    files_with_markers=$(git diff --cached --name-only | xargs grep -l "^<<<<<<<\|^=======\|^>>>>>>>" 2>/dev/null || true)
    
    if [[ -n "$files_with_markers" ]]; then
        log_warn "Conflict markers found in staged files:"
        echo "$files_with_markers"
        return 1
    fi
    
    log_info "All conflicts have been resolved"
    return 0
}

# Complete merge after conflict resolution
complete_merge_after_conflicts() {
    log_info "Completing merge after conflict resolution..."
    
    # Validate all conflicts are resolved
    if ! validate_conflict_resolution; then
        log_error "Cannot complete merge - conflicts remain unresolved"
        return 1
    fi
    
    # Commit the merge
    if git commit --no-edit; then
        log_info "Merge completed successfully after conflict resolution"
        log_operation "MERGE_COMPLETE" "$(get_current_branch)" "SUCCESS" "Completed after conflict resolution"
        return 0
    else
        log_error "Failed to complete merge commit"
        log_operation "MERGE_COMPLETE" "$(get_current_branch)" "FAILED" "Commit failed"
        return 1
    fi
}

# Post-merge cleanup operations

# Check if branch is safe to delete
is_branch_safe_to_delete() {
    local branch_name="$1"
    local target_branch="${2:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    
    if [[ -z "$branch_name" ]]; then
        return 1
    fi
    
    # Don't delete main branches
    local protected_branches=("main" "master" "develop" "dev")
    for protected in "${protected_branches[@]}"; do
        if [[ "$branch_name" == "$protected" ]]; then
            log_debug "Branch '$branch_name' is protected from deletion"
            return 1
        fi
    done
    
    # Check if branch is fully merged
    if git branch --merged "$target_branch" | grep -q "^[[:space:]]*$branch_name$"; then
        log_debug "Branch '$branch_name' is fully merged into '$target_branch'"
        return 0
    else
        log_debug "Branch '$branch_name' is not fully merged into '$target_branch'"
        return 1
    fi
}

# Get list of merged branches
get_merged_branches() {
    local target_branch="${1:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    local current_branch
    current_branch=$(get_current_branch)
    
    # Get merged branches, excluding current and protected branches
    git branch --merged "$target_branch" | \
        grep -v "^[[:space:]]*\*" | \
        grep -v "^[[:space:]]*$target_branch$" | \
        grep -v "^[[:space:]]*$current_branch$" | \
        grep -v "^[[:space:]]*main$" | \
        grep -v "^[[:space:]]*master$" | \
        grep -v "^[[:space:]]*develop$" | \
        grep -v "^[[:space:]]*dev$" | \
        sed 's/^[[:space:]]*//'
}

# Delete merged branch with confirmation
delete_merged_branch() {
    local branch_name="$1"
    local force_delete="${2:-false}"
    local target_branch="${3:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    
    if [[ -z "$branch_name" ]]; then
        log_error "Branch name is required for deletion"
        return 1
    fi
    
    log_info "Preparing to delete merged branch: $branch_name"
    
    # Safety checks
    if ! is_branch_safe_to_delete "$branch_name" "$target_branch"; then
        if [[ "$force_delete" == "false" ]]; then
            log_error "Branch '$branch_name' is not safe to delete (not fully merged or protected)"
            return 1
        else
            log_warn "Force deleting branch '$branch_name' despite safety checks"
        fi
    fi
    
    # Show branch information before deletion
    echo -e "${WHITE}Branch Deletion Summary${NC}"
    echo "======================="
    echo -e "${CYAN}Branch to delete:${NC} $branch_name"
    
    local last_commit
    last_commit=$(git log -1 --format="%h %s" "$branch_name" 2>/dev/null || echo "No commits")
    echo -e "${CYAN}Last commit:${NC} $last_commit"
    
    local commit_date
    commit_date=$(git log -1 --format="%ci" "$branch_name" 2>/dev/null || echo "Unknown")
    echo -e "${CYAN}Last modified:${NC} $commit_date"
    
    if has_upstream "$branch_name"; then
        local upstream
        upstream=$(get_upstream_branch "$branch_name")
        echo -e "${CYAN}Upstream:${NC} $upstream"
        echo -e "${YELLOW}Note: Upstream tracking will be removed${NC}"
    fi
    
    echo ""
    
    # Confirm deletion
    if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
        read -p "Delete this branch? (y/N): " confirm_delete
        if [[ "$confirm_delete" != "y" && "$confirm_delete" != "Y" ]]; then
            log_info "Branch deletion cancelled"
            return 1
        fi
    fi
    
    # Create backup before deletion
    local backup_id
    backup_id=$(create_safety_backup "DELETE_BRANCH")
    
    # Delete the branch
    local delete_flag="-d"
    if [[ "$force_delete" == "true" ]]; then
        delete_flag="-D"
    fi
    
    if git branch $delete_flag "$branch_name"; then
        log_info "Successfully deleted branch: $branch_name"
        log_operation "DELETE_BRANCH" "$branch_name" "SUCCESS" "Merged branch deleted"
        
        # Delete remote tracking branch if it exists
        if git branch -r | grep -q "origin/$branch_name"; then
            read -p "Delete remote branch 'origin/$branch_name'? (y/N): " delete_remote
            if [[ "$delete_remote" == "y" || "$delete_remote" == "Y" ]]; then
                if git push origin --delete "$branch_name" 2>/dev/null; then
                    log_info "Deleted remote branch: origin/$branch_name"
                else
                    log_warn "Failed to delete remote branch: origin/$branch_name"
                fi
            fi
        fi
        
        return 0
    else
        log_error "Failed to delete branch: $branch_name"
        log_operation "DELETE_BRANCH" "$branch_name" "FAILED" "Deletion failed"
        return 1
    fi
}

# Cleanup all merged branches
cleanup_merged_branches() {
    local target_branch="${1:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    local auto_confirm="${2:-false}"
    
    log_info "Cleaning up merged branches..."
    
    local merged_branches
    merged_branches=$(get_merged_branches "$target_branch")
    
    if [[ -z "$merged_branches" ]]; then
        log_info "No merged branches found for cleanup"
        return 0
    fi
    
    echo -e "${WHITE}Merged Branch Cleanup${NC}"
    echo "====================="
    echo -e "${CYAN}Target branch:${NC} $target_branch"
    echo ""
    
    echo -e "${WHITE}Branches to be deleted:${NC}"
    local branch_count=0
    for branch in $merged_branches; do
        branch_count=$((branch_count + 1))
        echo -e "${branch_count}. $branch"
        
        # Show last commit info
        local last_commit
        last_commit=$(git log -1 --format="  %h %s (%cr)" "$branch" 2>/dev/null || echo "  No commit info")
        echo -e "${CYAN}$last_commit${NC}"
    done
    
    echo ""
    echo -e "${YELLOW}Total branches to delete: $branch_count${NC}"
    
    if [[ "$auto_confirm" == "false" && "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
        echo ""
        read -p "Proceed with cleanup? (y/N): " confirm_cleanup
        if [[ "$confirm_cleanup" != "y" && "$confirm_cleanup" != "Y" ]]; then
            log_info "Branch cleanup cancelled"
            return 1
        fi
    fi
    
    # Delete branches one by one
    local deleted_count=0
    local failed_count=0
    
    for branch in $merged_branches; do
        echo ""
        echo -e "Deleting branch: ${CYAN}$branch${NC}"
        
        if delete_merged_branch "$branch" "false" "$target_branch"; then
            deleted_count=$((deleted_count + 1))
            echo -e "${GREEN}✓ Deleted successfully${NC}"
        else
            failed_count=$((failed_count + 1))
            echo -e "${RED}✗ Deletion failed${NC}"
        fi
    done
    
    echo ""
    echo -e "${WHITE}Cleanup Summary${NC}"
    echo "==============="
    echo -e "${CYAN}Total branches:${NC} $branch_count"
    echo -e "${CYAN}Deleted:${NC} ${GREEN}$deleted_count${NC}"
    echo -e "${CYAN}Failed:${NC} ${RED}$failed_count${NC}"
    
    if [[ "$deleted_count" -gt 0 ]]; then
        log_info "Successfully cleaned up $deleted_count merged branches"
    fi
    
    if [[ "$failed_count" -gt 0 ]]; then
        log_warn "$failed_count branches could not be deleted"
    fi
    
    return 0
}

# Integration with push_to_github.sh
push_after_merge() {
    local target_branch="${1:-$(get_current_branch)}"
    local push_script="./push_to_github.sh"
    
    if [[ ! -f "$push_script" ]]; then
        log_warn "push_to_github.sh script not found in current directory"
        return 1
    fi
    
    if [[ ! -x "$push_script" ]]; then
        log_warn "push_to_github.sh script is not executable"
        return 1
    fi
    
    log_info "Pushing merged changes using push_to_github.sh..."
    
    # Show what will be pushed
    echo -e "${WHITE}Push Summary${NC}"
    echo "============"
    echo -e "${CYAN}Branch:${NC} $target_branch"
    
    if has_upstream "$target_branch"; then
        local upstream
        upstream=$(get_upstream_branch "$target_branch")
        local ahead_count
        ahead_count=$(git rev-list --count "$upstream..$target_branch" 2>/dev/null || echo "0")
        echo -e "${CYAN}Commits to push:${NC} $ahead_count"
    fi
    
    echo ""
    
    # Confirm push
    if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
        read -p "Push changes to GitHub? (Y/n): " confirm_push
        if [[ "$confirm_push" == "n" || "$confirm_push" == "N" ]]; then
            log_info "Push cancelled by user"
            return 1
        fi
    fi
    
    # Execute push script
    if "$push_script"; then
        log_info "Successfully pushed changes to GitHub"
        log_operation "PUSH_AFTER_MERGE" "$target_branch" "SUCCESS" "Pushed via push_to_github.sh"
        return 0
    else
        log_error "Failed to push changes to GitHub"
        log_operation "PUSH_AFTER_MERGE" "$target_branch" "FAILED" "Push script failed"
        return 1
    fi
}

# Complete post-merge workflow
complete_post_merge_workflow() {
    local source_branch="$1"
    local target_branch="${2:-$(get_current_branch)}"
    
    echo -e "\n${WHITE}Post-Merge Workflow${NC}"
    echo "==================="
    echo ""
    
    # Offer to delete source branch
    if [[ "${CONFIG[AUTO_CLEANUP_MERGED]}" == "true" ]]; then
        echo "Auto-cleanup is enabled"
        if is_branch_safe_to_delete "$source_branch" "$target_branch"; then
            echo -e "Deleting merged branch: ${CYAN}$source_branch${NC}"
            delete_merged_branch "$source_branch" "false" "$target_branch"
        else
            echo -e "${YELLOW}Branch '$source_branch' is not safe for auto-deletion${NC}"
        fi
    else
        if is_branch_safe_to_delete "$source_branch" "$target_branch"; then
            read -p "Delete merged branch '$source_branch'? (Y/n): " delete_branch
            if [[ "$delete_branch" != "n" && "$delete_branch" != "N" ]]; then
                delete_merged_branch "$source_branch" "false" "$target_branch"
            fi
        fi
    fi
    
    echo ""
    
    # Offer to push changes
    read -p "Push merged changes to GitHub? (Y/n): " push_changes
    if [[ "$push_changes" != "n" && "$push_changes" != "N" ]]; then
        push_after_merge "$target_branch"
    fi
    
    echo ""
    echo -e "${GREEN}Post-merge workflow completed!${NC}"
}

# =============================================================================
# INTERACTIVE USER INTERFACE SYSTEM
# =============================================================================

# Main menu and navigation system

# Display main menu
show_main_menu() {
    clear
    echo -e "${WHITE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║                    Git Branch Manager v$SCRIPT_VERSION                    ║${NC}"
    echo -e "${WHITE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Show current repository and branch info
    local current_branch repo_name
    current_branch=$(get_current_branch 2>/dev/null || echo "unknown")
    repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "unknown")
    
    echo -e "${CYAN}Repository:${NC} $repo_name"
    echo -e "${CYAN}Current Branch:${NC} ${GREEN}$current_branch${NC}"
    
    # Show sync status if branch has upstream
    if [[ "$current_branch" != "unknown" ]] && has_upstream "$current_branch"; then
        local sync_status
        sync_status=$(get_branch_sync_status "$current_branch")
        case "$sync_status" in
            "up-to-date") echo -e "${CYAN}Status:${NC} ${GREEN}Up to date${NC}" ;;
            "ahead") echo -e "${CYAN}Status:${NC} ${BLUE}Ahead of upstream${NC}" ;;
            "behind") echo -e "${CYAN}Status:${NC} ${YELLOW}Behind upstream${NC}" ;;
            "diverged") echo -e "${CYAN}Status:${NC} ${RED}Diverged from upstream${NC}" ;;
        esac
    fi
    
    # Show working tree status
    if ! validate_clean_working_tree >/dev/null 2>&1; then
        echo -e "${CYAN}Working Tree:${NC} ${YELLOW}Has uncommitted changes${NC}"
    else
        echo -e "${CYAN}Working Tree:${NC} ${GREEN}Clean${NC}"
    fi
    
    echo ""
    echo -e "${WHITE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Main menu options
    echo -e "${WHITE}Main Menu:${NC}"
    echo ""
    echo -e " ${CYAN}1.${NC} Branch Operations"
    echo -e "    • Create new branch"
    echo -e "    • Switch between branches"
    echo -e "    • List and manage branches"
    echo ""
    echo -e " ${CYAN}2.${NC} Merge Operations"
    echo -e "    • Merge branches"
    echo -e "    • Resolve conflicts"
    echo -e "    • View merge preview"
    echo ""
    echo -e " ${CYAN}3.${NC} Remote Synchronization"
    echo -e "    • Sync with upstream"
    echo -e "    • Manage upstream tracking"
    echo -e "    • Fetch remote changes"
    echo ""
    echo -e " ${CYAN}4.${NC} Repository Status"
    echo -e "    • View branch status"
    echo -e "    • Check repository health"
    echo -e "    • Show detailed information"
    echo ""
    echo -e " ${CYAN}5.${NC} Push to Repository"
    echo -e "    • Commit and push changes"
    echo -e "    • Interactive push options"
    echo -e "    • Auto-generated commit messages"
    echo ""
    echo -e " ${CYAN}6.${NC} Cleanup Operations"
    echo -e "    • Delete merged branches"
    echo -e "    • Manage backups"
    echo -e "    • Repository maintenance"
    echo ""
    echo -e " ${CYAN}7.${NC} Configuration"
    echo -e "    • View/edit settings"
    echo -e "    • Workflow patterns"
    echo -e "    • Tool preferences"
    echo ""
    echo -e " ${CYAN}8.${NC} Help & Information"
    echo -e "    • Usage examples"
    echo -e "    • Command reference"
    echo -e "    • Troubleshooting"
    echo ""
    echo -e " ${CYAN}q.${NC} Quit"
    echo ""
    echo -e "${WHITE}═══════════════════════════════════════════════════════════════${NC}"
}

# Branch operations submenu
show_branch_menu() {
    while true; do
        clear
        echo -e "${WHITE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${WHITE}║                      Branch Operations                       ║${NC}"
        echo -e "${WHITE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        local current_branch
        current_branch=$(get_current_branch 2>/dev/null || echo "unknown")
        echo -e "${CYAN}Current Branch:${NC} ${GREEN}$current_branch${NC}"
        echo ""
        
        echo -e "${WHITE}Branch Operations:${NC}"
        echo ""
        echo -e " ${CYAN}1.${NC} Create new branch"
        echo -e " ${CYAN}2.${NC} Switch to branch"
        echo -e " ${CYAN}3.${NC} List all branches"
        echo -e " ${CYAN}4.${NC} Show branch details"
        echo -e " ${CYAN}5.${NC} Delete branch"
        echo ""
        echo -e " ${CYAN}b.${NC} Back to main menu"
        echo ""
        
        choice=$(read_menu_choice "Select option: ") || return 1
        
        case $choice in
            1)
                echo ""
                interactive_branch_creation
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                interactive_branch_switching
                read -p "Press Enter to continue..."
                ;;
            3)
                echo ""
                show_branch_status "true"
                read -p "Press Enter to continue..."
                ;;
            4)
                echo ""
                read -p "Enter branch name (or press Enter for current): " branch_name
                branch_name="${branch_name:-$current_branch}"
                if [[ -n "$branch_name" && "$branch_name" != "unknown" ]]; then
                    get_branch_sync_details "$branch_name"
                else
                    echo "Invalid branch name"
                fi
                read -p "Press Enter to continue..."
                ;;
            5)
                echo ""
                read -p "Enter branch name to delete: " branch_name
                if [[ -n "$branch_name" ]]; then
                    delete_merged_branch "$branch_name"
                else
                    echo "Branch name cannot be empty"
                fi
                read -p "Press Enter to continue..."
                ;;
            b|B)
                return 0
                ;;
            *)
                echo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Merge operations submenu
show_merge_menu() {
    while true; do
        clear
        echo -e "${WHITE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${WHITE}║                      Merge Operations                        ║${NC}"
        echo -e "${WHITE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        local current_branch
        current_branch=$(get_current_branch 2>/dev/null || echo "unknown")
        echo -e "${CYAN}Current Branch:${NC} ${GREEN}$current_branch${NC}"
        
        # Check if we're in a merge state
        if [[ -f ".git/MERGE_HEAD" ]]; then
            echo -e "${CYAN}Status:${NC} ${YELLOW}Merge in progress${NC}"
            
            if detect_merge_conflicts; then
                echo -e "${CYAN}Conflicts:${NC} ${RED}Yes - resolution required${NC}"
            else
                echo -e "${CYAN}Conflicts:${NC} ${GREEN}None${NC}"
            fi
        fi
        
        echo ""
        
        echo -e "${WHITE}Merge Operations:${NC}"
        echo ""
        echo -e " ${CYAN}1.${NC} Merge branch (interactive)"
        echo -e " ${CYAN}2.${NC} Show merge preview"
        echo -e " ${CYAN}3.${NC} Resolve conflicts"
        echo -e " ${CYAN}4.${NC} Complete merge"
        echo -e " ${CYAN}5.${NC} Abort merge"
        echo ""
        echo -e " ${CYAN}b.${NC} Back to main menu"
        echo ""
        
        choice=$(read_menu_choice "Select option: ") || return 1
        
        case $choice in
            1)
                if [[ -f ".git/MERGE_HEAD" ]]; then
                    echo "Merge already in progress. Please complete or abort current merge first."
                else
                    echo ""
                    interactive_merge
                fi
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                read -p "Enter source branch: " source_branch
                read -p "Enter target branch (default: $current_branch): " target_branch
                target_branch="${target_branch:-$current_branch}"
                
                if [[ -n "$source_branch" ]]; then
                    show_merge_preview "$source_branch" "$target_branch"
                else
                    echo "Source branch name is required"
                fi
                read -p "Press Enter to continue..."
                ;;
            3)
                if detect_merge_conflicts; then
                    echo ""
                    resolve_conflicts_interactively
                else
                    echo "No conflicts to resolve"
                fi
                read -p "Press Enter to continue..."
                ;;
            4)
                if [[ -f ".git/MERGE_HEAD" ]]; then
                    echo ""
                    complete_merge_after_conflicts
                else
                    echo "No merge in progress"
                fi
                read -p "Press Enter to continue..."
                ;;
            5)
                if [[ -f ".git/MERGE_HEAD" ]]; then
                    echo ""
                    read -p "Are you sure you want to abort the merge? (y/N): " confirm
                    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                        if git merge --abort; then
                            echo "Merge aborted successfully"
                        else
                            echo "Failed to abort merge"
                        fi
                    fi
                else
                    echo "No merge in progress"
                fi
                read -p "Press Enter to continue..."
                ;;
            b|B)
                return 0
                ;;
            *)
                echo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Remote synchronization submenu
show_remote_menu() {
    while true; do
        clear
        echo -e "${WHITE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${WHITE}║                   Remote Synchronization                    ║${NC}"
        echo -e "${WHITE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        local current_branch
        current_branch=$(get_current_branch 2>/dev/null || echo "unknown")
        echo -e "${CYAN}Current Branch:${NC} ${GREEN}$current_branch${NC}"
        
        if [[ "$current_branch" != "unknown" ]] && has_upstream "$current_branch"; then
            local upstream sync_status
            upstream=$(get_upstream_branch "$current_branch")
            sync_status=$(get_branch_sync_status "$current_branch")
            echo -e "${CYAN}Upstream:${NC} $upstream"
            echo -e "${CYAN}Sync Status:${NC} $sync_status"
        else
            echo -e "${CYAN}Upstream:${NC} ${YELLOW}Not configured${NC}"
        fi
        
        echo ""
        
        echo -e "${WHITE}Remote Operations:${NC}"
        echo ""
        echo -e " ${CYAN}1.${NC} Sync current branch with upstream"
        echo -e " ${CYAN}2.${NC} Fetch from all remotes"
        echo -e " ${CYAN}3.${NC} Manage upstream tracking"
        echo -e " ${CYAN}4.${NC} Show remote status"
        echo -e " ${CYAN}5.${NC} Handle sync conflicts"
        echo ""
        echo -e " ${CYAN}b.${NC} Back to main menu"
        echo ""
        
        choice=$(read_menu_choice "Select option: ") || return 1
        
        case $choice in
            1)
                if [[ "$current_branch" != "unknown" ]]; then
                    echo ""
                    sync_with_upstream "$current_branch"
                else
                    echo "Unable to determine current branch"
                fi
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                fetch_remote_changes
                read -p "Press Enter to continue..."
                ;;
            3)
                echo ""
                manage_upstream_tracking
                ;;
            4)
                echo ""
                get_remote_status
                read -p "Press Enter to continue..."
                ;;
            5)
                if [[ "$current_branch" != "unknown" ]]; then
                    local sync_status
                    sync_status=$(get_branch_sync_status "$current_branch")
                    if [[ "$sync_status" == "diverged" ]]; then
                        echo ""
                        handle_sync_conflicts "$current_branch"
                    else
                        echo "No sync conflicts detected"
                    fi
                else
                    echo "Unable to determine current branch"
                fi
                read -p "Press Enter to continue..."
                ;;
            b|B)
                return 0
                ;;
            *)
                echo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Status and information submenu
show_status_menu() {
    while true; do
        clear
        echo -e "${WHITE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${WHITE}║                    Repository Status                        ║${NC}"
        echo -e "${WHITE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${WHITE}Status & Information:${NC}"
        echo ""
        echo -e " ${CYAN}1.${NC} Show branch status (current)"
        echo -e " ${CYAN}2.${NC} Show all branches status"
        echo -e " ${CYAN}3.${NC} Repository health check"
        echo -e " ${CYAN}4.${NC} Working tree status"
        echo -e " ${CYAN}5.${NC} Remote repositories info"
        echo -e " ${CYAN}6.${NC} Recent operations log"
        echo ""
        echo -e " ${CYAN}b.${NC} Back to main menu"
        echo ""
        
        choice=$(read_menu_choice "Select option: ") || return 1
        
        case $choice in
            1)
                echo ""
                show_branch_status "false"
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                show_branch_status "true"
                read -p "Press Enter to continue..."
                ;;
            3)
                echo ""
                validate_repository_state
                read -p "Press Enter to continue..."
                ;;
            4)
                echo ""
                if validate_clean_working_tree; then
                    echo -e "${GREEN}Working tree is clean${NC}"
                else
                    echo "Working tree status:"
                    get_working_tree_status
                fi
                read -p "Press Enter to continue..."
                ;;
            5)
                echo ""
                get_remote_status
                read -p "Press Enter to continue..."
                ;;
            6)
                echo ""
                echo -e "${WHITE}Recent Operations:${NC}"
                if [[ -f "$LOG_DIR/operations.log" ]]; then
                    tail -20 "$LOG_DIR/operations.log" | while IFS='|' read -r timestamp operation branch status details; do
                        echo -e "${CYAN}$timestamp${NC} - $operation on ${GREEN}$branch${NC}: $status"
                        if [[ -n "$details" ]]; then
                            echo -e "  ${PURPLE}$details${NC}"
                        fi
                    done
                else
                    echo "No operations log found"
                fi
                read -p "Press Enter to continue..."
                ;;
            b|B)
                return 0
                ;;
            *)
                echo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Cleanup operations submenu
show_cleanup_menu() {
    while true; do
        clear
        echo -e "${WHITE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${WHITE}║                    Cleanup Operations                       ║${NC}"
        echo -e "${WHITE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${WHITE}Cleanup Operations:${NC}"
        echo ""
        echo -e " ${CYAN}1.${NC} Clean up merged branches"
        echo -e " ${CYAN}2.${NC} Manage backups"
        echo -e " ${CYAN}3.${NC} Manage rollback points"
        echo -e " ${CYAN}4.${NC} Logging and audit trail"
        echo -e " ${CYAN}5.${NC} Clean up old backups"
        echo -e " ${CYAN}6.${NC} Repository maintenance"
        echo ""
        echo -e " ${CYAN}b.${NC} Back to main menu"
        echo ""
        
        choice=$(read_menu_choice "Select option: ") || return 1
        
        case $choice in
            1)
                echo ""
                local target_branch="${CONFIG[DEFAULT_BASE_BRANCH]}"
                read -p "Enter target branch (default: $target_branch): " input_branch
                target_branch="${input_branch:-$target_branch}"
                cleanup_merged_branches "$target_branch"
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                manage_backups
                ;;
            3)
                echo ""
                manage_rollbacks
                ;;
            4)
                echo ""
                manage_logs_and_audit
                ;;
            5)
                echo ""
                cleanup_old_backups
                read -p "Press Enter to continue..."
                ;;
            6)
                echo ""
                echo "Running repository maintenance..."
                git gc --auto
                echo "Repository maintenance completed"
                read -p "Press Enter to continue..."
                ;;
            b|B)
                return 0
                ;;
            *)
                echo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Configuration submenu
show_config_menu() {
    while true; do
        clear
        echo -e "${WHITE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${WHITE}║                      Configuration                          ║${NC}"
        echo -e "${WHITE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${WHITE}Configuration Options:${NC}"
        echo ""
        echo -e " ${CYAN}1.${NC} View current configuration"
        echo -e " ${CYAN}2.${NC} Edit configuration file"
        echo -e " ${CYAN}3.${NC} Reset to defaults"
        echo -e " ${CYAN}4.${NC} Workflow patterns"
        echo ""
        echo -e " ${CYAN}b.${NC} Back to main menu"
        echo ""
        
        choice=$(read_menu_choice "Select option: ") || return 1
        
        case $choice in
            1)
                echo ""
                show_configuration
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                echo "Opening configuration file: $CONFIG_FILE"
                if command -v "${CONFIG[CONFLICT_RESOLUTION_TOOL]%% *}" >/dev/null 2>&1; then
                    eval "${CONFIG[CONFLICT_RESOLUTION_TOOL]} \"$CONFIG_FILE\""
                else
                    echo "Default editor not available. Configuration file location:"
                    echo "$CONFIG_FILE"
                fi
                read -p "Press Enter to continue..."
                ;;
            3)
                echo ""
                read -p "Reset configuration to defaults? (y/N): " confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    create_default_config
                    load_configuration
                    echo "Configuration reset to defaults"
                fi
                read -p "Press Enter to continue..."
                ;;
            4)
                echo ""
                echo -e "${WHITE}Available Workflow Patterns:${NC}"
                for pattern in "${!WORKFLOW_PATTERNS[@]}"; do
                    echo -e "${CYAN}$pattern${NC}: ${WORKFLOW_PATTERNS[$pattern]}"
                done
                echo ""
                echo -e "Current workflow: ${GREEN}${CONFIG[DEFAULT_WORKFLOW]}${NC}"
                read -p "Press Enter to continue..."
                ;;
            b|B)
                return 0
                ;;
            *)
                echo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Help and information submenu
show_help_menu() {
    while true; do
        clear
        echo -e "${WHITE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${WHITE}║                    Help & Information                       ║${NC}"
        echo -e "${WHITE}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        echo -e "${WHITE}Help Options:${NC}"
        echo ""
        echo -e " ${CYAN}1.${NC} Command line usage"
        echo -e " ${CYAN}2.${NC} Workflow examples"
        echo -e " ${CYAN}3.${NC} Troubleshooting guide"
        echo -e " ${CYAN}4.${NC} Command reference"
        echo -e " ${CYAN}5.${NC} About Branch Manager"
        echo ""
        echo -e " ${CYAN}b.${NC} Back to main menu"
        echo ""
        
        choice=$(read_menu_choice "Select option: ") || return 1
        
        case $choice in
            1)
                echo ""
                show_usage
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                show_workflow_examples
                read -p "Press Enter to continue..."
                ;;
            3)
                echo ""
                show_troubleshooting_guide
                read -p "Press Enter to continue..."
                ;;
            4)
                echo ""
                show_command_reference
                read -p "Press Enter to continue..."
                ;;
            5)
                echo ""
                show_version
                echo ""
                echo -e "${WHITE}Git Branch Manager${NC}"
                echo "A comprehensive branch management system for safe Git operations"
                echo ""
                echo -e "${CYAN}Features:${NC}"
                echo "• Safe branch creation and switching"
                echo "• Intelligent merge operations with conflict resolution"
                echo "• Remote synchronization and upstream tracking"
                echo "• Automated cleanup and maintenance"
                echo "• Interactive user interface"
                echo "• Comprehensive backup and recovery system"
                echo "• Advanced error handling and recovery"
                echo "• Detailed operation logging and audit trail"
                echo "• Workflow management and GitHub integration"
                read -p "Press Enter to continue..."
                ;;
            b|B)
                return 0
                ;;
            *)
                echo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Helper function for menu input
read_menu_choice() {
    local prompt="$1"
    local choice
    
    if [[ -t 0 ]]; then
        # Interactive mode (TTY available)
        read -p "$prompt" choice
    else
        # Non-interactive mode (no TTY)
        read -t 5 -p "$prompt" choice || {
            echo ""
            echo "No input received, exiting..."
            return 1
        }
    fi
    
    echo "$choice"
}

# Main interactive interface
run_interactive_interface() {
    while true; do
        show_main_menu
        echo ""
        choice=$(read_menu_choice "Select option: ") || return 1
        
        # Handle empty input
        if [[ -z "$choice" ]]; then
            echo "No option selected. Please try again."
            sleep 1
            continue
        fi
        
        case $choice in
            1)
                show_branch_menu
                ;;
            2)
                show_merge_menu
                ;;
            3)
                show_remote_menu
                ;;
            4)
                show_status_menu
                ;;
            5)
                echo ""
                interactive_push
                read -p "Press Enter to continue..."
                ;;
            6)
                show_cleanup_menu
                ;;
            7)
                show_config_menu
                ;;
            8)
                show_help_menu
                ;;
            q|Q)
                echo ""
                echo -e "${GREEN}Thank you for using Git Branch Manager!${NC}"
                exit 0
                ;;
            *)
                echo "Invalid option. Please try again."
                sleep 1
                ;;
        esac
    done
}

# Helper functions for help system

# Show comprehensive workflow examples
show_workflow_examples() {
    echo -e "${WHITE}Comprehensive Workflow Examples${NC}"
    echo "==============================="
    echo ""
    
    echo -e "${CYAN}1. GitHub Flow - Feature Development:${NC}"
    echo "   # Create feature branch"
    echo "   ./branch_manager.sh create feature/user-authentication"
    echo "   "
    echo "   # Work on feature, make commits"
    echo "   git add ."
    echo "   git commit -m 'Add user authentication'"
    echo "   "
    echo "   # Sync and merge when ready"
    echo "   ./branch_manager.sh sync"
    echo "   ./branch_manager.sh merge feature/user-authentication main"
    echo "   ./branch_manager.sh cleanup"
    echo ""
    
    echo -e "${CYAN}2. GitFlow - Release Workflow:${NC}"
    echo "   # Create feature from develop"
    echo "   ./branch_manager.sh create feature/shopping-cart develop"
    echo "   "
    echo "   # Complete feature and merge to develop"
    echo "   ./branch_manager.sh merge feature/shopping-cart develop"
    echo "   "
    echo "   # Create release branch"
    echo "   ./branch_manager.sh create release/v1.2.0 develop"
    echo "   "
    echo "   # Merge release to main and develop"
    echo "   ./branch_manager.sh merge release/v1.2.0 main"
    echo "   ./branch_manager.sh merge release/v1.2.0 develop"
    echo ""
    
    echo -e "${CYAN}3. Hotfix Workflow:${NC}"
    echo "   # Create hotfix from main"
    echo "   ./branch_manager.sh create hotfix/security-patch main"
    echo "   "
    echo "   # Fix issue and test"
    echo "   git add ."
    echo "   git commit -m 'Fix security vulnerability'"
    echo "   "
    echo "   # Merge to main and develop"
    echo "   ./branch_manager.sh merge hotfix/security-patch main"
    echo "   ./branch_manager.sh merge hotfix/security-patch develop"
    echo ""
    
    echo -e "${CYAN}4. Collaboration Workflow:${NC}"
    echo "   # Sync before starting work"
    echo "   ./branch_manager.sh sync"
    echo "   ./branch_manager.sh switch main"
    echo "   "
    echo "   # Create feature branch"
    echo "   ./branch_manager.sh create feature/api-integration"
    echo "   "
    echo "   # Regular sync during development"
    echo "   ./branch_manager.sh sync main"
    echo "   ./branch_manager.sh merge main feature/api-integration"
    echo "   "
    echo "   # Final merge and push"
    echo "   ./branch_manager.sh workflow merge-and-push feature/api-integration main"
    echo ""
    
    echo -e "${CYAN}5. Conflict Resolution Workflow:${NC}"
    echo "   # Attempt merge"
    echo "   ./branch_manager.sh merge feature/branch main"
    echo "   "
    echo "   # If conflicts occur, use interactive resolution"
    echo "   ./branch_manager.sh  # Interactive mode"
    echo "   # Navigate to: Merge Operations → Resolve conflicts"
    echo "   "
    echo "   # Or use command line"
    echo "   git status  # See conflicted files"
    echo "   # Edit files to resolve conflicts"
    echo "   git add ."
    echo "   git commit -m 'Resolve merge conflicts'"
    echo ""
    
    echo -e "${CYAN}6. Advanced Operations:${NC}"
    echo "   # Workflow-based branch creation"
    echo "   ./branch_manager.sh create --workflow-type=feature user-dashboard"
    echo "   "
    echo "   # Complete feature workflow (merge + cleanup + push)"
    echo "   ./branch_manager.sh workflow complete-feature"
    echo "   "
    echo "   # Status with all details"
    echo "   ./branch_manager.sh status --all --verbose --remote"
    echo "   "
    echo "   # Cleanup with dry run"
    echo "   ./branch_manager.sh cleanup --dry-run"
    echo ""
    
    echo -e "${CYAN}7. Error Recovery:${NC}"
    echo "   # Create rollback point before risky operation"
    echo "   ./branch_manager.sh  # Interactive mode"
    echo "   # Navigate to: Cleanup Operations → Manage rollback points → Create rollback point"
    echo "   "
    echo "   # If something goes wrong, restore"
    echo "   # Navigate to: Cleanup Operations → Manage rollback points → Execute rollback"
    echo "   "
    echo "   # Generate troubleshooting report"
    echo "   # Navigate to: Cleanup Operations → Logging and audit trail → Generate troubleshooting report"
}

# Show comprehensive troubleshooting guide
show_troubleshooting_guide() {
    echo -e "${WHITE}Comprehensive Troubleshooting Guide${NC}"
    echo "==================================="
    echo ""
    
    echo -e "${CYAN}Common Issues and Detailed Solutions:${NC}"
    echo ""
    
    echo -e "${YELLOW}1. Working Tree Issues:${NC}"
    echo "   ${RED}Problem:${NC} 'Working tree is not clean' error"
    echo "   ${GREEN}Solutions:${NC}"
    echo "   • Stash changes: git stash push -m 'work in progress'"
    echo "   • Commit changes: git add . && git commit -m 'WIP: temporary commit'"
    echo "   • Use interactive handling: Branch Manager will offer options"
    echo "   • Force operations: Use --no-confirm flag (use with caution)"
    echo ""
    
    echo -e "${YELLOW}2. Merge Conflicts:${NC}"
    echo "   ${RED}Problem:${NC} Conflicts during merge operations"
    echo "   ${GREEN}Solutions:${NC}"
    echo "   • Use interactive conflict resolution: ./branch_manager.sh → Merge Operations → Resolve conflicts"
    echo "   • Check conflict complexity: Simple conflicts are auto-resolvable"
    echo "   • Manual resolution: Use configured merge tool (${CONFIG[CONFLICT_RESOLUTION_TOOL]})"
    echo "   • Abort merge: git merge --abort if needed"
    echo "   • View conflict details: git status and git diff"
    echo ""
    
    echo -e "${YELLOW}3. Remote Synchronization Issues:${NC}"
    echo "   ${RED}Problem:${NC} Cannot connect to remote or sync failures"
    echo "   ${GREEN}Solutions:${NC}"
    echo "   • Check network: ping github.com"
    echo "   • Verify remote URLs: git remote -v"
    echo "   • Test SSH connection: ssh -T git@github.com"
    echo "   • Update credentials: git config --global credential.helper store"
    echo "   • Check authentication: git config --list | grep user"
    echo "   • Use guided sync: ./branch_manager.sh sync"
    echo ""
    
    echo -e "${YELLOW}4. Branch Operation Failures:${NC}"
    echo "   ${RED}Problem:${NC} Cannot create, switch, or delete branches"
    echo "   ${GREEN}Solutions:${NC}"
    echo "   • Check branch exists: git branch -a"
    echo "   • Verify naming conventions: Use workflow-appropriate prefixes"
    echo "   • Ensure base branch exists: ./branch_manager.sh status --all"
    echo "   • Check permissions: ls -la .git/"
    echo "   • Repository integrity: git fsck"
    echo ""
    
    echo -e "${YELLOW}5. Authentication Problems:${NC}"
    echo "   ${RED}Problem:${NC} Permission denied or authentication failures"
    echo "   ${GREEN}Solutions:${NC}"
    echo "   • SSH key setup: ssh-keygen -t ed25519 -C 'your_email@example.com'"
    echo "   • Add SSH key to GitHub: cat ~/.ssh/id_ed25519.pub"
    echo "   • Personal access token: Use token instead of password"
    echo "   • HTTPS to SSH: git remote set-url origin git@github.com:user/repo.git"
    echo "   • Test connection: ssh -T git@github.com"
    echo ""
    
    echo -e "${YELLOW}6. Repository Corruption:${NC}"
    echo "   ${RED}Problem:${NC} Git repository integrity issues"
    echo "   ${GREEN}Solutions:${NC}"
    echo "   • Check integrity: git fsck --full"
    echo "   • Repair repository: git gc --prune=now"
    echo "   • Restore from backup: Use rollback points"
    echo "   • Clone fresh copy: git clone <repository-url> if severely corrupted"
    echo "   • Check disk space: df -h"
    echo ""
    
    echo -e "${YELLOW}7. Performance Issues:${NC}"
    echo "   ${RED}Problem:${NC} Slow operations or hanging"
    echo "   ${GREEN}Solutions:${NC}"
    echo "   • Enable debug mode: ./branch_manager.sh --debug"
    echo "   • Check network speed: Test remote connectivity"
    echo "   • Repository size: Large repos may be slower"
    echo "   • Clean up: ./branch_manager.sh cleanup"
    echo "   • Log rotation: Cleanup old logs"
    echo ""
    
    echo -e "${CYAN}Diagnostic Tools:${NC}"
    echo "================"
    echo "• Generate troubleshooting report: Interactive menu → Cleanup → Logging → Generate report"
    echo "• View operation statistics: Interactive menu → Cleanup → Logging → Show statistics"
    echo "• Enable debug mode: ./branch_manager.sh --debug"
    echo "• Check recent operations: Interactive menu → Cleanup → Logging → View recent operations"
    echo ""
    
    echo -e "${CYAN}Recovery Options:${NC}"
    echo "================"
    echo "• Rollback points: Interactive menu → Cleanup → Manage rollback points"
    echo "• Backup system: Interactive menu → Cleanup → Manage backups"
    echo "• Operation logs: $LOG_DIR/operations.log"
    echo "• Configuration reset: Interactive menu → Configuration → Reset to defaults"
    echo ""
    
    echo -e "${CYAN}Getting Help:${NC}"
    echo "============="
    echo "• Built-in help: ./branch_manager.sh help"
    echo "• Interactive guide: ./branch_manager.sh → Help & Information"
    echo "• Workflow examples: ./branch_manager.sh → Help & Information → Workflow examples"
    echo "• Configuration reference: ./branch_manager.sh config"
    echo ""
    
    echo -e "${CYAN}Log File Locations:${NC}"
    echo "==================="
    echo "• Main log: $LOG_FILE"
    echo "• Operations log: $LOG_DIR/operations.log"
    echo "• Daily logs: $LOG_DIR/operations_YYYYMMDD.log"
    echo "• Configuration: $CONFIG_FILE"
    echo "• Backups: $BACKUP_DIR"
    echo "• Statistics: $LOG_DIR/operation_stats.txt"
}

# =============================================================================
# WORKFLOW MANAGEMENT AND INTEGRATION
# =============================================================================

# Workflow pattern support

# Get workflow-specific branch prefixes
get_workflow_prefixes() {
    local workflow="${1:-${CONFIG[DEFAULT_WORKFLOW]}}"
    echo "${WORKFLOW_PATTERNS[$workflow]}"
}

# Validate branch name against workflow
validate_workflow_branch_name() {
    local branch_name="$1"
    local workflow="${2:-${CONFIG[DEFAULT_WORKFLOW]}}"
    
    local prefixes
    prefixes=$(get_workflow_prefixes "$workflow")
    
    IFS=',' read -ra prefix_array <<< "$prefixes"
    for prefix in "${prefix_array[@]}"; do
        if [[ "$branch_name" == $prefix* ]]; then
            return 0  # Valid for workflow
        fi
    done
    
    return 1  # Invalid for workflow
}

# Get workflow-specific guidance
get_workflow_guidance() {
    local workflow="${1:-${CONFIG[DEFAULT_WORKFLOW]}}"
    local operation="${2:-general}"
    
    case "$workflow" in
        "github-flow")
            case "$operation" in
                "create")
                    echo "GitHub Flow: Create feature branches from main, use descriptive names"
                    echo "Recommended prefixes: feature/, hotfix/"
                    echo "Example: feature/user-authentication, hotfix/login-bug"
                    ;;
                "merge")
                    echo "GitHub Flow: Merge feature branches into main via pull requests"
                    echo "Always merge into main branch for deployment"
                    ;;
                "general")
                    echo "GitHub Flow: Simple workflow with main branch and feature branches"
                    echo "• Create feature branches from main"
                    echo "• Merge back to main when ready"
                    echo "• Deploy from main branch"
                    ;;
            esac
            ;;
        "gitflow")
            case "$operation" in
                "create")
                    echo "GitFlow: Use specific branch types for different purposes"
                    echo "• feature/ - New features (from develop)"
                    echo "• release/ - Release preparation (from develop)"
                    echo "• hotfix/ - Critical fixes (from main)"
                    echo "• develop/ - Integration branch"
                    ;;
                "merge")
                    echo "GitFlow: Merge according to branch type"
                    echo "• Features merge to develop"
                    echo "• Releases merge to main and develop"
                    echo "• Hotfixes merge to main and develop"
                    ;;
                "general")
                    echo "GitFlow: Structured workflow with main, develop, and feature branches"
                    echo "• main: Production-ready code"
                    echo "• develop: Integration branch"
                    echo "• feature/: New features"
                    echo "• release/: Release preparation"
                    echo "• hotfix/: Critical fixes"
                    ;;
            esac
            ;;
        "custom")
            case "$operation" in
                "create")
                    echo "Custom Workflow: Use configured prefixes"
                    echo "Configured prefixes: $(get_workflow_prefixes "$workflow")"
                    ;;
                "merge")
                    echo "Custom Workflow: Follow your team's merge conventions"
                    ;;
                "general")
                    echo "Custom Workflow: Using team-specific branch naming conventions"
                    echo "Configured prefixes: $(get_workflow_prefixes "$workflow")"
                    ;;
            esac
            ;;
    esac
}

# Suggest branch name based on workflow
suggest_branch_name() {
    local workflow="${1:-${CONFIG[DEFAULT_WORKFLOW]}}"
    local branch_type="${2:-feature}"
    local description="${3:-new-feature}"
    
    # Clean description (remove spaces, special chars)
    description=$(echo "$description" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    
    case "$workflow" in
        "github-flow")
            case "$branch_type" in
                "feature"|"feat") echo "feature/$description" ;;
                "hotfix"|"fix") echo "hotfix/$description" ;;
                *) echo "feature/$description" ;;
            esac
            ;;
        "gitflow")
            case "$branch_type" in
                "feature"|"feat") echo "feature/$description" ;;
                "release"|"rel") echo "release/$description" ;;
                "hotfix"|"fix") echo "hotfix/$description" ;;
                "develop"|"dev") echo "develop/$description" ;;
                *) echo "feature/$description" ;;
            esac
            ;;
        "custom")
            local prefixes
            prefixes=$(get_workflow_prefixes "$workflow")
            local first_prefix
            first_prefix=$(echo "$prefixes" | cut -d',' -f1)
            echo "${first_prefix}$description"
            ;;
    esac
}

# Validate workflow operation
validate_workflow_operation() {
    local operation="$1"
    local source_branch="${2:-}"
    local target_branch="${3:-}"
    local workflow="${4:-${CONFIG[DEFAULT_WORKFLOW]}}"
    
    case "$workflow" in
        "github-flow")
            case "$operation" in
                "merge")
                    if [[ "$target_branch" != "main" && "$target_branch" != "master" ]]; then
                        log_warn "GitHub Flow: Consider merging to main branch"
                        echo "GitHub Flow typically merges all features to main"
                        return 1
                    fi
                    ;;
            esac
            ;;
        "gitflow")
            case "$operation" in
                "merge")
                    if [[ "$source_branch" == feature/* ]]; then
                        if [[ "$target_branch" != "develop" ]]; then
                            log_warn "GitFlow: Feature branches should merge to develop"
                            echo "GitFlow: feature/* branches typically merge to develop branch"
                            return 1
                        fi
                    elif [[ "$source_branch" == hotfix/* ]]; then
                        if [[ "$target_branch" != "main" && "$target_branch" != "master" ]]; then
                            log_warn "GitFlow: Hotfix branches should merge to main first"
                            echo "GitFlow: hotfix/* branches should merge to main, then develop"
                            return 1
                        fi
                    elif [[ "$source_branch" == release/* ]]; then
                        if [[ "$target_branch" != "main" && "$target_branch" != "master" ]]; then
                            log_warn "GitFlow: Release branches should merge to main first"
                            echo "GitFlow: release/* branches should merge to main, then develop"
                            return 1
                        fi
                    fi
                    ;;
            esac
            ;;
    esac
    
    return 0
}

# Interactive workflow guidance
show_workflow_guidance() {
    local workflow="${CONFIG[DEFAULT_WORKFLOW]}"
    
    clear
    echo -e "${WHITE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║                    Workflow Guidance                        ║${NC}"
    echo -e "${WHITE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${CYAN}Current Workflow:${NC} ${GREEN}$workflow${NC}"
    echo ""
    
    get_workflow_guidance "$workflow" "general"
    echo ""
    
    echo -e "${WHITE}Branch Naming Examples:${NC}"
    echo "======================="
    local prefixes
    prefixes=$(get_workflow_prefixes "$workflow")
    IFS=',' read -ra prefix_array <<< "$prefixes"
    
    for prefix in "${prefix_array[@]}"; do
        case "$prefix" in
            "feature/")
                echo -e "${CYAN}${prefix}${NC}user-authentication"
                echo -e "${CYAN}${prefix}${NC}shopping-cart"
                echo -e "${CYAN}${prefix}${NC}api-integration"
                ;;
            "hotfix/")
                echo -e "${CYAN}${prefix}${NC}critical-security-fix"
                echo -e "${CYAN}${prefix}${NC}login-bug"
                ;;
            "release/")
                echo -e "${CYAN}${prefix}${NC}v1.2.0"
                echo -e "${CYAN}${prefix}${NC}sprint-15"
                ;;
            "develop/")
                echo -e "${CYAN}${prefix}${NC}integration-branch"
                ;;
            *)
                echo -e "${CYAN}${prefix}${NC}example-branch"
                ;;
        esac
    done
    
    echo ""
    echo -e "${WHITE}Workflow Operations:${NC}"
    echo "==================="
    get_workflow_guidance "$workflow" "create"
    echo ""
    get_workflow_guidance "$workflow" "merge"
}

# Enhanced branch creation with workflow support
create_workflow_branch() {
    local branch_type="$1"
    local description="$2"
    local base_branch="${3:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    local workflow="${CONFIG[DEFAULT_WORKFLOW]}"
    
    if [[ -z "$description" ]]; then
        echo "Branch description is required"
        return 1
    fi
    
    # Generate suggested branch name
    local suggested_name
    suggested_name=$(suggest_branch_name "$workflow" "$branch_type" "$description")
    
    echo -e "${WHITE}Workflow Branch Creation${NC}"
    echo "======================="
    echo -e "${CYAN}Workflow:${NC} $workflow"
    echo -e "${CYAN}Branch Type:${NC} $branch_type"
    echo -e "${CYAN}Description:${NC} $description"
    echo -e "${CYAN}Suggested Name:${NC} ${GREEN}$suggested_name${NC}"
    echo -e "${CYAN}Base Branch:${NC} $base_branch"
    echo ""
    
    # Show workflow guidance
    get_workflow_guidance "$workflow" "create"
    echo ""
    
    read -p "Use suggested name or enter custom name: " custom_name
    local branch_name="${custom_name:-$suggested_name}"
    
    # Validate against workflow
    if ! validate_workflow_branch_name "$branch_name" "$workflow"; then
        echo -e "${YELLOW}Warning: Branch name doesn't follow $workflow conventions${NC}"
        read -p "Continue anyway? (y/N): " continue_anyway
        if [[ "$continue_anyway" != "y" && "$continue_anyway" != "Y" ]]; then
            echo "Branch creation cancelled"
            return 1
        fi
    fi
    
    # Create the branch
    create_branch "$branch_name" "$base_branch"
}

# Enhanced merge with workflow validation
merge_with_workflow_validation() {
    local source_branch="$1"
    local target_branch="${2:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
    local workflow="${CONFIG[DEFAULT_WORKFLOW]}"
    
    echo -e "${WHITE}Workflow Merge Validation${NC}"
    echo "========================"
    echo -e "${CYAN}Workflow:${NC} $workflow"
    echo -e "${CYAN}Source:${NC} $source_branch"
    echo -e "${CYAN}Target:${NC} $target_branch"
    echo ""
    
    # Validate workflow operation
    if ! validate_workflow_operation "merge" "$source_branch" "$target_branch" "$workflow"; then
        echo ""
        read -p "Continue with merge despite workflow concerns? (y/N): " continue_merge
        if [[ "$continue_merge" != "y" && "$continue_merge" != "Y" ]]; then
            echo "Merge cancelled"
            return 1
        fi
    fi
    
    # Show workflow-specific guidance
    get_workflow_guidance "$workflow" "merge"
    echo ""
    
    # Proceed with merge
    merge_branch "$source_branch" "$target_branch"
}

# Command-line argument support

# Parse command-line arguments
parse_arguments() {
    local command="$1"
    shift
    
    # Global options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --debug)
                CONFIG["LOG_LEVEL"]="DEBUG"
                log_debug "Debug logging enabled"
                shift
                ;;
            --no-confirm)
                CONFIG["REQUIRE_CONFIRMATION"]="false"
                log_debug "Confirmation prompts disabled"
                shift
                ;;
            --no-fetch)
                CONFIG["AUTO_FETCH"]="false"
                log_debug "Auto-fetch disabled"
                shift
                ;;
            --workflow=*)
                CONFIG["DEFAULT_WORKFLOW"]="${1#*=}"
                log_debug "Workflow set to: ${CONFIG[DEFAULT_WORKFLOW]}"
                shift
                ;;
            --base=*)
                CONFIG["DEFAULT_BASE_BRANCH"]="${1#*=}"
                log_debug "Base branch set to: ${CONFIG[DEFAULT_BASE_BRANCH]}"
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            -*)
                # Pass through unknown options to command-specific parsing
                break
                ;;
            *)
                # Positional arguments - pass back to main function
                break
                ;;
        esac
    done
    
    # Return remaining arguments
    echo "$@"
}

# Show command-specific help
show_command_help() {
    local command="$1"
    
    case "$command" in
        "create")
            echo "Create Branch Command"
            echo "===================="
            echo ""
            echo "USAGE:"
            echo "    $0 create <branch-name> [base-branch] [options]"
            echo ""
            echo "EXAMPLES:"
            echo "    $0 create feature/user-login"
            echo "    $0 create feature/user-login develop"
            ;;
        "switch")
            cat << EOF
${WHITE}Switch Branch Command${NC}

${CYAN}USAGE:${NC}
    $0 switch <branch-name> [options]

${CYAN}ARGUMENTS:${NC}
    branch-name     Name of the branch to switch to

${CYAN}OPTIONS:${NC}
    --force         Force switch even with uncommitted changes
    --no-confirm    Skip confirmation prompts
    --debug         Enable debug logging

${CYAN}EXAMPLES:${NC}
    $0 switch main
    $0 switch feature/user-login
    $0 switch develop --force
EOF
            ;;
        "merge")
            cat << EOF
${WHITE}Merge Branch Command${NC}

${CYAN}USAGE:${NC}
    $0 merge <source-branch> [target-branch] [options]

${CYAN}ARGUMENTS:${NC}
    source-branch   Branch to merge from
    target-branch   Branch to merge into (default: current branch)

${CYAN}OPTIONS:${NC}
    --strategy=<type>       Merge strategy (auto, fast-forward, merge-commit)
    --no-sync              Skip syncing target branch
    --no-confirm           Skip confirmation prompts
    --workflow-validate    Enable workflow validation
    --debug                Enable debug logging

${CYAN}EXAMPLES:${NC}
    $0 merge feature/user-login
    $0 merge feature/user-login main
    $0 merge hotfix/bug-fix --strategy=fast-forward
    $0 merge feature/new-feature develop --workflow-validate
EOF
            ;;
        "sync")
            cat << EOF
${WHITE}Sync Branch Command${NC}

${CYAN}USAGE:${NC}
    $0 sync [branch-name] [options]

${CYAN}ARGUMENTS:${NC}
    branch-name     Branch to sync (default: current branch)

${CYAN}OPTIONS:${NC}
    --strategy=<type>   Sync strategy (auto, pull, rebase)
    --no-confirm        Skip confirmation prompts
    --debug             Enable debug logging

${CYAN}EXAMPLES:${NC}
    $0 sync
    $0 sync main
    $0 sync feature/branch --strategy=rebase
EOF
            ;;
        "cleanup")
            cat << EOF
${WHITE}Cleanup Branches Command${NC}

${CYAN}USAGE:${NC}
    $0 cleanup [target-branch] [options]

${CYAN}ARGUMENTS:${NC}
    target-branch   Branch to check merges against (default: ${CONFIG[DEFAULT_BASE_BRANCH]})

${CYAN}OPTIONS:${NC}
    --auto          Auto-confirm all deletions
    --dry-run       Show what would be deleted without deleting
    --no-confirm    Skip confirmation prompts
    --debug         Enable debug logging

${CYAN}EXAMPLES:${NC}
    $0 cleanup
    $0 cleanup main
    $0 cleanup develop --auto
    $0 cleanup --dry-run
EOF
            ;;
        "status")
            cat << EOF
${WHITE}Status Command${NC}

${CYAN}USAGE:${NC}
    $0 status [options]

${CYAN}OPTIONS:${NC}
    --all           Show all branches
    --remote        Include remote branch information
    --verbose       Show detailed information
    --debug         Enable debug logging

${CYAN}EXAMPLES:${NC}
    $0 status
    $0 status --all
    $0 status --verbose --remote
EOF
            ;;
        *)
            show_usage
            ;;
    esac
}

# Enhanced create command with argument parsing
create_command() {
    local args
    args=$(parse_arguments "create" "$@")
    eval set -- "$args"
    
    local workflow_type=""
    local branch_name=""
    local base_branch="${CONFIG[DEFAULT_BASE_BRANCH]}"
    local description=""
    
    # Parse create-specific options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --workflow-type=*)
                workflow_type="${1#*=}"
                shift
                ;;
            *)
                if [[ -z "$branch_name" ]]; then
                    branch_name="$1"
                elif [[ -z "$base_branch" || "$base_branch" == "${CONFIG[DEFAULT_BASE_BRANCH]}" ]]; then
                    base_branch="$1"
                fi
                shift
                ;;
        esac
    done
    
    # Handle workflow-based creation
    if [[ -n "$workflow_type" ]]; then
        if [[ -z "$branch_name" ]]; then
            log_error "Description required for workflow-based branch creation"
            show_command_help "create"
            return 1
        fi
        description="$branch_name"
        create_workflow_branch "$workflow_type" "$description" "$base_branch"
    else
        if [[ -z "$branch_name" ]]; then
            interactive_branch_creation
        else
            create_branch "$branch_name" "$base_branch"
        fi
    fi
}

# Enhanced merge command with argument parsing
merge_command() {
    local args
    args=$(parse_arguments "merge" "$@")
    eval set -- "$args"
    
    local source_branch=""
    local target_branch=""
    local merge_strategy="auto"
    local skip_sync="false"
    local workflow_validate="false"
    
    # Parse merge-specific options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --strategy=*)
                merge_strategy="${1#*=}"
                shift
                ;;
            --no-sync)
                skip_sync="true"
                shift
                ;;
            --workflow-validate)
                workflow_validate="true"
                shift
                ;;
            *)
                if [[ -z "$source_branch" ]]; then
                    source_branch="$1"
                elif [[ -z "$target_branch" ]]; then
                    target_branch="$1"
                fi
                shift
                ;;
        esac
    done
    
    if [[ -z "$source_branch" ]]; then
        interactive_merge
        return
    fi
    
    target_branch="${target_branch:-$(get_current_branch)}"
    
    if [[ "$workflow_validate" == "true" ]]; then
        merge_with_workflow_validation "$source_branch" "$target_branch"
    else
        merge_branch "$source_branch" "$target_branch" "$merge_strategy" "$skip_sync"
    fi
}

# Enhanced switch command with argument parsing
switch_command() {
    local args
    args=$(parse_arguments "switch" "$@")
    eval set -- "$args"
    
    local target_branch=""
    local force_switch="false"
    
    # Parse switch-specific options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --force)
                force_switch="true"
                shift
                ;;
            *)
                target_branch="$1"
                shift
                ;;
        esac
    done
    
    if [[ -z "$target_branch" ]]; then
        interactive_branch_switching
    else
        switch_to_branch "$target_branch" "$force_switch"
    fi
}

# Enhanced sync command with argument parsing
sync_command() {
    local args
    args=$(parse_arguments "sync" "$@")
    eval set -- "$args"
    
    local branch_name=""
    local sync_strategy="auto"
    
    # Parse sync-specific options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --strategy=*)
                sync_strategy="${1#*=}"
                shift
                ;;
            *)
                branch_name="$1"
                shift
                ;;
        esac
    done
    
    branch_name="${branch_name:-$(get_current_branch)}"
    
    if [[ -n "$branch_name" ]]; then
        sync_with_upstream "$branch_name" "$sync_strategy"
    else
        log_error "Unable to determine branch for sync"
        return 1
    fi
}

# Enhanced cleanup command with argument parsing
cleanup_command() {
    local args
    args=$(parse_arguments "cleanup" "$@")
    eval set -- "$args"
    
    local target_branch="${CONFIG[DEFAULT_BASE_BRANCH]}"
    local auto_confirm="false"
    local dry_run="false"
    
    # Parse cleanup-specific options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --auto)
                auto_confirm="true"
                shift
                ;;
            --dry-run)
                dry_run="true"
                shift
                ;;
            *)
                target_branch="$1"
                shift
                ;;
        esac
    done
    
    if [[ "$dry_run" == "true" ]]; then
        echo -e "${WHITE}Dry Run: Branches that would be deleted:${NC}"
        get_merged_branches "$target_branch"
    else
        cleanup_merged_branches "$target_branch" "$auto_confirm"
    fi
}

# Enhanced status command with argument parsing
status_command() {
    local args
    args=$(parse_arguments "status" "$@")
    eval set -- "$args"
    
    local show_all="false"
    local show_remote="false"
    local verbose="false"
    
    # Parse status-specific options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all)
                show_all="true"
                shift
                ;;
            --remote)
                show_remote="true"
                shift
                ;;
            --verbose)
                verbose="true"
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    
    show_branch_status "$show_all"
    
    if [[ "$show_remote" == "true" ]]; then
        echo ""
        get_remote_status
    fi
    
    if [[ "$verbose" == "true" ]]; then
        echo ""
        echo -e "${WHITE}Repository Health:${NC}"
        validate_repository_state
    fi
}

# Integration with existing push script

# Enhanced push_to_github.sh integration
enhanced_push_integration() {
    local target_branch="${1:-$(get_current_branch)}"
    local push_script_path="${2:-./push_to_github.sh}"
    local auto_push="${3:-false}"
    
    log_info "Integrating with push_to_github.sh..."
    
    # Check if push script exists and is executable
    if [[ ! -f "$push_script_path" ]]; then
        log_warn "Push script not found at: $push_script_path"
        
        # Look for push script in common locations
        local common_paths=("./push_to_github.sh" "../push_to_github.sh" "~/push_to_github.sh")
        local found_script=""
        
        for path in "${common_paths[@]}"; do
            if [[ -f "$path" ]]; then
                found_script="$path"
                log_info "Found push script at: $path"
                break
            fi
        done
        
        if [[ -z "$found_script" ]]; then
            log_error "push_to_github.sh script not found in common locations"
            return 1
        fi
        
        push_script_path="$found_script"
    fi
    
    if [[ ! -x "$push_script_path" ]]; then
        log_warn "Push script is not executable, attempting to make it executable..."
        if chmod +x "$push_script_path"; then
            log_info "Made push script executable"
        else
            log_error "Failed to make push script executable"
            return 1
        fi
    fi
    
    # Show integration summary
    echo -e "${WHITE}Push Integration Summary${NC}"
    echo "======================="
    echo -e "${CYAN}Branch:${NC} $target_branch"
    echo -e "${CYAN}Push Script:${NC} $push_script_path"
    
    # Check branch status before pushing
    if has_upstream "$target_branch"; then
        local sync_status
        sync_status=$(get_branch_sync_status "$target_branch")
        echo -e "${CYAN}Sync Status:${NC} $sync_status"
        
        case "$sync_status" in
            "behind"|"diverged")
                echo -e "${YELLOW}Warning: Branch is not up to date with upstream${NC}"
                if [[ "$auto_push" == "false" ]]; then
                    read -p "Sync with upstream before pushing? (Y/n): " sync_first
                    if [[ "$sync_first" != "n" && "$sync_first" != "N" ]]; then
                        if ! sync_with_upstream "$target_branch"; then
                            log_error "Failed to sync with upstream"
                            return 1
                        fi
                    fi
                fi
                ;;
        esac
    fi
    
    # Show commits to be pushed
    if has_upstream "$target_branch"; then
        local upstream ahead_count
        upstream=$(get_upstream_branch "$target_branch")
        ahead_count=$(git rev-list --count "$upstream..$target_branch" 2>/dev/null || echo "0")
        
        echo -e "${CYAN}Commits to push:${NC} $ahead_count"
        
        if [[ "$ahead_count" -gt 0 ]]; then
            echo ""
            echo -e "${WHITE}Recent commits:${NC}"
            git log --oneline "$upstream..$target_branch" | head -5
            
            if [[ "$ahead_count" -gt 5 ]]; then
                echo "... and $((ahead_count - 5)) more commits"
            fi
        fi
    fi
    
    echo ""
    
    # Confirm push operation
    if [[ "$auto_push" == "false" && "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
        read -p "Proceed with push to GitHub? (Y/n): " confirm_push
        if [[ "$confirm_push" == "n" || "$confirm_push" == "N" ]]; then
            log_info "Push cancelled by user"
            return 1
        fi
    fi
    
    # Create backup before pushing
    local backup_id
    backup_id=$(create_safety_backup "PUSH_TO_GITHUB")
    
    # Execute push script with error handling
    log_info "Executing push script: $push_script_path"
    
    # Capture push script output
    local push_output push_exit_code
    push_output=$("$push_script_path" 2>&1)
    push_exit_code=$?
    
    if [[ $push_exit_code -eq 0 ]]; then
        log_info "Push to GitHub completed successfully"
        log_operation "PUSH_TO_GITHUB" "$target_branch" "SUCCESS" "Via $push_script_path"
        
        echo -e "\n${GREEN}✓ Successfully pushed to GitHub!${NC}"
        
        # Show push script output if it contains useful information
        if [[ -n "$push_output" ]]; then
            echo ""
            echo -e "${WHITE}Push Script Output:${NC}"
            echo "$push_output"
        fi
        
        return 0
    else
        log_error "Push to GitHub failed with exit code: $push_exit_code"
        log_operation "PUSH_TO_GITHUB" "$target_branch" "FAILED" "Exit code: $push_exit_code"
        
        echo -e "\n${RED}✗ Push to GitHub failed${NC}"
        
        # Show error output
        if [[ -n "$push_output" ]]; then
            echo ""
            echo -e "${WHITE}Error Output:${NC}"
            echo "$push_output"
        fi
        
        # Offer recovery options
        echo ""
        echo "Recovery options:"
        echo "1. Check network connectivity and credentials"
        echo "2. Verify remote repository URL"
        echo "3. Try manual push: git push origin $target_branch"
        echo "4. Restore from backup if needed"
        
        if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
            read -p "Restore from backup? (y/N): " restore_backup
            if [[ "$restore_backup" == "y" || "$restore_backup" == "Y" ]]; then
                restore_from_backup "$backup_id"
            fi
        fi
        
        return 1
    fi
}

# Shared configuration with push script
setup_shared_configuration() {
    local push_script_config="./push_config.sh"
    
    # Create shared configuration file if it doesn't exist
    if [[ ! -f "$push_script_config" ]]; then
        log_info "Creating shared configuration file: $push_script_config"
        
        cat > "$push_script_config" << EOF
#!/bin/bash
# Shared configuration between branch_manager.sh and push_to_github.sh

# Repository settings
DEFAULT_BRANCH="${CONFIG[DEFAULT_BASE_BRANCH]}"
AUTO_FETCH="${CONFIG[AUTO_FETCH]}"
REQUIRE_CONFIRMATION="${CONFIG[REQUIRE_CONFIRMATION]}"

# Logging settings
LOG_LEVEL="${CONFIG[LOG_LEVEL]}"
LOG_DIR="$LOG_DIR"

# Backup settings
BACKUP_DIR="$BACKUP_DIR"
BACKUP_RETENTION_DAYS="${CONFIG[BACKUP_RETENTION_DAYS]}"

# Workflow settings
DEFAULT_WORKFLOW="${CONFIG[DEFAULT_WORKFLOW]}"

# Export for use by other scripts
export DEFAULT_BRANCH AUTO_FETCH REQUIRE_CONFIRMATION
export LOG_LEVEL LOG_DIR BACKUP_DIR BACKUP_RETENTION_DAYS
export DEFAULT_WORKFLOW
EOF
        
        chmod +x "$push_script_config"
        log_info "Shared configuration created successfully"
    else
        log_debug "Shared configuration file already exists"
    fi
}

# Seamless workflow integration
complete_workflow_integration() {
    local operation="$1"
    local source_branch="$2"
    local target_branch="${3:-$(get_current_branch)}"
    
    case "$operation" in
        "merge")
            echo -e "\n${WHITE}Complete Merge Workflow${NC}"
            echo "======================="
            
            # 1. Perform merge
            if merge_branch "$source_branch" "$target_branch"; then
                echo -e "${GREEN}✓ Merge completed successfully${NC}"
                
                # 2. Post-merge cleanup
                if [[ "${CONFIG[AUTO_CLEANUP_MERGED]}" == "true" ]]; then
                    echo ""
                    echo "Performing post-merge cleanup..."
                    if is_branch_safe_to_delete "$source_branch" "$target_branch"; then
                        delete_merged_branch "$source_branch" "false" "$target_branch"
                    fi
                fi
                
                # 3. Push to GitHub
                echo ""
                read -p "Push merged changes to GitHub? (Y/n): " push_changes
                if [[ "$push_changes" != "n" && "$push_changes" != "N" ]]; then
                    enhanced_push_integration "$target_branch"
                fi
                
                echo -e "\n${GREEN}✓ Complete merge workflow finished!${NC}"
                return 0
            else
                echo -e "${RED}✗ Merge failed${NC}"
                return 1
            fi
            ;;
        "feature-complete")
            echo -e "\n${WHITE}Feature Completion Workflow${NC}"
            echo "=========================="
            
            # Complete feature development workflow
            local current_branch
            current_branch=$(get_current_branch)
            
            # 1. Sync current branch
            echo "1. Syncing feature branch with upstream..."
            if has_upstream "$current_branch"; then
                sync_with_upstream "$current_branch"
            fi
            
            # 2. Switch to target branch and sync
            echo "2. Preparing target branch..."
            if switch_to_branch "$target_branch"; then
                if has_upstream "$target_branch"; then
                    sync_with_upstream "$target_branch"
                fi
                
                # 3. Merge feature branch
                echo "3. Merging feature branch..."
                if merge_branch "$current_branch" "$target_branch"; then
                    
                    # 4. Cleanup
                    echo "4. Cleaning up merged branch..."
                    if is_branch_safe_to_delete "$current_branch" "$target_branch"; then
                        delete_merged_branch "$current_branch" "false" "$target_branch"
                    fi
                    
                    # 5. Push to GitHub
                    echo "5. Pushing to GitHub..."
                    enhanced_push_integration "$target_branch"
                    
                    echo -e "\n${GREEN}✓ Feature completion workflow finished!${NC}"
                    return 0
                fi
            fi
            
            echo -e "${RED}✗ Feature completion workflow failed${NC}"
            return 1
            ;;
    esac
}

# Add workflow integration commands
workflow_command() {
    local workflow_type="$1"
    shift
    
    case "$workflow_type" in
        "complete-feature")
            local target_branch="${1:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
            complete_workflow_integration "feature-complete" "" "$target_branch"
            ;;
        "merge-and-push")
            local source_branch="$1"
            local target_branch="${2:-${CONFIG[DEFAULT_BASE_BRANCH]}}"
            complete_workflow_integration "merge" "$source_branch" "$target_branch"
            ;;
        "setup-config")
            setup_shared_configuration
            ;;
        *)
            echo "Unknown workflow command: $workflow_type"
            echo "Available commands: complete-feature, merge-and-push, setup-config"
            return 1
            ;;
    esac
}

# =============================================================================
# ERROR HANDLING AND RECOVERY SYSTEM
# =============================================================================

# Error detection and categorization

# Error categories
declare -A ERROR_CATEGORIES=(
    ["GIT_COMMAND"]="Git command execution failed"
    ["NETWORK"]="Network or remote repository issue"
    ["PERMISSION"]="File system permission issue"
    ["REPOSITORY"]="Repository state or integrity issue"
    ["USER_INPUT"]="Invalid user input or configuration"
    ["SYSTEM"]="System or environment issue"
    ["CONFLICT"]="Merge or rebase conflict"
    ["AUTHENTICATION"]="Authentication or credential issue"
)

# Detect and categorize Git operation errors
categorize_git_error() {
    local exit_code="$1"
    local command="$2"
    local error_output="$3"
    
    log_debug "Categorizing error: exit_code=$exit_code, command=$command"
    
    # Analyze error based on exit code and output
    case "$exit_code" in
        1)
            if [[ "$error_output" =~ "Permission denied" ]]; then
                echo "PERMISSION"
            elif [[ "$error_output" =~ "not a git repository" ]]; then
                echo "REPOSITORY"
            elif [[ "$error_output" =~ "merge conflict" || "$error_output" =~ "CONFLICT" ]]; then
                echo "CONFLICT"
            else
                echo "GIT_COMMAND"
            fi
            ;;
        128)
            if [[ "$error_output" =~ "not a git repository" ]]; then
                echo "REPOSITORY"
            elif [[ "$error_output" =~ "invalid object name" ]]; then
                echo "REPOSITORY"
            else
                echo "GIT_COMMAND"
            fi
            ;;
        129)
            echo "USER_INPUT"
            ;;
        *)
            if [[ "$error_output" =~ "Could not resolve hostname" || "$error_output" =~ "Connection refused" ]]; then
                echo "NETWORK"
            elif [[ "$error_output" =~ "Authentication failed" || "$error_output" =~ "Permission denied (publickey)" ]]; then
                echo "AUTHENTICATION"
            elif [[ "$error_output" =~ "Permission denied" ]]; then
                echo "PERMISSION"
            else
                echo "SYSTEM"
            fi
            ;;
    esac
}

# Enhanced Git command execution with error handling
execute_git_command() {
    local command="$1"
    local description="${2:-Git operation}"
    local allow_failure="${3:-false}"
    
    log_debug "Executing Git command: $command"
    
    # Create temporary files for output capture
    local stdout_file stderr_file
    stdout_file=$(mktemp)
    stderr_file=$(mktemp)
    
    # Execute command and capture output
    local exit_code
    if eval "$command" > "$stdout_file" 2> "$stderr_file"; then
        exit_code=0
    else
        exit_code=$?
    fi
    
    local stdout_content stderr_content
    stdout_content=$(cat "$stdout_file" 2>/dev/null || echo "")
    stderr_content=$(cat "$stderr_file" 2>/dev/null || echo "")
    
    # Cleanup temp files
    rm -f "$stdout_file" "$stderr_file"
    
    if [[ $exit_code -eq 0 ]]; then
        log_debug "$description completed successfully"
        echo "$stdout_content"
        return 0
    else
        # Categorize and handle error
        local error_category
        error_category=$(categorize_git_error "$exit_code" "$command" "$stderr_content")
        
        log_error "$description failed (exit code: $exit_code)"
        log_error "Error category: $error_category"
        log_error "Command: $command"
        
        if [[ -n "$stderr_content" ]]; then
            log_error "Error output: $stderr_content"
        fi
        
        # Handle error based on category
        if [[ "$allow_failure" != "true" ]]; then
            handle_git_error "$error_category" "$command" "$stderr_content" "$description"
        fi
        
        return $exit_code
    fi
}

# Handle Git errors with recovery options
handle_git_error() {
    local error_category="$1"
    local command="$2"
    local error_output="$3"
    local description="$4"
    
    echo -e "\n${RED}Error: ${ERROR_CATEGORIES[$error_category]}${NC}"
    echo -e "${CYAN}Operation:${NC} $description"
    echo -e "${CYAN}Command:${NC} $command"
    
    if [[ -n "$error_output" ]]; then
        echo -e "${CYAN}Details:${NC} $error_output"
    fi
    
    echo ""
    
    case "$error_category" in
        "NETWORK")
            echo -e "${YELLOW}Network Issue Recovery Options:${NC}"
            echo "1. Check your internet connection"
            echo "2. Verify remote repository URL: git remote -v"
            echo "3. Try again in a few moments"
            echo "4. Work offline (some operations may be limited)"
            ;;
        "AUTHENTICATION")
            echo -e "${YELLOW}Authentication Issue Recovery Options:${NC}"
            echo "1. Check your Git credentials: git config --list | grep user"
            echo "2. Update your SSH key or personal access token"
            echo "3. Try: git config --global credential.helper store"
            echo "4. For SSH: ssh -T git@github.com"
            ;;
        "PERMISSION")
            echo -e "${YELLOW}Permission Issue Recovery Options:${NC}"
            echo "1. Check file/directory permissions"
            echo "2. Ensure you have write access to the repository"
            echo "3. Try running with appropriate permissions"
            echo "4. Check if files are locked by another process"
            ;;
        "REPOSITORY")
            echo -e "${YELLOW}Repository Issue Recovery Options:${NC}"
            echo "1. Verify you're in a Git repository: git status"
            echo "2. Check repository integrity: git fsck"
            echo "3. Try: git gc --prune=now"
            echo "4. Consider cloning a fresh copy if corrupted"
            ;;
        "CONFLICT")
            echo -e "${YELLOW}Conflict Resolution Options:${NC}"
            echo "1. Use the interactive conflict resolution menu"
            echo "2. Manually resolve conflicts and commit"
            echo "3. Abort the operation: git merge --abort"
            echo "4. Use a merge tool: git mergetool"
            ;;
        "USER_INPUT")
            echo -e "${YELLOW}Input Issue Recovery Options:${NC}"
            echo "1. Check command syntax and arguments"
            echo "2. Verify branch names and references exist"
            echo "3. Use tab completion for branch names"
            echo "4. Check the help: ./branch_manager.sh help"
            ;;
        *)
            echo -e "${YELLOW}General Recovery Options:${NC}"
            echo "1. Check the operation logs for more details"
            echo "2. Try the operation again"
            echo "3. Restore from backup if available"
            echo "4. Contact support with error details"
            ;;
    esac
    
    echo ""
    
    # Offer recovery actions
    if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
        echo "Choose a recovery action:"
        echo "1) Retry the operation"
        echo "2) Show detailed error information"
        echo "3) Create backup and continue"
        echo "4) Abort operation"
        
        while true; do
            read -p "Enter your choice (1-4): " recovery_choice
            case $recovery_choice in
                1)
                    log_info "User chose to retry operation"
                    return 2  # Special return code for retry
                    ;;
                2)
                    show_detailed_error_info "$error_category" "$command" "$error_output"
                    continue
                    ;;
                3)
                    local backup_id
                    backup_id=$(create_safety_backup "ERROR_RECOVERY")
                    log_info "Backup created: $backup_id"
                    return 0
                    ;;
                4)
                    log_info "User chose to abort operation"
                    return 1
                    ;;
                *)
                    echo "Invalid choice. Please enter 1, 2, 3, or 4."
                    continue
                    ;;
            esac
        done
    fi
    
    return 1
}

# Show detailed error information
show_detailed_error_info() {
    local error_category="$1"
    local command="$2"
    local error_output="$3"
    
    echo -e "\n${WHITE}Detailed Error Information${NC}"
    echo "=========================="
    echo -e "${CYAN}Category:${NC} $error_category - ${ERROR_CATEGORIES[$error_category]}"
    echo -e "${CYAN}Command:${NC} $command"
    echo -e "${CYAN}Timestamp:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
    
    if [[ -n "$error_output" ]]; then
        echo -e "${CYAN}Error Output:${NC}"
        echo "$error_output"
    fi
    
    echo -e "\n${CYAN}System Information:${NC}"
    echo "Git version: $(git --version 2>/dev/null || echo 'Not available')"
    echo "Shell: $SHELL"
    echo "Working directory: $(pwd)"
    echo "Repository: $(git remote get-url origin 2>/dev/null || echo 'No remote')"
    
    echo -e "\n${CYAN}Recent Operations:${NC}"
    if [[ -f "$LOG_DIR/operations.log" ]]; then
        tail -5 "$LOG_DIR/operations.log" | while IFS='|' read -r timestamp operation branch status details; do
            echo "  $timestamp - $operation ($status)"
        done
    else
        echo "  No operation history available"
    fi
    
    echo ""
}

# Rollback capabilities for failed operations
create_rollback_point() {
    local operation="$1"
    local rollback_id
    rollback_id=$(generate_backup_id "ROLLBACK_$operation")
    
    log_info "Creating rollback point for: $operation"
    
    # Create comprehensive rollback information
    local rollback_path="$BACKUP_DIR/$rollback_id"
    mkdir -p "$rollback_path"
    
    # Save current state
    local current_branch
    current_branch=$(get_current_branch 2>/dev/null || echo "unknown")
    
    cat > "$rollback_path/rollback_info.txt" << EOF
Rollback Point Information
=========================
Operation: $operation
Timestamp: $(date '+%Y-%m-%d %H:%M:%S')
Current Branch: $current_branch
Repository: $(git remote get-url origin 2>/dev/null || echo "local")
Git Commit: $(git rev-parse HEAD 2>/dev/null || echo "unknown")
Working Directory: $(pwd)
Rollback ID: $rollback_id
EOF
    
    # Save branch state
    git branch -a > "$rollback_path/branches.txt" 2>/dev/null || true
    git status --porcelain > "$rollback_path/status.txt" 2>/dev/null || true
    git log --oneline -10 > "$rollback_path/recent_commits.txt" 2>/dev/null || true
    
    # Save stash if exists
    if git stash list | grep -q .; then
        git stash list > "$rollback_path/stash_list.txt"
    fi
    
    log_operation "CREATE_ROLLBACK" "$current_branch" "SUCCESS" "Rollback ID: $rollback_id"
    echo "$rollback_id"
}

# Execute rollback to previous state
execute_rollback() {
    local rollback_id="$1"
    local rollback_path="$BACKUP_DIR/$rollback_id"
    
    if [[ ! -d "$rollback_path" ]]; then
        log_error "Rollback point not found: $rollback_id"
        return 1
    fi
    
    if [[ ! -f "$rollback_path/rollback_info.txt" ]]; then
        log_error "Invalid rollback point: missing information"
        return 1
    fi
    
    log_info "Executing rollback: $rollback_id"
    
    # Show rollback information
    echo -e "${WHITE}Rollback Information:${NC}"
    cat "$rollback_path/rollback_info.txt"
    echo ""
    
    # Confirm rollback
    if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
        echo -e "${RED}Warning: This will revert your repository to a previous state${NC}"
        read -p "Are you sure you want to proceed with rollback? (y/N): " confirm_rollback
        if [[ "$confirm_rollback" != "y" && "$confirm_rollback" != "Y" ]]; then
            log_info "Rollback cancelled by user"
            return 1
        fi
    fi
    
    # Perform rollback operations
    log_info "Performing rollback operations..."
    
    # Reset to clean state if possible
    if git status --porcelain | grep -q .; then
        log_info "Stashing current changes before rollback..."
        git stash push -m "Auto-stash before rollback to $rollback_id" --include-untracked || true
    fi
    
    # Restore branch if specified
    if [[ -f "$rollback_path/rollback_info.txt" ]]; then
        local rollback_branch
        rollback_branch=$(grep "Current Branch:" "$rollback_path/rollback_info.txt" | cut -d: -f2 | xargs)
        
        if [[ -n "$rollback_branch" && "$rollback_branch" != "unknown" ]]; then
            if branch_exists "$rollback_branch"; then
                log_info "Switching to rollback branch: $rollback_branch"
                git checkout "$rollback_branch" || log_warn "Failed to switch to rollback branch"
            fi
        fi
    fi
    
    log_operation "EXECUTE_ROLLBACK" "$(get_current_branch 2>/dev/null)" "SUCCESS" "Rollback ID: $rollback_id"
    log_info "Rollback completed successfully"
    
    return 0
}

# List available rollback points
list_rollback_points() {
    echo -e "${WHITE}Available Rollback Points:${NC}"
    echo "=========================="
    
    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo "No rollback points found"
        return
    fi
    
    local rollback_count=0
    for rollback_path in "$BACKUP_DIR"/ROLLBACK_*; do
        if [[ -d "$rollback_path" ]] && [[ -f "$rollback_path/rollback_info.txt" ]]; then
            rollback_count=$((rollback_count + 1))
            local rollback_id
            rollback_id=$(basename "$rollback_path")
            
            echo -e "${CYAN}$rollback_count.${NC} $rollback_id"
            
            # Show key information
            grep -E "^(Operation|Timestamp|Current Branch):" "$rollback_path/rollback_info.txt" | sed 's/^/   /'
            echo ""
        fi
    done
    
    if [[ $rollback_count -eq 0 ]]; then
        echo "No rollback points found"
    fi
}

# Interactive rollback management
manage_rollbacks() {
    while true; do
        echo -e "${WHITE}Rollback Management${NC}"
        echo "=================="
        echo ""
        echo "1) List rollback points"
        echo "2) Execute rollback"
        echo "3) Create rollback point"
        echo "4) Clean up old rollback points"
        echo "5) Back to main menu"
        echo ""
        
        choice=$(read_menu_choice "Select option: ") || return 1
        
        case $choice in
            1)
                echo ""
                list_rollback_points
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                list_rollback_points
                echo ""
                read -p "Enter rollback ID: " rollback_id
                if [[ -n "$rollback_id" ]]; then
                    execute_rollback "$rollback_id"
                else
                    echo "Rollback ID cannot be empty"
                fi
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                echo ""
                read -p "Enter operation description: " operation_desc
                operation_desc="${operation_desc:-MANUAL}"
                local rollback_id
                rollback_id=$(create_rollback_point "$operation_desc")
                echo "Rollback point created: $rollback_id"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4)
                echo ""
                echo "Cleaning up rollback points older than ${CONFIG[BACKUP_RETENTION_DAYS]} days..."
                find "$BACKUP_DIR" -name "ROLLBACK_*" -type d -mtime +${CONFIG[BACKUP_RETENTION_DAYS]} -exec rm -rf {} \; 2>/dev/null || true
                echo "Cleanup completed"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            5)
                return 0
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, 4, or 5."
                sleep 1
                ;;
        esac
    done
}

# Operation logging and audit trail

# Enhanced operation logging with detailed information
log_detailed_operation() {
    local operation="$1"
    local branch="${2:-$(get_current_branch 2>/dev/null || echo 'unknown')}"
    local status="$3"
    local details="${4:-}"
    local user="${5:-$(whoami 2>/dev/null || echo 'unknown')}"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local iso_timestamp=$(date -Iseconds 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S')
    
    # Enhanced log entry with more details
    local log_entry="$iso_timestamp|$user|$operation|$branch|$status|$details|$(pwd)|$$"
    
    # Write to operations log
    echo "$log_entry" >> "$LOG_DIR/operations.log"
    
    # Also write to daily log for better organization
    local daily_log="$LOG_DIR/operations_$(date '+%Y%m%d').log"
    echo "$log_entry" >> "$daily_log"
    
    # Log to main log as well
    log_info "Operation logged: $operation on '$branch' - $status"
    
    # Update operation statistics
    update_operation_stats "$operation" "$status"
}

# Update operation statistics
update_operation_stats() {
    local operation="$1"
    local status="$2"
    local stats_file="$LOG_DIR/operation_stats.txt"
    
    # Create stats file if it doesn't exist
    if [[ ! -f "$stats_file" ]]; then
        cat > "$stats_file" << EOF
# Operation Statistics
# Format: operation|success_count|failure_count|last_success|last_failure
EOF
    fi
    
    local temp_file=$(mktemp)
    local found=false
    local timestamp=$(date -Iseconds 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S')
    
    # Update existing entry or create new one
    while IFS='|' read -r op success_count failure_count last_success last_failure; do
        # Skip comments
        [[ "$op" =~ ^# ]] && { echo "$op|$success_count|$failure_count|$last_success|$last_failure" >> "$temp_file"; continue; }
        
        if [[ "$op" == "$operation" ]]; then
            found=true
            if [[ "$status" == "SUCCESS" ]]; then
                success_count=$((success_count + 1))
                last_success="$timestamp"
            else
                failure_count=$((failure_count + 1))
                last_failure="$timestamp"
            fi
        fi
        echo "$op|$success_count|$failure_count|$last_success|$last_failure" >> "$temp_file"
    done < "$stats_file"
    
    # Add new operation if not found
    if [[ "$found" == false ]]; then
        if [[ "$status" == "SUCCESS" ]]; then
            echo "$operation|1|0|$timestamp|" >> "$temp_file"
        else
            echo "$operation|0|1||$timestamp" >> "$temp_file"
        fi
    fi
    
    mv "$temp_file" "$stats_file"
}

# Show operation statistics
show_operation_statistics() {
    local stats_file="$LOG_DIR/operation_stats.txt"
    
    if [[ ! -f "$stats_file" ]]; then
        echo "No operation statistics available"
        return
    fi
    
    echo -e "${WHITE}Operation Statistics${NC}"
    echo "===================="
    echo ""
    
    printf "%-25s %-8s %-8s %-12s %-20s %-20s\n" "Operation" "Success" "Failure" "Success Rate" "Last Success" "Last Failure"
    printf "%-25s %-8s %-8s %-12s %-20s %-20s\n" "--------" "-------" "-------" "------------" "------------" "------------"
    
    while IFS='|' read -r operation success_count failure_count last_success last_failure; do
        # Skip comments and empty lines
        [[ "$operation" =~ ^# ]] && continue
        [[ -z "$operation" ]] && continue
        
        local total=$((success_count + failure_count))
        local success_rate="N/A"
        
        if [[ $total -gt 0 ]]; then
            success_rate=$(( (success_count * 100) / total ))"%"
        fi
        
        # Format timestamps
        local formatted_success="${last_success:-Never}"
        local formatted_failure="${last_failure:-Never}"
        
        if [[ "$formatted_success" != "Never" ]]; then
            formatted_success=$(date -d "$last_success" '+%m/%d %H:%M' 2>/dev/null || echo "$last_success")
        fi
        
        if [[ "$formatted_failure" != "Never" ]]; then
            formatted_failure=$(date -d "$last_failure" '+%m/%d %H:%M' 2>/dev/null || echo "$last_failure")
        fi
        
        printf "%-25s %-8s %-8s %-12s %-20s %-20s\n" \
            "$operation" "$success_count" "$failure_count" "$success_rate" \
            "$formatted_success" "$formatted_failure"
    done < "$stats_file"
}

# Log rotation and cleanup management
rotate_logs() {
    local max_size_mb="${1:-10}"  # Default 10MB
    local max_files="${2:-5}"     # Keep 5 rotated files
    
    log_info "Starting log rotation (max size: ${max_size_mb}MB, max files: $max_files)"
    
    # Rotate main log file
    if [[ -f "$LOG_FILE" ]]; then
        local file_size_mb
        file_size_mb=$(du -m "$LOG_FILE" 2>/dev/null | cut -f1 || echo "0")
        
        if [[ $file_size_mb -gt $max_size_mb ]]; then
            log_info "Rotating main log file (size: ${file_size_mb}MB)"
            
            # Rotate existing files
            for ((i=max_files; i>=1; i--)); do
                local old_file="${LOG_FILE}.$i"
                local new_file="${LOG_FILE}.$((i+1))"
                
                if [[ -f "$old_file" ]]; then
                    if [[ $i -eq $max_files ]]; then
                        rm -f "$old_file"  # Remove oldest
                    else
                        mv "$old_file" "$new_file"
                    fi
                fi
            done
            
            # Move current log to .1
            mv "$LOG_FILE" "${LOG_FILE}.1"
            touch "$LOG_FILE"
            
            log_info "Main log file rotated successfully"
        fi
    fi
    
    # Rotate operations log
    local ops_log="$LOG_DIR/operations.log"
    if [[ -f "$ops_log" ]]; then
        local file_size_mb
        file_size_mb=$(du -m "$ops_log" 2>/dev/null | cut -f1 || echo "0")
        
        if [[ $file_size_mb -gt $max_size_mb ]]; then
            log_info "Rotating operations log file (size: ${file_size_mb}MB)"
            
            # Rotate operations log
            for ((i=max_files; i>=1; i--)); do
                local old_file="${ops_log}.$i"
                local new_file="${ops_log}.$((i+1))"
                
                if [[ -f "$old_file" ]]; then
                    if [[ $i -eq $max_files ]]; then
                        rm -f "$old_file"
                    else
                        mv "$old_file" "$new_file"
                    fi
                fi
            done
            
            mv "$ops_log" "${ops_log}.1"
            touch "$ops_log"
            
            log_info "Operations log file rotated successfully"
        fi
    fi
    
    # Clean up old daily logs (older than retention period)
    local retention_days="${CONFIG[BACKUP_RETENTION_DAYS]}"
    find "$LOG_DIR" -name "operations_*.log" -type f -mtime +$retention_days -delete 2>/dev/null || true
    
    log_info "Log rotation completed"
}

# Advanced troubleshooting information
generate_troubleshooting_report() {
    local report_file="$LOG_DIR/troubleshooting_report_$(date '+%Y%m%d_%H%M%S').txt"
    
    log_info "Generating troubleshooting report: $report_file"
    
    cat > "$report_file" << EOF
Git Branch Manager Troubleshooting Report
=========================================
Generated: $(date '+%Y-%m-%d %H:%M:%S')
Version: $SCRIPT_VERSION

SYSTEM INFORMATION
==================
Operating System: $(uname -a 2>/dev/null || echo "Unknown")
Shell: $SHELL
User: $(whoami 2>/dev/null || echo "Unknown")
Working Directory: $(pwd)
Script Location: $SCRIPT_DIR

GIT INFORMATION
===============
Git Version: $(git --version 2>/dev/null || echo "Git not available")
Repository: $(git remote get-url origin 2>/dev/null || echo "No remote configured")
Current Branch: $(get_current_branch 2>/dev/null || echo "Unknown")
Repository Status: $(git status --porcelain 2>/dev/null | wc -l || echo "0") files changed

CONFIGURATION
=============
EOF
    
    # Add configuration details
    for key in "${!CONFIG[@]}"; do
        echo "$key: ${CONFIG[$key]}" >> "$report_file"
    done
    
    cat >> "$report_file" << EOF

RECENT OPERATIONS (Last 20)
============================
EOF
    
    # Add recent operations
    if [[ -f "$LOG_DIR/operations.log" ]]; then
        tail -20 "$LOG_DIR/operations.log" >> "$report_file"
    else
        echo "No operation history available" >> "$report_file"
    fi
    
    cat >> "$report_file" << EOF

OPERATION STATISTICS
====================
EOF
    
    # Add operation statistics
    if [[ -f "$LOG_DIR/operation_stats.txt" ]]; then
        cat "$LOG_DIR/operation_stats.txt" >> "$report_file"
    else
        echo "No operation statistics available" >> "$report_file"
    fi
    
    cat >> "$report_file" << EOF

RECENT LOG ENTRIES (Last 50)
=============================
EOF
    
    # Add recent log entries
    if [[ -f "$LOG_FILE" ]]; then
        tail -50 "$LOG_FILE" >> "$report_file"
    else
        echo "No log entries available" >> "$report_file"
    fi
    
    cat >> "$report_file" << EOF

REPOSITORY HEALTH CHECK
=======================
EOF
    
    # Add repository health information
    {
        echo "Git fsck output:"
        git fsck 2>&1 | head -20 || echo "Git fsck failed"
        echo ""
        echo "Disk space:"
        df -h . 2>/dev/null || echo "Disk space check failed"
        echo ""
        echo "File permissions:"
        ls -la . 2>/dev/null | head -10 || echo "Permission check failed"
    } >> "$report_file"
    
    echo "$report_file"
}

# Debug output options
enable_debug_mode() {
    CONFIG["LOG_LEVEL"]="DEBUG"
    log_info "Debug mode enabled"
    
    # Enable bash debug tracing if requested
    if [[ "${1:-}" == "trace" ]]; then
        set -x
        log_info "Bash tracing enabled"
    fi
    
    # Show debug information
    echo -e "${WHITE}Debug Mode Enabled${NC}"
    echo "=================="
    echo -e "${CYAN}Log Level:${NC} DEBUG"
    echo -e "${CYAN}Log File:${NC} $LOG_FILE"
    echo -e "${CYAN}Operations Log:${NC} $LOG_DIR/operations.log"
    echo -e "${CYAN}Debug Tracing:${NC} ${1:-disabled}"
    echo ""
}

# Interactive logging and audit management
manage_logs_and_audit() {
    while true; do
        echo -e "${WHITE}Logging and Audit Management${NC}"
        echo "============================"
        echo ""
        echo "1) View recent operations"
        echo "2) Show operation statistics"
        echo "3) Generate troubleshooting report"
        echo "4) Rotate log files"
        echo "5) Enable debug mode"
        echo "6) Clean up old logs"
        echo "7) Back to main menu"
        echo ""
        
        choice=$(read_menu_choice "Select option: ") || return 1
        
        case $choice in
            1)
                echo ""
                echo -e "${WHITE}Recent Operations (Last 20):${NC}"
                echo "============================="
                if [[ -f "$LOG_DIR/operations.log" ]]; then
                    tail -20 "$LOG_DIR/operations.log" | while IFS='|' read -r timestamp user operation branch status details pwd pid; do
                        echo -e "${CYAN}$timestamp${NC} - $operation on ${GREEN}$branch${NC}: $status"
                        if [[ -n "$details" ]]; then
                            echo -e "  ${PURPLE}$details${NC}"
                        fi
                    done
                else
                    echo "No operations log found"
                fi
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                show_operation_statistics
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                echo ""
                local report_file
                report_file=$(generate_troubleshooting_report)
                echo "Troubleshooting report generated: $report_file"
                echo ""
                read -p "View report now? (y/N): " view_report
                if [[ "$view_report" == "y" || "$view_report" == "Y" ]]; then
                    less "$report_file" 2>/dev/null || cat "$report_file"
                fi
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4)
                echo ""
                read -p "Enter max log size in MB (default: 10): " max_size
                max_size="${max_size:-10}"
                read -p "Enter max rotated files to keep (default: 5): " max_files
                max_files="${max_files:-5}"
                rotate_logs "$max_size" "$max_files"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            5)
                echo ""
                read -p "Enable bash tracing as well? (y/N): " enable_trace
                if [[ "$enable_trace" == "y" || "$enable_trace" == "Y" ]]; then
                    enable_debug_mode "trace"
                else
                    enable_debug_mode
                fi
                echo ""
                read -p "Press Enter to continue..."
                ;;
            6)
                echo ""
                local retention_days="${CONFIG[BACKUP_RETENTION_DAYS]}"
                echo "Cleaning up logs older than $retention_days days..."
                find "$LOG_DIR" -name "*.log.*" -type f -mtime +$retention_days -delete 2>/dev/null || true
                find "$LOG_DIR" -name "operations_*.log" -type f -mtime +$retention_days -delete 2>/dev/null || true
                find "$LOG_DIR" -name "troubleshooting_report_*.txt" -type f -mtime +$retention_days -delete 2>/dev/null || true
                echo "Log cleanup completed"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            7)
                return 0
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, 4, 5, 6, or 7."
                sleep 1
                ;;
        esac
    done
}

# Show comprehensive command reference
show_command_reference() {
    echo -e "${WHITE}Command Reference${NC}"
    echo "================="
    echo ""
    
    echo -e "${CYAN}CORE COMMANDS:${NC}"
    echo ""
    echo -e "${YELLOW}create${NC} <branch-name> [base-branch] [options]"
    echo "    Create a new branch with safety checks"
    echo "    Options: --workflow-type=<type>, --base=<branch>, --no-fetch, --no-confirm"
    echo "    Example: ./branch_manager.sh create feature/user-auth"
    echo ""
    
    echo -e "${YELLOW}switch${NC} <branch-name> [options]"
    echo "    Switch to an existing branch"
    echo "    Options: --force, --no-confirm"
    echo "    Example: ./branch_manager.sh switch main"
    echo ""
    
    echo -e "${YELLOW}merge${NC} <source-branch> [target-branch] [options]"
    echo "    Merge branches with conflict resolution"
    echo "    Options: --strategy=<type>, --no-sync, --workflow-validate"
    echo "    Example: ./branch_manager.sh merge feature/api main"
    echo ""
    
    echo -e "${YELLOW}sync${NC} [branch-name] [options]"
    echo "    Synchronize with upstream repository"
    echo "    Options: --strategy=<type>"
    echo "    Example: ./branch_manager.sh sync"
    echo ""
    
    echo -e "${YELLOW}status${NC} [options]"
    echo "    Show branch and repository status"
    echo "    Options: --all, --remote, --verbose"
    echo "    Example: ./branch_manager.sh status --all"
    echo ""
    
    echo -e "${YELLOW}cleanup${NC} [target-branch] [options]"
    echo "    Clean up merged branches"
    echo "    Options: --auto, --dry-run"
    echo "    Example: ./branch_manager.sh cleanup --dry-run"
    echo ""
    
    echo -e "${YELLOW}push${NC} [commit-message] [options]"
    echo "    Commit and push changes to remote repository"
    echo "    Options: --no-confirm"
    echo "    Example: ./branch_manager.sh push \"Add new feature\""
    echo ""
    
    echo -e "${CYAN}WORKFLOW COMMANDS:${NC}"
    echo ""
    echo -e "${YELLOW}workflow complete-feature${NC} [target-branch]"
    echo "    Complete entire feature development workflow"
    echo "    Example: ./branch_manager.sh workflow complete-feature"
    echo ""
    
    echo -e "${YELLOW}workflow merge-and-push${NC} <source> [target]"
    echo "    Merge branch and push to GitHub"
    echo "    Example: ./branch_manager.sh workflow merge-and-push feature/api main"
    echo ""
    
    echo -e "${CYAN}GLOBAL OPTIONS:${NC}"
    echo ""
    echo "    --debug                 Enable debug logging"
    echo "    --no-confirm            Skip confirmation prompts"
    echo "    --no-fetch              Skip automatic fetching"
    echo "    --workflow=<name>       Use specific workflow"
    echo "    --base=<branch>         Override default base branch"
    echo "    -h, --help              Show help"
    echo "    -v, --version           Show version"
    echo ""
    
    echo -e "${CYAN}INTERACTIVE MODE:${NC}"
    echo ""
    echo "    ./branch_manager.sh     Launch interactive menu system"
    echo ""
    echo "    Menu sections:"
    echo "    1. Branch Operations    - Create, switch, manage branches"
    echo "    2. Merge Operations     - Merge, resolve conflicts"
    echo "    3. Remote Sync          - Upstream management"
    echo "    4. Repository Status    - Health checks, information"
    echo "    5. Cleanup Operations   - Maintenance, backups, logs"
    echo "    6. Configuration        - Settings, workflows"
    echo "    7. Help & Information   - Documentation, examples"
    echo ""
    
    echo -e "${CYAN}QUICK EXAMPLES:${NC}"
    echo ""
    echo "    # GitHub Flow workflow"
    echo "    ./branch_manager.sh create feature/login"
    echo "    ./branch_manager.sh merge feature/login main"
    echo "    ./branch_manager.sh cleanup"
    echo ""
    echo "    # GitFlow workflow"
    echo "    ./branch_manager.sh create --workflow-type=feature shopping-cart"
    echo "    ./branch_manager.sh merge feature/shopping-cart develop"
    echo ""
    echo "    # Advanced operations"
    echo "    ./branch_manager.sh status --all --verbose"
    echo "    ./branch_manager.sh merge feature/api --strategy=fast-forward"
    echo "    ./branch_manager.sh workflow complete-feature"
    echo ""
    
    echo -e "${CYAN}DOCUMENTATION:${NC}"
    echo ""
    echo "    README.md           - Complete user guide"
    echo "    CONFIGURATION.md    - Configuration reference"
    echo "    COMMANDS.md         - Detailed command reference"
    echo ""
    echo "    For command-specific help: ./branch_manager.sh <command> --help"
}

# =============================================================================
# INTEGRATED PUSH TO GITHUB FUNCTIONALITY
# =============================================================================

# Direct push to GitHub functionality (integrated from push_to_github.sh)
push_to_github() {
    local commit_message="${1:-}"
    local auto_commit="${2:-false}"
    local current_branch
    current_branch=$(get_current_branch)
    
    log_info "Starting push to GitHub process..."
    
    # Auto-detect repository URL from current Git repository
    local repo_url
    repo_url=$(git remote get-url origin 2>/dev/null || echo "")
    
    if [[ -z "$repo_url" ]]; then
        log_error "No remote origin configured. Please set up your remote repository first."
        echo "To set up remote origin, run:"
        echo "  git remote add origin <your-repository-url>"
        return 1
    fi
    
    echo -e "${BLUE}🚀 Git Branch Manager - Push to Repository${NC}"
    echo "========================================"
    
    # Verify remote origin is accessible
    log_debug "Using repository URL: $repo_url"
    
    # Check for changes (including untracked files)
    local has_changes=false
    
    # Check for uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        has_changes=true
    fi
    
    # Check for untracked files
    if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
        has_changes=true
    fi
    
    # Check for unpushed commits
    local unpushed_commits=0
    if has_upstream "$current_branch"; then
        local upstream
        upstream=$(get_upstream_branch "$current_branch")
        unpushed_commits=$(git rev-list --count "$upstream..$current_branch" 2>/dev/null || echo "0")
    else
        # If no upstream, check if there are any commits
        unpushed_commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    fi
    
    if [[ "$has_changes" == false && "$unpushed_commits" -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  No changes detected${NC}"
        echo "Nothing to commit or push. Working tree clean and up to date."
        return 0
    fi
    
    # Show current status
    echo -e "\n${CYAN}Current Status:${NC}"
    echo -e "${CYAN}Branch:${NC} $current_branch"
    if [[ "$unpushed_commits" -gt 0 ]]; then
        echo -e "${CYAN}Unpushed commits:${NC} $unpushed_commits"
    fi
    
    # Handle uncommitted changes
    if [[ "$has_changes" == true ]]; then
        echo -e "\n${BLUE}📋 Changes detected:${NC}"
        
        # Show what will be committed
        if ! git diff --quiet || ! git diff --cached --quiet; then
            echo "Modified files:"
            git status --porcelain | grep -E "^[MARC ]" || true
        fi
        
        if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
            echo "Untracked files:"
            git ls-files --others --exclude-standard
        fi
        
        # Get commit message
        if [[ -z "$commit_message" && "$auto_commit" == "false" ]]; then
            echo -e "\n${BLUE}📝 Enter your commit message:${NC}"
            read -p "Commit: " commit_message
            
            # If user didn't enter anything, use auto-generated message
            if [[ -z "$commit_message" ]]; then
                local timestamp
                timestamp=$(date '+%Y-%m-%d %H:%M:%S')
                commit_message="Auto-commit: Updates on $timestamp"
                echo -e "${YELLOW}📝 Using auto-generated message: $commit_message${NC}"
            else
                echo -e "${GREEN}📝 Using your message: $commit_message${NC}"
            fi
        elif [[ -z "$commit_message" ]]; then
            local timestamp
            timestamp=$(date '+%Y-%m-%d %H:%M:%S')
            commit_message="Auto-commit: Updates on $timestamp"
            echo -e "${YELLOW}📝 Using auto-generated message: $commit_message${NC}"
        else
            echo -e "${GREEN}📝 Commit message: $commit_message${NC}"
        fi
        
        # Commit changes
        echo -e "\n${BLUE}💾 Committing changes...${NC}"
        git add .
        git commit -m "$commit_message"
        log_operation "COMMIT" "$current_branch" "SUCCESS" "$commit_message"
    fi
    
    # Push to GitHub
    echo -e "\n${BLUE}🚀 Pushing to GitHub...${NC}"
    
    # Create backup before push
    local backup_id
    backup_id=$(create_safety_backup "PUSH_TO_GITHUB")
    
    # Perform the push
    if git push -u origin "$current_branch"; then
        # Extract repository name for display
        local repo_name
        repo_name=$(basename "$repo_url" .git 2>/dev/null || echo "repository")
        
        echo -e "\n${GREEN}✅ Successfully pushed to remote repository!${NC}"
        echo -e "${GREEN}🔗 Repository: $repo_name${NC}"
        echo -e "${GREEN}🌿 Branch: $current_branch${NC}"
        echo -e "${GREEN}📍 URL: $repo_url${NC}"
        
        log_operation "PUSH_TO_GITHUB" "$current_branch" "SUCCESS" "Pushed to $repo_url"
        return 0
    else
        echo -e "\n${RED}❌ Failed to push to remote repository${NC}"
        log_error "Push to GitHub failed"
        log_operation "PUSH_TO_GITHUB" "$current_branch" "FAILED" "Push failed"
        
        # Offer recovery options
        echo ""
        echo "Recovery options:"
        echo "1. Check network connectivity"
        echo "2. Verify GitHub credentials"
        echo "3. Check repository permissions"
        echo "4. Try again later"
        
        if [[ "${CONFIG[REQUIRE_CONFIRMATION]}" == "true" ]]; then
            read -p "Restore from backup? (y/N): " restore_backup
            if [[ "$restore_backup" == "y" || "$restore_backup" == "Y" ]]; then
                restore_from_backup "$backup_id"
            fi
        fi
        
        return 1
    fi
}

# Interactive push interface
interactive_push() {
    echo -e "${WHITE}Interactive Push to Repository${NC}"
    echo "=========================="
    echo ""
    
    local current_branch
    current_branch=$(get_current_branch)
    echo -e "${CYAN}Current Branch:${NC} ${GREEN}$current_branch${NC}"
    
    # Show current status
    echo ""
    echo -e "${WHITE}Repository Status:${NC}"
    
    # Check for uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo -e "${YELLOW}• Uncommitted changes detected${NC}"
    fi
    
    # Check for untracked files
    if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
        echo -e "${YELLOW}• Untracked files detected${NC}"
    fi
    
    # Check for unpushed commits
    if has_upstream "$current_branch"; then
        local upstream ahead_count
        upstream=$(get_upstream_branch "$current_branch")
        ahead_count=$(git rev-list --count "$upstream..$current_branch" 2>/dev/null || echo "0")
        
        if [[ "$ahead_count" -gt 0 ]]; then
            echo -e "${BLUE}• $ahead_count unpushed commits${NC}"
        else
            echo -e "${GREEN}• Up to date with upstream${NC}"
        fi
    else
        echo -e "${YELLOW}• No upstream configured${NC}"
    fi
    
    echo ""
    echo "Push options:"
    echo "1) Push with custom commit message"
    echo "2) Push with auto-generated message"
    echo "3) Show detailed status first"
    echo "4) Cancel"
    
    while true; do
        read -p "Enter your choice (1-4): " choice
        case $choice in
            1)
                echo ""
                read -p "Enter commit message: " commit_msg
                if [[ -n "$commit_msg" ]]; then
                    push_to_github "$commit_msg"
                    return $?
                else
                    echo "Commit message cannot be empty"
                    continue
                fi
                ;;
            2)
                echo ""
                push_to_github "" "true"
                return $?
                ;;
            3)
                echo ""
                echo -e "${WHITE}Detailed Status:${NC}"
                git status
                echo ""
                continue
                ;;
            4)
                echo "Push cancelled"
                return 1
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, 3, or 4."
                continue
                ;;
        esac
    done
}

# =============================================================================
# INITIALIZATION
# =============================================================================

# Initialize the branch manager system
initialize_system() {
    log_debug "Initializing Branch Manager system..."
    
    # Create necessary directories
    mkdir -p "$CONFIG_DIR" "$LOG_DIR" "$BACKUP_DIR"
    
    # Initialize logging
    init_logging
    
    # Load configuration
    load_configuration
    
    # Check Git repository
    check_git_repository
    
    log_info "Branch Manager system initialized successfully"
}

# =============================================================================
# MAIN FUNCTION
# =============================================================================

main() {
    # Initialize system
    initialize_system
    
    # Parse command line arguments
    case "${1:-interactive}" in
        "create")
            shift
            create_command "$@"
            ;;
        "switch")
            shift
            switch_command "$@"
            ;;
        "merge")
            shift
            merge_command "$@"
            ;;
        "sync")
            shift
            sync_command "$@"
            ;;
        "status")
            shift
            status_command "$@"
            ;;
        "cleanup")
            shift
            cleanup_command "$@"
            ;;
        "push")
            shift
            if [[ $# -gt 0 ]]; then
                push_to_github "$*"
            else
                interactive_push
            fi
            ;;
        "config")
            show_configuration
            ;;
        "workflow")
            shift
            workflow_command "$@"
            ;;
        "interactive")
            run_interactive_interface
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        "version"|"-v"|"--version")
            show_version
            ;;
        *)
            log_error "Unknown command: $1"
            show_usage
            exit 1
            ;;
    esac
    
    log_info "Branch Manager execution completed"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
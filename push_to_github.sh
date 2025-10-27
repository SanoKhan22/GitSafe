#!/bin/bash

# Script to regularly push code to GitHub with proper commit messages

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[GIT]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[GIT]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[GIT]${NC} $1"
}

log_error() {
    echo -e "${RED}[GIT]${NC} $1"
}

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not a git repository. Initialize with: git init"
        exit 1
    fi
}

# Function to check git status
check_git_status() {
    log_info "Checking git status..."
    
    if [[ -z $(git status --porcelain) ]]; then
        log_warning "No changes to commit"
        return 1
    fi
    
    log_info "Changes detected:"
    git status --short
    return 0
}

# Function to add files
add_files() {
    log_info "Adding files to git..."
    
    # Add all files except sensitive ones
    git add .
    
    # Remove sensitive files if accidentally added
    git reset HEAD flutter_projects/.android/release-key.jks 2>/dev/null || true
    git reset HEAD .env 2>/dev/null || true
    git reset HEAD *.key 2>/dev/null || true
    
    log_success "Files added to staging"
}

# Function to create commit message
create_commit_message() {
    local default_message="Update Flutter Android setup - $(date '+%Y-%m-%d %H:%M')"
    
    if [[ $# -gt 0 ]]; then
        echo "$*"
    else
        echo "$default_message"
    fi
}

# Function to commit changes
commit_changes() {
    local commit_message="$1"
    
    log_info "Committing changes..."
    log_info "Commit message: $commit_message"
    
    if git commit -m "$commit_message"; then
        log_success "Changes committed successfully"
        return 0
    else
        log_error "Commit failed"
        return 1
    fi
}

# Function to push to GitHub
push_to_github() {
    log_info "Pushing to GitHub..."
    
    # Get current branch
    local current_branch=$(git branch --show-current)
    log_info "Current branch: $current_branch"
    
    # Check if remote exists
    if ! git remote get-url origin >/dev/null 2>&1; then
        log_error "No 'origin' remote found. Add your GitHub repo:"
        log_info "git remote add origin https://github.com/yourusername/your-repo.git"
        exit 1
    fi
    
    # Push to GitHub
    if git push origin "$current_branch"; then
        log_success "Successfully pushed to GitHub!"
        
        # Show remote URL
        local remote_url=$(git remote get-url origin)
        log_info "Repository: $remote_url"
        
        return 0
    else
        log_error "Push failed. You may need to pull first:"
        log_info "git pull origin $current_branch"
        return 1
    fi
}

# Function to setup .gitignore
setup_gitignore() {
    if [[ ! -f .gitignore ]]; then
        log_info "Creating .gitignore file..."
        
        cat > .gitignore << 'EOF'
# Flutter/Dart specific
flutter_projects/*/build/
flutter_projects/*/.dart_tool/
flutter_projects/*/.packages
flutter_projects/*/pubspec.lock

# Sensitive files
flutter_projects/.android/release-key.jks
*.key
*.keystore
.env
.env.local

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Logs
*.log

# Temporary files
*.tmp
*.temp
*~

# Backup files
*.backup.*
*_backup_*
EOF
        
        log_success ".gitignore created"
    fi
}

# Main function
main() {
    log_info "GitHub Push Script"
    log_info "=================="
    
    # Check if we're in a git repo
    check_git_repo
    
    # Setup .gitignore if needed
    setup_gitignore
    
    # Check for changes
    if ! check_git_status; then
        exit 0
    fi
    
    # Add files
    add_files
    
    # Create commit message
    local commit_message=$(create_commit_message "$@")
    
    # Commit changes
    if ! commit_changes "$commit_message"; then
        exit 1
    fi
    
    # Push to GitHub
    if ! push_to_github; then
        exit 1
    fi
    
    log_success "=================="
    log_success "All done! Your code is now on GitHub 🚀"
}

# Show usage if --help
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: $0 [commit message]"
    echo ""
    echo "Examples:"
    echo "  $0                           # Use default commit message"
    echo "  $0 \"Add new feature\"         # Use custom commit message"
    echo "  $0 Fix bug in validation     # Multiple words (no quotes needed)"
    echo ""
    echo "First time setup:"
    echo "  git init"
    echo "  git remote add origin https://github.com/yourusername/your-repo.git"
    exit 0
fi

# Run main function
main "$@"
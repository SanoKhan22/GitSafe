#!/bin/bash

# Push to GitHub script for GullyCric repository
# Usage: ./push_to_github.sh [commit_message]
# Example: ./push_to_github.sh "Add new feature"
# Example: ./push_to_github.sh Add new feature (no quotes needed for multiple words)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Repository URL
REPO_URL="https://github.com/SanoKhan22/GullyCric.git"

echo -e "${BLUE}🏏 GullyCric Push Script${NC}"
echo "================================"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Error: Not in a git repository${NC}"
    echo "Run: git init && git remote add origin $REPO_URL"
    exit 1
fi

# Check if remote origin exists and is correct
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if [ "$CURRENT_REMOTE" != "$REPO_URL" ]; then
    echo -e "${YELLOW}⚠️  Setting up remote origin...${NC}"
    git remote remove origin 2>/dev/null || true
    git remote add origin "$REPO_URL"
    echo -e "${GREEN}✅ Remote origin set to: $REPO_URL${NC}"
fi

# Check for changes
if git diff --quiet && git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️  No changes detected${NC}"
    echo "Nothing to commit. Working tree clean."
    exit 0
fi

# Generate commit message
if [ $# -eq 0 ]; then
    # Prompt user for commit message
    echo -e "${BLUE}📝 Enter your commit message:${NC}"
    read -p "Commit: " COMMIT_MSG
    
    # If user didn't enter anything, use auto-generated message
    if [ -z "$COMMIT_MSG" ]; then
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        COMMIT_MSG="Auto-commit: Updates on $TIMESTAMP"
        echo -e "${YELLOW}📝 Using auto-generated message: $COMMIT_MSG${NC}"
    else
        echo -e "${GREEN}📝 Using your message: $COMMIT_MSG${NC}"
    fi
else
    # Use provided arguments as commit message
    COMMIT_MSG="$*"
    echo -e "${GREEN}📝 Commit message: $COMMIT_MSG${NC}"
fi

# Show what will be committed
echo -e "\n${BLUE}📋 Files to be committed:${NC}"
git add .
git status --porcelain

# Commit changes
echo -e "\n${BLUE}💾 Committing changes...${NC}"
git commit -m "$COMMIT_MSG"

# Push to GitHub
echo -e "\n${BLUE}🚀 Pushing to GitHub...${NC}"
CURRENT_BRANCH=$(git branch --show-current)
git push -u origin "$CURRENT_BRANCH"

echo -e "\n${GREEN}✅ Successfully pushed to GitHub!${NC}"
echo -e "${GREEN}🔗 Repository: $REPO_URL${NC}"
echo -e "${GREEN}🌿 Branch: $CURRENT_BRANCH${NC}"
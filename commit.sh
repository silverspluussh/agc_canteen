#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script to commit and push changes to GitHub
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}       Git Commit & Push Script${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: Not a git repository${NC}"
    exit 1
fi

# Check for uncommitted changes
if [[ -z $(git status -s) ]]; then
    echo -e "${YELLOW}⚠️  No changes to commit${NC}"
    exit 0
fi

# Show current status
echo -e "${YELLOW}📋 Current changes:${NC}"
git status -s
echo ""

# Get commit message
if [ -z "$1" ]; then
    echo -e "${YELLOW}💬 Enter commit message:${NC}"
    read -r COMMIT_MESSAGE
    
    if [ -z "$COMMIT_MESSAGE" ]; then
        echo -e "${RED}❌ Commit message cannot be empty${NC}"
        exit 1
    fi
else
    COMMIT_MESSAGE="$1"
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${BLUE}🌿 Current branch: ${GREEN}${CURRENT_BRANCH}${NC}"
echo ""

# Stage all changes
echo -e "${YELLOW}📦 Staging changes...${NC}"
git add .

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to stage changes${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Changes staged${NC}"
echo ""

# Commit changes
echo -e "${YELLOW}💾 Committing changes...${NC}"
git commit -m "$COMMIT_MESSAGE"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to commit changes${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

# Ask if user wants to push
echo -e "${YELLOW}🚀 Push to remote? (y/n):${NC}"
read -r PUSH_CONFIRM

if [[ $PUSH_CONFIRM =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}📤 Pushing to origin/$CURRENT_BRANCH...${NC}"
    
    git push origin "$CURRENT_BRANCH"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✓ Successfully pushed to GitHub!${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    else
        echo -e "${RED}❌ Failed to push changes${NC}"
        echo -e "${YELLOW}💡 You may need to pull changes first: git pull origin $CURRENT_BRANCH${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⏸️  Changes committed but not pushed${NC}"
    echo -e "${YELLOW}💡 Push later with: git push origin $CURRENT_BRANCH${NC}"
fi

echo ""
echo -e "${BLUE}✨ Done!${NC}"


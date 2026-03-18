#!/QOpenSys/pkgs/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# HSRC1 Library Sync & Git Push Script
# ═══════════════════════════════════════════════════════════════════════════
# Purpose: Sync IBM i HSRC1 library to Git repository and push changes
# Usage:   ./sync_and_push_hsrc1.sh [--use-timestamp]
#          --use-timestamp : Use timestamp comparison (faster incremental)
# ═══════════════════════════════════════════════════════════════════════════

set -e  # Exit on error

# Configuration
REPO_DIR="/home/GitRepos/IBMi_Legacy"
LIBRARY="HSRC1"
TARGET_DIR="${REPO_DIR}/${LIBRARY}"
SYNC_SCRIPT="${REPO_DIR}/UTIL_Source_Sync/sync_ibmi_to_git.py"

# Parse arguments
USE_TIMESTAMP=""
if [[ "$1" == "--use-timestamp" ]]; then
    USE_TIMESTAMP="--use-timestamp"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Generate timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}HSRC1 Sync & Push${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
echo -e "Started: ${TIMESTAMP}"
echo ""

# Change to repository directory
echo -e "${YELLOW}📂 Changing to repository directory...${NC}"
cd "${REPO_DIR}"
echo -e "   Current directory: $(pwd)"
echo ""

# Run sync script
echo -e "${YELLOW}🔄 Running sync script for ${LIBRARY}...${NC}"
set +e  # Temporarily disable exit on error to capture exit code
/QOpenSys/pkgs/bin/python3 "${SYNC_SCRIPT}" \
    --library "${LIBRARY}" \
    --target "${TARGET_DIR}" \
    ${USE_TIMESTAMP}
SYNC_EXIT_CODE=$?
set -e  # Re-enable exit on error

# Check exit code
if [ $SYNC_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✓ Sync completed - changes detected${NC}"
    echo ""
elif [ $SYNC_EXIT_CODE -eq 10 ]; then
    echo -e "${GREEN}✓ Sync completed - no source changes detected${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "No Git commit needed (only log files changed)"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
    exit 0
else
    echo -e "${RED}✗ Sync failed with error code ${SYNC_EXIT_CODE}${NC}"
    exit 1
fi

# Check if there are changes to commit
echo -e "${YELLOW}🔍 Checking for changes...${NC}"
if [[ -z $(git status --porcelain) ]]; then
    echo -e "${GREEN}✓ No changes to commit${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
    exit 0
fi

# Stage all changes
echo -e "${YELLOW}📝 Staging changes...${NC}"
git add .
echo -e "${GREEN}✓ Changes staged${NC}"
echo ""

# Show what will be committed
echo -e "${YELLOW}📋 Changes to be committed:${NC}"
git status --short
echo ""

# Commit changes
COMMIT_MSG="HSRC1 Sync - ${TIMESTAMP}"
echo -e "${YELLOW}💾 Committing changes...${NC}"
echo -e "   Message: ${COMMIT_MSG}"
git commit -m "${COMMIT_MSG}"
echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

# Push to remote
echo -e "${YELLOW}⬆️  Pushing to remote...${NC}"
if git push; then
    echo -e "${GREEN}✓ Push completed successfully${NC}"
else
    echo -e "${RED}✗ Push failed${NC}"
    exit 1
fi
echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ HSRC1 sync and push completed successfully${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════════════════${NC}"
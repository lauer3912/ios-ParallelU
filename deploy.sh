#!/bin/bash
# ============================================================
# App Store Deploy Script (using xcrun altool)
# No Fastlane required - pure Apple tooling
# ============================================================
# Usage:
#   ./deploy.sh
#
# Environment variables (or edit below):
#   ASC_USER="support@techidaily.com"
#   ASC_PASS="xnnc-yhpv-gkqe-pzwb"
#   PROVIDER="9L6N2ZF26B"
# ============================================================

set -e

# ---------- Config ----------
ASC_USER="${ASC_USER:-support@techidaily.com}"
ASC_PASS="${ASC_PASS:-xnnc-yhpv-gkqe-pzwb}"
PROVIDER="${PROVIDER:-9L6N2ZF26B}"

APP_NAME="ParallelU"
BUNDLE_ID="com.ggsheng.ParallelU"
SCHEME="ParallelU"
ARCHIVE_NAME="ParallelU"
APP_ID="6762428992"
PLATFORM="ios"
PROJECT_DIR="$HOME/Desktop/ios-ParallelU"
DEPLOY_TYPE="${DEPLOY_TYPE:-appstore}"  # appstore | testflight

# ---------- Colors ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ---------- Pre-flight ----------
log_info "========================================"
log_info "  App Store Deploy Script"
log_info "  App:      ${APP_NAME}"
log_info "  Bundle:   ${BUNDLE_ID}"
log_info "  Scheme:   ${SCHEME}"
log_info "  App ID:   ${APP_ID}"
log_info "  Platform: ${PLATFORM}"
log_info "  Mode:     ${DEPLOY_TYPE}"
log_info "========================================"

if [ ! -d "${PROJECT_DIR}" ]; then
    log_error "Project directory not found: ${PROJECT_DIR}"
    exit 1
fi

cd "${PROJECT_DIR}"
BUILD_DIR="$(pwd)"

# ---------- Step 1: Pull ----------
log_info "=== Step 1: Pull latest code ==="
git pull origin main

# ---------- Step 2: XcodeGen ----------
log_info "=== Step 2: Generate Xcode project ==="
rm -rf "${BUILD_DIR}/${SCHEME}.xcodeproj"
~/tools/xcodegen/bin/xcodegen generate

# ---------- Step 3: Clean & Build ----------
log_info "=== Step 3: Clean & Build (Release) ==="
xcodebuild -project "${BUILD_DIR}/${SCHEME}.xcodeproj" \
    -scheme "${SCHEME}" \
    -configuration Release \
    -destination 'generic/platform=iOS Simulator' \
    clean build \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

# ---------- Step 4: Archive ----------
log_info "=== Step 4: Create Archive ==="
ARCHIVE_PATH="${BUILD_DIR}/${ARCHIVE_NAME}.xcarchive"
xcodebuild -project "${BUILD_DIR}/${SCHEME}.xcodeproj" \
    -scheme "${SCHEME}" \
    -configuration Release \
    -archivePath "${ARCHIVE_PATH}" \
    archive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

if [ ! -f "${ARCHIVE_PATH}" ]; then
    log_error "Archive not created at ${ARCHIVE_PATH}"
    exit 1
fi
log_info "Archive created: ${ARCHIVE_PATH}"

# ---------- Step 5: Validate ----------
log_info "=== Step 5: Validate App ==="
xcrun altool --validate-app \
    -f "${ARCHIVE_PATH}" \
    -t "${PLATFORM}" \
    -u "${ASC_USER}" \
    -p "${ASC_PASS}" \
    --provider "${PROVIDER}" \
    --bundle-id "${BUNDLE_ID}" \
    --apple-id "${APP_ID}"

# ---------- Step 6: Upload ----------
log_info "=== Step 6: Upload to App Store ==="
log_info "  This may take several minutes..."

xcrun altool --upload-app \
    -f "${ARCHIVE_PATH}" \
    -t "${PLATFORM}" \
    -u "${ASC_USER}" \
    -p "${ASC_PASS}" \
    --provider "${PROVIDER}" \
    --bundle-id "${BUNDLE_ID}" \
    --apple-id "${APP_ID}"

log_info "========================================"
log_info "  ✅ Upload Complete!"
log_info "========================================"
log_info "Next steps:"
log_info "  1. App Store Connect: appstoreconnect.apple.com"
log_info "  2. My Apps > ${APP_NAME}"
log_info "  3. Add TestFlight testers & submit for review"
log_info "========================================"

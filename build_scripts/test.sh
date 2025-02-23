#!/bin/bash

PACKAGES_PATH="packages_cache"

if $HAS_PACKAGES_CACHE_HIT; then
    # if we have packages in cache, we skip resolution, via disableAutomaticPackageResolution
  echo "🎉Using cached dependencies"
  set -o pipefail && xcrun xcodebuild test \
    -scheme NodeCrypto \
    -project NodeCrypto/NodeCrypto.xcodeproj \
    -skipPackageUpdates \
    -disableAutomaticPackageResolution \
    -clonedSourcePackagesDirPath "$PACKAGES_PATH" \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=18.1' | # Changed "iPhone 15" to "iPhone 15 Pro"
    xcbeautify --renderer github-actions
else
  # otherwise we run xcodebuild with full spm packages resolution
  echo "Cache not found, loading dependencies 🤕"
  set -o pipefail && xcrun xcodebuild test \
    -scheme NodeCrypto \
    -project NodeCrypto/NodeCrypto.xcodeproj \
    -disableAutomaticPackageResolution \
    -clonedSourcePackagesDirPath "$PACKAGES_PATH" \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=18.1' | # Changed "iPhone 15" to "iPhone 15 Pro"
    xcbeautify --renderer github-actions
fi

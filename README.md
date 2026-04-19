# 🎨 NodeCrypto - NFT Marketplace App

[![Build Status](https://app.bitrise.io/app/2c212f95-0bc5-41ea-bb12-6105ee121e35/status.svg?token=EPrfJe9VmERkf5N2OPzn-A&branch=main)](https://app.bitrise.io/app/2c212f95-0bc5-41ea-bb12-6105ee121e35)
[![Swift Version](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B%20%7C%20macOS%2014%2B-blue.svg)](https://developer.apple.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Architecture](https://img.shields.io/badge/Architecture-TCA-purple.svg)](https://github.com/pointfreeco/swift-composable-architecture)

> 🚀 A modern, feature-rich NFT marketplace iOS application built with SwiftUI and The Composable Architecture (TCA)

### 🎯 Core Functionality
- **🔍 Onboarding** - Get started quickly and explore all app features
- **🔍 NFT Discovery** - Browse and search through extensive NFT collections
- **👛 Wallet Integration** - Connect and manage multiple crypto wallets securely
- **🎨 NFT Creation** - Create your own NFTs with ease
- **👤 Profile** - Showcase your NFT collection and achievements
- **🔔 Notifications** - Stay updated with real-time alerts and updates

### 🌍 User Experience
- **🌐 Internationalization** - Full support for English and French languages
- **📱 Modern UI** - Beautiful SwiftUI interface with smooth animations

### 🔧 Architecture
- **🏗 Modular Architecture** 
- **The Composable Architecture (TCA)**
- **📊 Analytics Integration** - Firebase analytics for insights and monitoring
- **🚀 CI/CD Pipeline** - Automated builds and testing with Bitrise


## 📸 App Screenshots

<!-- SNAPSHOT_GALLERY_START -->
### 👛 Wallet Connection

| **Connect Wallet View Empty** | **Connect Wallet View With Alert** | **Connecting Wallet View** |
| --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ConnectWalletSnapshotsTests/testConnectWalletView_empty.testConnectWalletView_empty.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ConnectWalletSnapshotsTests/testConnectWalletView_withAlert.testConnectWalletView_withAlert.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ConnectWalletSnapshotsTests/testConnectingWalletView.testConnectingWalletView.png" width="180"/> |

### 🎨 NFT Creation

| **Create View Empty** | **Create View Multiple Images Selected** | **Create View Next Button Disabled** | **Create View Next Button Enabled** | **Create View Single Image Selected** |
| --- | --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_empty.test_createView_empty.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_multipleImagesSelected.test_createView_multipleImagesSelected.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_nextButtonDisabled.test_createView_nextButtonDisabled.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_nextButtonEnabled.test_createView_nextButtonEnabled.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_singleImageSelected.test_createView_singleImageSelected.png" width="180"/> |

| **Item Details View Default State** | **Item Details View Fixed Price** | **Item Details View Fr** | **Item Details View Live Auction** | **Item Details View Put On Sale Disabled** |
| --- | --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_defaultState.test_itemDetailsView_defaultState.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_fixedPrice.test_itemDetailsView_fixedPrice.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_fr.test_itemDetailsView_fr.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_liveAuction.test_itemDetailsView_liveAuction.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_putOnSale_disabled.test_itemDetailsView_putOnSale_disabled.png" width="180"/> |

| **Item Details View Unlock Once Purchased Enabled** |
| --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_unlockOncePurchased_enabled.test_itemDetailsView_unlockOncePurchased_enabled.png" width="180"/> |

### 👤 Profile Features

| **Edit Profile Screen** | **Edit Profile Screen Fr** | **Loaded State About Me Tab** | **Loaded State Fr** | **Loaded State On Sale Tab** |
| --- | --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/EditProfileTests/testEditProfileScreen.testEditProfileScreen.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/EditProfileTests/testEditProfileScreen_fr.testEditProfileScreen_fr.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ProfileSnapshotsTests/testLoadedState_aboutMeTab.testLoadedState_aboutMeTab.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ProfileSnapshotsTests/testLoadedState_fr.testLoadedState_fr.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ProfileSnapshotsTests/testLoadedState_onSaleTab.testLoadedState_onSaleTab.png" width="180"/> |

| **Loading State** | **Profile Actions Sheet** |
| --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ProfileSnapshotsTests/testLoadingState.testLoadingState.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ProfileSnapshotsTests/testProfileActionsSheet.testProfileActionsSheet.png" width="180"/> |

### 🏠 Home Features

| **Initial Loading State** | **Loaded State** | **Loaded State Fr** |
| --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/HomeTests/test_initialLoadingState.test_initialLoadingState.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/HomeTests/test_loadedState.test_loadedState.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/HomeTests/test_loadedState_fr.test_loadedState_fr.png" width="180"/> |

### 🔔 Notifications

| **Empty State** | **Loaded State** | **Loaded State Fr** | **Loading State** |
| --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/NotificationsSnapshotsTests/testEmptyState.testEmptyState.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/NotificationsSnapshotsTests/testLoadedState.testLoadedState.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/NotificationsSnapshotsTests/testLoadedState_fr.testLoadedState_fr.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/NotificationsSnapshotsTests/testLoadingState.testLoadingState.png" width="180"/> |

### 🎯 Onboarding

| **Step1 Welcome** | **Step2 Discover** | **Step3 Create** | **Step4 Complete** |
| --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/OnboardingSnapshotsTests/testStep1_welcome.testStep1_welcome.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/OnboardingSnapshotsTests/testStep2_discover.testStep2_discover.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/OnboardingSnapshotsTests/testStep3_create.testStep3_create.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/OnboardingSnapshotsTests/testStep4_complete.testStep4_complete.png" width="180"/> |

### 🎬 Player View

| **Player View Controls Hidden** | **Player View Controls Visible** | **Player View Paused** |
| --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/PlayerViewSnapshotsTests/testPlayerView_controlsHidden.testPlayerView_controlsHidden.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/PlayerViewSnapshotsTests/testPlayerView_controlsVisible.testPlayerView_controlsVisible.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/PlayerViewSnapshotsTests/testPlayerView_paused.testPlayerView_paused.png" width="180"/> |

### 🔍 Search Features

| **Initial State With Search History** | **Initial State With Search History Fr** | **Searching State With No Results** | **Searching State With Results** |
| --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/SearchFeatureTests/testInitialStateWithSearchHistory.testInitialStateWithSearchHistory.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/SearchFeatureTests/testInitialStateWithSearchHistory_fr.testInitialStateWithSearchHistory_fr.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/SearchFeatureTests/testSearchingStateWithNoResults.testSearchingStateWithNoResults.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/SearchFeatureTests/testSearchingStateWithResults.testSearchingStateWithResults.png" width="180"/> |

<!-- SNAPSHOT_GALLERY_END -->

---

## Getting Started with Tuist

This project uses [Tuist](https://tuist.dev) (v4.110.1) for project generation. Xcode project files are generated from Swift manifests and should not be committed.

### Prerequisites

- Xcode 16+
- Tuist 4.110.1+ (`curl -Ls https://install.tuist.io | bash`)

### Setup

```bash
# Install external dependencies (SPM packages)
tuist install

# Generate the Xcode workspace
tuist generate
```

### Development Commands

```bash
# Focus on a single feature for faster iteration
tuist generate HomeFeature

# Build
tuist build --configuration Debug

# Run tests
tuist test --configuration Debug

# Warm binary cache (speeds up subsequent builds)
tuist cache
```

### Module Architecture

```
Foundation Layer (no internal deps):
  Keychain, APIClient, APIClientLive, AuthenticationClient,
  TCAHelpers, SharedModels, SharedViews, StyleGuide

Feature Layer (depends on Foundation):
  OnboardingFeature, HomeFeature, ProfileFeature,
  SearchFeature, CreateFeature, NotificationsFeature, ConnectWalletFeature

App Shell Layer (orchestrates Features):
  AppFeature, Root
```

---

<div align="center">


</div>
                                                                                                                                                                                                                                                              



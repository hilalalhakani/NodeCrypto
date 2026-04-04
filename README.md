# 🎨 NodeCrypto - NFT Marketplace iOS App

[![Build Status](https://app.bitrise.io/app/2c212f95-0bc5-41ea-bb12-6105ee121e35/status.svg?token=EPrfJe9VmERkf5N2OPzn-A&branch=main)](https://app.bitrise.io/app/2c212f95-0bc5-41ea-bb12-6105ee121e35)
[![Swift Version](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg)](https://developer.apple.com/ios/)
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

| **Connect Wallet** | **Connect Wallet Alert** | **Connecting Wallet** |
| --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ConnectWalletSnapshotsTests/test_connectWallet.test_connectWallet.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ConnectWalletSnapshotsTests/test_connectWallet_alert.test_connectWallet_alert.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ConnectWalletSnapshotsTests/test_connectingWallet.test_connectingWallet.png" width="180"/> |

### 🎨 NFT Creation

| **Create View Empty** | **Create View Multiple Images Selected** | **Create View Next Button Disabled** | **Create View Next Button Enabled** | **Create View Single Image Selected** |
| --- | --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_empty.test_createView_empty.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_multipleImagesSelected.test_createView_multipleImagesSelected.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_nextButtonDisabled.test_createView_nextButtonDisabled.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_nextButtonEnabled.test_createView_nextButtonEnabled.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_createView_singleImageSelected.test_createView_singleImageSelected.png" width="180"/> |

| **Item Details View Default State** | **Item Details View Fixed Price** | **Item Details View Live Auction** | **Item Details View Put On Sale Disabled** | **Item Details View Unlock Once Purchased Enabled** |
| --- | --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_defaultState.test_itemDetailsView_defaultState.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_fixedPrice.test_itemDetailsView_fixedPrice.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_liveAuction.test_itemDetailsView_liveAuction.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_putOnSale_disabled.test_itemDetailsView_putOnSale_disabled.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/CreateFeatureSnapshotsTests/test_itemDetailsView_unlockOncePurchased_enabled.test_itemDetailsView_unlockOncePurchased_enabled.png" width="180"/> |

### 👤 Profile Features

| **Edit Profile Screen** | **Edit Menu Pressed** | **Loaded State About View** | **Loaded State On Sales View** | **Loading State** |
| --- | --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/EditProfileTests/testEditProfileScreen.testEditProfileScreen.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ProfileSnapshotsTests/testEditMenuPressed.testEditMenuPressed.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ProfileSnapshotsTests/testLoadedState_aboutView.testLoadedState_aboutView.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ProfileSnapshotsTests/testLoadedState_onSalesView.testLoadedState_onSalesView.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/ProfileSnapshotsTests/testLoadingState.testLoadingState.png" width="180"/> |

### 🏠 Home Features

| **Initial Loading State** | **Received Response** |
| --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/HomeTests/test_initialLoadingState.test_initialLoadingState.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/HomeTests/test_receivedResponse.test_receivedResponse.png" width="180"/> |

### 🔔 Notifications

| **Notifications Empty** | **Notifications Loaded** | **Notifications Loading** |
| --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/NotificationsSnapshotsTests/test_notifications_empty.test_notifications_empty.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/NotificationsSnapshotsTests/test_notifications_loaded.test_notifications_loaded.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/NotificationsSnapshotsTests/test_notifications_loading.test_notifications_loading.png" width="180"/> |

### 🎯 Onboarding

| **Page1** | **Page2** | **Page3** | **Page4** |
| --- | --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/OnboardingSnapshotsTests/testpage1.testpage1.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/OnboardingSnapshotsTests/testpage2.testpage2.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/OnboardingSnapshotsTests/testpage3.testpage3.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/OnboardingSnapshotsTests/testpage4.testpage4.png" width="180"/> |

### 🎬 Player View

| **Player View Controls Hidden** | **Player View Controls Visible** | **Player View Paused** |
| --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/PlayerViewSnapshotsTests/testPlayerView_ControlsHidden.testPlayerView_ControlsHidden.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/PlayerViewSnapshotsTests/testPlayerView_ControlsVisible.testPlayerView_ControlsVisible.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/PlayerViewSnapshotsTests/testPlayerView_Paused.testPlayerView_Paused.png" width="180"/> |

### 🔍 Search Features

| **Initial State With Search History** | **Searching State With No Results** | **Searching State With Results** |
| --- | --- | --- |
| <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/SearchFeatureTests/testInitialStateWithSearchHistory.testInitialStateWithSearchHistory.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/SearchFeatureTests/testSearchingStateWithNoResults.testSearchingStateWithNoResults.png" width="180"/> | <img src="./Packages/Tests/SnapshotsTests/__Snapshots__/SearchFeatureTests/testSearchingStateWithResults.testSearchingStateWithResults.png" width="180"/> |

<!-- SNAPSHOT_GALLERY_END -->

---

<div align="center">


</div>
                                                                                                                                                                                                                                                              



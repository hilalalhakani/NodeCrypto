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
                                                                                                                                                                                                                                                              



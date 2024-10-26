//import ComposableArchitecture
//import ConnectWalletFeature
//import Foundation
//import SnapshotTesting
//import SwiftUI
//import XCTest
//
//#if os(iOS)
//    @available(macOS, unavailable)
//    final class ConnectWalletSnapshotsTests: XCTestCase {
//        @MainActor
//        func test_connectWallet_light() {
//            let connectWalletView = ConnectingWalletView(
//                store: .init(
//                    initialState: .init(wallet: .rainbow),
//                    reducer: {
//                        ConnectingWalletViewReducer()
//                    },
//                    withDependencies: {
//                       // $0.analyticsClient = .consoleLogger
//                        $0.device = .current
//                        $0.encode = .liveValue
//                        $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
//                    }
//                )
//            )
//            .environment(\.colorScheme, .light)
//
//            assertSnapshot(
//                of: connectWalletView,
//                as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//            )
//        }
//
//        @MainActor
//        func test_connectWallet_dark() {
//            let connectWalletView = ConnectingWalletView(
//                store: .init(
//                    initialState: .init(wallet: .rainbow),
//                    reducer: {
//                        ConnectingWalletViewReducer()
//                    },
//                    withDependencies: {
//                      //  $0.analyticsClient = .consoleLogger
//                        $0.device = .current
//                        $0.encode = .liveValue
//                        $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
//                    }
//                )
//            )
//            .environment(\.colorScheme, .dark)
//
//            assertSnapshot(
//                of: connectWalletView,
//                as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//            )
//        }
//
//        @MainActor
//        func test_connectWallet_alert_light() {
//            let store = Store(
//                initialState: ConnectWalletReducer.State(),
//                reducer: {
//                    ConnectWalletReducer()
//                },
//                withDependencies: {
//                   // $0.analyticsClient = .consoleLogger
//                    $0.device = .current
//                    $0.encode = .liveValue
//                    $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
//                    $0.analyticsClient.sendAnalytics = { _ in  }
//                }
//            )
//
//            let connectWalletView = ConnectWalletView(store: store)
//                .environment(\.colorScheme, .light)
//
//            store.send(.view(.onButtonSelect(.coinbase)))
//
//            assertSnapshot(
//                of: connectWalletView,
//                as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//            )
//        }
//
//        @MainActor
//        func test_connectWallet_alert_dark() {
//            let store = Store(
//                initialState: ConnectWalletReducer.State(),
//                reducer: {
//                    ConnectWalletReducer()
//                },
//                withDependencies: {
//                   // $0.analyticsClient = .consoleLogger
//                    $0.device = .current
//                    $0.encode = .liveValue
//                    $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
//                    $0.analyticsClient.sendAnalytics = { _ in  }
//                }
//            )
//
//            let connectWalletView = ConnectWalletView(store: store)
//                .environment(\.colorScheme, .dark)
//
//            store.send(.view(.onButtonSelect(.coinbase)))
//
//            assertSnapshot(
//                of: connectWalletView,
//                as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//            )
//        }
//
//        @MainActor
//        func test_connectingWallet_light() {
//
//            let connectWalletView = ConnectWalletView(
//                store: .init(
//                    initialState: .init(),
//                    reducer: {
//                        ConnectWalletReducer()
//                    },
//                    withDependencies: {
//                       // $0.analyticsClient = .consoleLogger
//                        $0.device = .current
//                        $0.encode = .liveValue
//                        $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
//                    }
//                )
//            )
//            .environment(\.colorScheme, .light)
//
//            assertSnapshot(
//                of: connectWalletView,
//                as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//            )
//        }
//
//        @MainActor
//        func test_connectingWallet_dark() {
//
//            let connectWalletView = ConnectWalletView(
//                store: .init(
//                    initialState: .init(),
//                    reducer: {
//                        ConnectWalletReducer()
//                    },
//                    withDependencies: {
//                        //$0.analyticsClient = .consoleLogger
//                        $0.device = .current
//                        $0.encode = .liveValue
//                        $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
//                    }
//                )
//            )
//            .environment(\.colorScheme, .dark)
//
//            assertSnapshot(
//                of: connectWalletView,
//                as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//            )
//        }
//    }
//#endif

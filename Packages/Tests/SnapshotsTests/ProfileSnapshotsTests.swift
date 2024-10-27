////
////  File.swift
////
////
////  Created by Hilal Hakkani on 20/07/2024.
////
//
//import ComposableArchitecture
//import Foundation
//import ProfileFeature
//import Root
//import SharedModels
//import SnapshotTesting
//import XCTest
//
//#if os(iOS)
//    @available(macOS, unavailable)
//    final class ProfileSnapshotsTests: BaseTestCase {
//        @MainActor
//        func testLoadingState() {
//            let store: StoreOf<ProfileReducer> = .init(initialState: .init()) {
//                ProfileReducer()
//            } withDependencies: {
//                $0.apiClient.profile.getUserInfo = { try await Task.never() }
//                $0.apiClient.profile.getSavedNFT = { try await Task.never() }
//            }
//
//            let profileView = ProfileView(store: store)
//
//            assertSnapshot(
//                of: profileView,
//                as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//            )
//
//        }
//
//        @MainActor
//        func testLoadedState_onSalesView() {
//            withDependencies {
//                $0.apiClient.profile = .mock()
//            } operation: {
//
//                let store: StoreOf<ProfileReducer> = .init(
//                    initialState: .init(
//                        nfts: nfts,
//                        aboutMeItems: aboutmeItems,
//                        isLoading: false,
//                        selectedTitle: MenuItem.onSale
//                    )
//                ) {
//                    ProfileReducer()
//                }
//
//                assertSnapshot(
//                    of: ProfileView(store: store),
//                    as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//                )
//
//            }
//        }
//
//        @MainActor
//        func testLoadedState_aboutView() {
//            withDependencies {
//                $0.apiClient.profile = .mock()
//            } operation: {
//
//                let store: StoreOf<ProfileReducer> = .init(
//                    initialState: .init(
//                        nfts: nfts,
//                        aboutMeItems: aboutmeItems,
//                        isLoading: false,
//                        selectedTitle: MenuItem.aboutMe
//                    )
//                ) {
//                    ProfileReducer()
//                }
//
//                assertSnapshot(
//                    of: ProfileView(store: store),
//                    as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//                )
//
//            }
//        }
//
//        @MainActor
//        func testEditMenuPressed() {
//                let store: StoreOf<RootViewReducer> = .init(
//                    initialState: .init(user: User.mock1, showsProfileActionsList: true)
//                ) {
//                    RootViewReducer()
//                } withDependencies: {
//                    $0.apiClient.profile.getUserInfo = { try await Task.never() }
//                    $0.apiClient.profile.getSavedNFT = { try await Task.never() }
//                }
//
//                UIView.setAnimationsEnabled(false)
//
//                let rootView = RootView(store: store, tab: .profile)
//                    .transaction { transaction in
//                        transaction.animation = nil
//                    }
//
//                assertSnapshot(
//                    of: rootView,
//                    as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe))
//                )
//            }
//
//        //Constants
//        let nfts = [
//            NFT(
//                isNew: true,
//                isVideo: false,
//                imageURL: "https://i.ibb.co/f2nHqtY/1.jpg",
//                videoURL: ""
//            ),
//            NFT(
//                isNew: false,
//                isVideo: true,
//                imageURL: "https://i.ibb.co/ByyHzXW/2.jpg",
//                videoURL: ""
//            ),
//        ]
//
//        let aboutmeItems = [
//            AboutMeItem(
//                title: "Items",
//                count: "24",
//                iconName: "doc",
//                id: UUID()
//            ),
//            AboutMeItem(
//                title: "Collection",
//                count: "24",
//                iconName: "magazine",
//                id: UUID()
//            ),
//            AboutMeItem(
//                title: "Followers",
//                count: "24",
//                iconName: "person",
//                id: UUID()
//            ),
//            AboutMeItem(
//                title: "Following",
//                count: "24",
//                iconName: "person",
//                id: UUID()
//            ),
//        ]
//    }
//
//#endif

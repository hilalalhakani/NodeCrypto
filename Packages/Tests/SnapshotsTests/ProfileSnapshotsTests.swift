//
//  File.swift
//
//
//  Created by Hilal Hakkani on 20/07/2024.
//

import APIClientLive
import ComposableArchitecture
import DependenciesTestSupport
import Foundation
import ProfileFeature
import Root
import SharedModels
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

@Suite(.dependencies {
    $0.continuousClock = .immediate
    $0.apiClient.profile = .mock()
    $0.apiClient.profile.getUserInfo = { try await Task.never() }
    $0.apiClient.profile.getSavedNFT = { try await Task.never() }
    $0.defaultInMemoryStorage = .init()
})
@MainActor
struct ProfileSnapshotsTests {
    @Test
    func testLoadingState() throws {
        @Shared(.user) var user = .mock1
        let store: StoreOf<ProfileFeatureReducer> = .init(initialState: .init()) {
            ProfileFeatureReducer()
        }

        let profileView = ProfileView(store: store)

        try assert(profileView)

    }

    @Test
    func testLoadedState_onSalesView() throws {
        @Shared(.user) var user = .mock1


        let store: StoreOf<ProfileFeatureReducer> = .init(
            initialState: .init(
                nfts: nfts,
                aboutMeItems: aboutmeItems,
                isLoading: false,
                selectedTitle: "on Sale"
            )
        ) {
            ProfileFeatureReducer()
        }

        try assert(ProfileView(store: store))
    }

    @Test
    func testLoadedState_aboutView() throws {
        @Shared(.user) var user = .mock1
        let store: StoreOf<ProfileFeatureReducer> = .init(
            initialState: .init(
                nfts: nfts,
                aboutMeItems: aboutmeItems,
                isLoading: false,
                selectedTitle: "about Me"
            )
        ) {
            ProfileFeatureReducer()
        }

        try assert(ProfileView(store: store))

}

 @Test
func testEditMenuPressed() throws {
    @Shared(.user) var user = .mock1
    let store: StoreOf<RootFeature> = .init(
        initialState: .init(showsProfileActionsList: true)
    ) {
        RootFeature()
    }

    let rootView = RootView(store: store)

    try assert(rootView)

}

//Constants
let nfts = [
    NFT(
        isNew: true,
        isVideo: false,
        imageURL: "app://placeholder",
        videoURL: ""
    ),
    NFT(
        isNew: false,
        isVideo: true,
        imageURL: "app://placeholder",
        videoURL: ""
    ),
]

let aboutmeItems = [
    AboutMeItem(
        title: "Items",
        count: "24",
        iconName: "doc",
        id: UUID()
    ),
    AboutMeItem(
        title: "Collection",
        count: "24",
        iconName: "magazine",
        id: UUID()
    ),
    AboutMeItem(
        title: "Followers",
        count: "24",
        iconName: "person",
        id: UUID()
    ),
    AboutMeItem(
        title: "Following",
        count: "24",
        iconName: "person",
        id: UUID()
    ),
]
}

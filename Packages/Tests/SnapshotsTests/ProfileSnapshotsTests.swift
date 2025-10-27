//
//  File.swift
//
//
//  Created by Hilal Hakkani on 20/07/2024.
//

import ComposableArchitecture
import Foundation
import ProfileFeature
import Root
import SharedModels
import SnapshotTesting
import Testing
import UIKit
import SwiftUI
import APIClientLive

@MainActor
struct ProfileSnapshotsTests {
    @Test
    func testLoadingState() throws {
        @Shared(.user) var user = .mock1
        let store: StoreOf<ProfileReducer> = .init(initialState: .init()) {
            ProfileReducer()
        }// withDependencies: {
         //   $0.apiClient.profile.getUserInfo = { try await Task.never() }
         //   $0.apiClient.profile.getSavedNFT = { try await Task.never() }
      //  }

        let profileView = ProfileView(store: store)

        try assert(profileView)

    }

    @Test
    func testLoadedState_onSalesView() throws {
        @Shared(.user) var user = .mock1


        let store: StoreOf<ProfileReducer> = .init(
            initialState: .init(
                nfts: nfts,
                aboutMeItems: aboutmeItems,
                isLoading: false,
                selectedTitle: "on Sale"
            )
        ) {
            ProfileReducer()
        } withDependencies:  {
            $0.apiClient.profile = .mock()
        }

        try assert(ProfileView(store: store))
    }

    @Test
    func testLoadedState_aboutView() throws {
        @Shared(.user) var user = .mock1
        let store: StoreOf<ProfileReducer> = .init(
            initialState: .init(
                nfts: nfts,
                aboutMeItems: aboutmeItems,
                isLoading: false,
                selectedTitle: "about Me"
            )
        ) {
            ProfileReducer()
        }  withDependencies:  {
            $0.apiClient.profile = .mock()
        }

        try assert(ProfileView(store: store))

}

 @Test
func testEditMenuPressed() throws {
    @Shared(.user) var user = .mock1
    let store: StoreOf<RootViewReducer> = .init(
        initialState: .init(showsProfileActionsList: true)
    ) {
        RootViewReducer()
    } withDependencies: {
        $0.apiClient.profile.getUserInfo = { try await Task.never() }
        $0.apiClient.profile.getSavedNFT = { try await Task.never() }
    }

    let rootView = RootView(store: store)

    try assert(rootView)

}

//Constants
let nfts = [
    NFT(
        isNew: true,
        isVideo: false,
        imageURL: "https://i.ibb.co/f2nHqtY/1.jpg",
        videoURL: ""
    ),
    NFT(
        isNew: false,
        isVideo: true,
        imageURL: "https://i.ibb.co/ByyHzXW/2.jpg",
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

//
//  AllCreatorsView.swift
//
//  Created by Hilal Hakkani on 03/12/2024.
//

import SwiftUI
import ResourceProvider
import SharedModels
import ComposableArchitecture
import TCAHelpers
import StyleGuide

@Reducer
public struct AllCreatorsReducer {
    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        var creators: [Creator] = []

        public init(creators: [Creator]) {
            self.creators = creators
        }
    }

    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)

        public enum ViewAction: Sendable {
            case onAppear
            case followButtonTapped(Creator)
        }

        public enum InternalAction: Sendable {}

        public enum DelegateAction: Sendable {}
    }

    public var body: some ReducerOf<Self> {

        NestedAction(\.view) { state, action in
            switch action {
                case .onAppear:
                    return .none

                case let .followButtonTapped(creator):
                    // make api request here
                    if let creator = state.creators.first(where: { $0.id == creator.id }), let index = state.creators.firstIndex(where: { $0.id == creator.id }) {
                        // Update it locally
                        state.creators[index] = .init(image: creator.image, name: creator.name, price: creator.price, isFollowing: !creator.isFollowing)
                    }
                    return .none
            }
        }

    }
}

public struct AllCreatorsView: View {
    let store: StoreOf<AllCreatorsReducer>

    public init(store: StoreOf<AllCreatorsReducer>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(Array(store.creators.enumerated()), id: \.element) { index, creator in
                    CreatorCardView(
                        creator: creator,
                        index: index,
                        onFollowTapped: {
                            store.send(.view(.followButtonTapped(creator)))
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Best sellers")
        .task {
            store.send(.view(.onAppear))
        }
    }
}

struct CreatorCardView: View {
    let creator: Creator
    let index: Int
    var onFollowTapped: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let url = URL(string: creator.image) {
                    AsyncImageView(url: url)
                        .clipShape(Circle())
                        .overlay(alignment: .topTrailing) {
                            if index < 3 {
                                Circle()
                                    .fill(Color.neutral2)
                                    .frame(width: 20, height: 20)
                                    .overlay {
                                        Text("\(index + 1)")
                                            .font(.custom(FontName.dmSansBold.rawValue, size: 12))
                                            .foregroundStyle(Color.neutral8)
                                    }
                                    .offset(x: 4, y: -4)
                            }
                        }
                } else {
                    Circle()
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 4) {
                Text(creator.name)
                    .font(.custom(FontName.poppinsBold.rawValue, size: 14))
                    .foregroundStyle(Color.neutral2)
                    .lineLimit(1)

                Text(creator.price)
                    .font(.custom(FontName.poppinsRegular.rawValue, size: 12))
                    .foregroundStyle(Color.neutral4)
            }

            Spacer()

            Button(action: onFollowTapped) {
                Text(creator.isFollowing ? "Unfollow" : "Follow")
            }
            .buttonStyle(.borderedProminent)
            .clipShape(.capsule)
            .frame(height: 32)
            .foregroundStyle(Color.neutral2)
            .font(.custom(FontName.dmSansBold.rawValue, size: 12))
            .tint(creator.isFollowing ? Color.neutral6 : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 90, style: .circular)
                    .inset(by: 1)
                    .stroke(Color.neutral6)
            )
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }
}

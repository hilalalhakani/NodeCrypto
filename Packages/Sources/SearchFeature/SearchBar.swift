//
//  SearchBar.swift
//  Main
//
//  Created by Hilal Hakkani on 23/02/2025.
//

import SwiftUI
import ComposableArchitecture
import TCAHelpers

@Reducer
public struct SearchBarReducer {
    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        var searchText: String = ""

        public init(searchText: String = "") {
            self.searchText = searchText
        }
    }

    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum ViewAction: Sendable {
        case clearSearchTextTapped
        case searchButtonTapped
    }

    @CasePathable
    public enum InternalAction: Sendable, Equatable {
        case queryChanged(String)
    }

    @CasePathable
    public enum DelegateAction: Sendable, Equatable {
        case searchSubmitted(query: String)
        case searchTextDidChange(newText: String)
        case searchDidClear
    }

    public var body: some Reducer<State, Action> {
        CombineReducers {
            NestedAction(\.view) { state, viewAction in
                switch viewAction {
                case .clearSearchTextTapped:
                    state.searchText = ""
                        return .run { send in
                            await send(.delegate(.searchDidClear))
                        }
                case .searchButtonTapped:
                    let query = state.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                    return .run { send in
                        await send(.delegate(.searchSubmitted(query: query)))
                    }
                }
            }

            NestedAction(\.internal) { state, internalAction in
                switch internalAction {
                    case let .queryChanged(newQuery):
                        let oldQuery = state.searchText
                        state.searchText = newQuery
                        if oldQuery != newQuery {
                            return .run { send in
                                await send(.delegate(.searchTextDidChange(newText: newQuery)))
                            }
                        }
                        return .none
                }
            }
        }
    }
}

public struct SearchBar: View {
    @Bindable var store: StoreOf<SearchBarReducer>

    public init(store: StoreOf<SearchBarReducer>) {
        self.store = store
    }

    public var body: some View {
            HStack(spacing: 8) {
                HStack {
                    TextField(
                        "Search anything",
                        text: $store.searchText.sending(\.internal.queryChanged)
                    )
                    .textFieldStyle(.plain)
                    .submitLabel(.search)
                    .onSubmit {
                        store.send(.view(.searchButtonTapped))
                    }

                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                .padding(10)
                .overlay(
                    Capsule()
                        .stroke(store.searchText.isEmpty ? Color.neutral6 : Color.primary1, lineWidth: 2)
                )
                .animation(.easeInOut(duration: 0.25), value: store.searchText)

                if !store.searchText.isEmpty {
                    Button(action: {
                        store.send(.view(.clearSearchTextTapped))
                    }) {
                        Text("Cancel")
                            .foregroundStyle(Color.neutral2)
                    }
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        )
                    )
                }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Empty state
        SearchBar(
            store: Store(initialState: SearchBarReducer.State()) {
                SearchBarReducer()
            }
        )

        // Filled state
        SearchBar(
            store: Store(
                initialState: SearchBarReducer.State(searchText: "Bitcoin")
            ) {
                SearchBarReducer()
            }
        )
    }
    .padding()
}

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
    // MARK: - Initialization
    public init() {}

    // MARK: - State
    @ObservableState
    public struct State: Equatable, Sendable {
        var searchText: String = ""

        public init(searchText: String = "") {
            self.searchText = searchText
        }
    }

    // MARK: - Action
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

    // MARK: - Reducer
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

// MARK: - SearchBar
public struct SearchBar: View {
    // MARK: - Properties
    @Bindable var store: StoreOf<SearchBarReducer>

    // MARK: - Initialization
    public init(store: StoreOf<SearchBarReducer>) {
        self.store = store
    }

    // MARK: - Body
    public var body: some View {
        HStack(spacing: 8) {
            searchField
            cancelButton
        }
    }

    // MARK: - Private Methods
    private func onSubmitSearch() {
        store.send(.view(.searchButtonTapped))
    }

    private func onClearSearchText() {
        store.send(.view(.clearSearchTextTapped))
    }

    private var searchField: some View {
        HStack {
            TextField(
                String(localized: "Search anything", bundle: .module),
                text: $store.searchText.sending(\.internal.queryChanged)
            )
            .textFieldStyle(.plain)
            .submitLabel(.search)
            .onSubmit { onSubmitSearch() }

            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
        }
        .padding(10)
        .overlay(
            Capsule()
                .stroke(store.searchText.isEmpty ? Color.neutral6 : Color.primary1, lineWidth: 2)
        )
        .animation(.easeInOut(duration: 0.25), value: store.searchText)
    }

    @ViewBuilder
    private var cancelButton: some View {
        if !store.searchText.isEmpty {
            Button { onClearSearchText() } label: {
                Text("Cancel", bundle: .module)
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

// MARK: - Preview
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

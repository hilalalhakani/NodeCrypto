//
//  SearchBar.swift
//  Main
//
//  Created by Hilal Hakkani on 23/02/2025.
//

import NodeCryptoCore
import SwiftUI

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
    
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case searchTextChanged(String)
        case clearSearchText
        case searchButtonPressed
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .searchTextChanged(text):
                state.searchText = text
                return .none
            case .clearSearchText:
                state.searchText = ""
                return .none
            default:
                return .none
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
                        text: $store.searchText.sending(\.searchTextChanged)
                    )
                    .textFieldStyle(.plain)
                    .submitLabel(.search)
                    .onSubmit {
                        store.send(.searchButtonPressed)
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
                        store.send(.clearSearchText)
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

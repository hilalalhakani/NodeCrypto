//
//  PlayerView.swift
//  Main
//
//  Created by Hilal Hakkani on 02/12/2024.
//

import AVFoundation
import NodeCryptoCore
import ResourceProvider
import StyleGuide
import SwiftUI

@Reducer
public struct PlayerViewReducer {
    @Dependency(\.videoPlayer) var player

    init() {
    }

    @ObservableState
    public struct State: Equatable, Sendable {
        var isPlaying = true
        var areControlsHidden: Bool = false
        var nft: NFTItem
        var sliderState = CustomSliderReducer.State()

        public init(nft: NFTItem) {
            @Dependency(\.videoPlayer) var player
            self.nft = nft
            player.setup(nft.videoURL)
        }
    }

    public enum Action: BindableAction, Sendable {
        case hideControls
        case showControls
        case togglePlayPause
        case stopPlayer
        case binding(BindingAction<State>)
        case slider(CustomSliderReducer.Action)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
                case .hideControls:
                    state.areControlsHidden = true
                    return .none
                case .showControls:
                    state.areControlsHidden = false
                    return .none
                case .togglePlayPause:
                    player.isPlaying() ? player.pause() : player.play()
                    state.isPlaying = player.isPlaying()
                    return .none
                case .stopPlayer:
                    player.destroy()
                    return .none
                case .binding:
                    return .none
                case .slider(_):
                    return .none
            }
        }

        Scope(state: \.sliderState, action: \.slider) {
            CustomSliderReducer()
        }
    }
}

public struct PlayerView: View {

    @Bindable public var store: StoreOf<PlayerViewReducer>

    public init(store: StoreOf<PlayerViewReducer>) {
        self.store = store
    }

    public var body: some View {
        VideoPlayerView()
            .ignoresSafeArea()
            .background {
                Color.black
                    .ignoresSafeArea()
            }
            .onTapGesture {
                store.send(.showControls)
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button(action: {
                        store.send(.stopPlayer)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)

                    Spacer()

                    VStack(spacing: 7) {
                        ItemDetails()

                        HStack {
                            Button(action: { store.send(.togglePlayPause) }) {
                                Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.neutral2)
                            }

                            CustomSlider(
                                store: store.scope(state: \.sliderState, action: \.slider)
                            )

                            Button(action: { store.send(.hideControls) }) {
                                Image(systemName: "arrow.down.right.and.arrow.up.left")
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.neutral2)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(.white)
                        .clipShape(.capsule)

                    }
                    .padding(.vertical, 40)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(store.areControlsHidden ? 0 : 1)
            }
    }
}

#Preview {
    PlayerView(
        store: .init(
            initialState: .init(
                nft: .init(
                    image: "",
                    name: "",
                    creator: "",
                    creatorImage: "",
                    price: "",
                    cryptoPrice: "",
                    videoURL: ""
                )
            ),
            reducer: { PlayerViewReducer() }
        )
    )
}

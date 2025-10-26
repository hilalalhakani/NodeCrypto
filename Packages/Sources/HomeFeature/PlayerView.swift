//
//  PlayerView.swift
//  Main
//
//  Created by Hilal Hakkani on 02/12/2024.
//

import AVFoundation
import NodeCryptoCore
import StyleGuide
import SwiftUI

@Reducer
public struct PlayerViewReducer {
    @Dependency(\.videoPlayer) var player

    @ObservableState
    public struct State: Equatable, Sendable {
        var isPlaying: Bool
        var areControlsHidden: Bool
        var nft: NFTItem
        var sliderState: CustomSliderReducer.State
        var volume: Double = 0.4

        public init(
            isPlaying: Bool = true,
            areControlsHidden: Bool = false,
            nft: NFTItem,
            sliderState: CustomSliderReducer.State = .init()
        ) {
            self.isPlaying = isPlaying
            self.areControlsHidden = areControlsHidden
            self.nft = nft
            self.sliderState = sliderState
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
        case onAppear
        case hideControls
        case showControls
        case togglePlayPause
        case stopPlayer
    }

    @CasePathable
    public enum InternalAction: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case slider(CustomSliderReducer.Action)
        case updateVolume(Double)
    }

    @CasePathable
    public enum DelegateAction: Sendable {
        case playerClosed
    }

    public var body: some ReducerOf<Self> {

        BindingReducer(action: \.internal)

        Scope(state: \.sliderState, action: \.internal.slider) {
            CustomSliderReducer()
        }

        NestedAction(\.view) { state, action in
            switch action {
                case .onAppear:
                    player.load(state.nft.videoURL)
                    return .none

                case .hideControls:
                    state.areControlsHidden = true
                    return .none

                case .showControls:
                    state.areControlsHidden = false
                    return .none

                case .togglePlayPause:
                    let isPlaying = player.isPlaying()
                    isPlaying ? player.pause() : player.play()
                    state.isPlaying = !isPlaying
                    return .none

                case .stopPlayer:
                    player.destroy()
                    return .send(.delegate(.playerClosed))
            }
        }

        NestedAction(\.internal) { state, action in
            switch action {
                case .binding:
                    return .none

                case .slider:
                    return .none

                case .updateVolume(let volume):
                    state.volume = volume
                    player.setVolume(Float(volume))
                    return .none
            }
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
                store.send(.view(.showControls))
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button(action: {
                        store.send(.view(.stopPlayer))
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

                        VStack(spacing: 10) {
                        HStack {
                            Button(action: { store.send(.view(.togglePlayPause)) }) {
                                Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.neutral2)
                            }

                            CustomSlider(
                                store: store.scope(
                                    state: \.sliderState,
                                    action: \.internal.slider
                                )
                            )

                            Button(action: { store.send(.view(.hideControls)) }) {
                                Image(systemName: "arrow.down.right.and.arrow.up.left")
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.neutral2)
                            }
                        }
                        .frame(height: 44)

                        volumeIndicator
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(20)

                    }
                    .padding(.vertical, 40)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(store.areControlsHidden ? 0 : 1)
                .task {
                    store.send(.view(.onAppear))
                }
            }
    }


    @ViewBuilder
    private var volumeIndicator: some View {
        HStack {
            Image(systemName: "speaker.fill")
            Slider(
                value: $store.volume.sending(\.internal.updateVolume), in: 0...1
            )
            Image(systemName: "speaker.wave.3.fill")
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

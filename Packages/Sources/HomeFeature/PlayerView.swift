//
//  PlayerView.swift
//  Main
//
//  Created by Hilal Hakkani on 02/12/2024.
//

import AVFoundation
import StyleGuide
import SwiftUI
import ComposableArchitecture
import SharedModels

@Reducer
public struct PlayerViewReducer {
    // MARK: - Properties
    @Dependency(\.videoPlayer) var player

    // MARK: - State
    @ObservableState
    public struct State: Equatable, Sendable {
        public var isPlaying: Bool
        public var areControlsHidden: Bool
        public var nft: NFTItem
        public var sliderState: CustomSliderReducer.State
        public var volume: Double

        public init(
            isPlaying: Bool = true,
            areControlsHidden: Bool = false,
            nft: NFTItem,
            sliderState: CustomSliderReducer.State = .init(),
            volume: Double = 0.4
        ) {
            self.isPlaying = isPlaying
            self.areControlsHidden = areControlsHidden
            self.nft = nft
            self.sliderState = sliderState
            self.volume = volume
        }
    }

    // MARK: - Action
    @CasePathable
    public enum DelegateAction: Sendable {
        case playerClosed
    }

    @CasePathable
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case delegate(DelegateAction)
        case hideControlsButtonTapped
        case onAppear
        case playPauseButtonTapped
        case showControlsTapped
        case slider(CustomSliderReducer.Action)
        case stopPlayerButtonTapped
    }
    
    // MARK: - Initialization
    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Scope(state: \.sliderState, action: \.slider) {
            CustomSliderReducer()
        }

        Reduce { state, action in
            switch action {
            case .binding(\.volume):
                player.setVolume(Float(state.volume))
                return .none
                
            case .binding:
                return .none

            case .delegate:
                return .none

            case .hideControlsButtonTapped:
                state.areControlsHidden = true
                return .none

            case .onAppear:
                player.load(state.nft.videoURL)
                return .none

            case .playPauseButtonTapped:
                let isPlaying = player.isPlaying()
                isPlaying ? player.pause() : player.play()
                state.isPlaying = !isPlaying
                return .none

            case .showControlsTapped:
                state.areControlsHidden = false
                return .none

            case .slider:
                return .none

            case .stopPlayerButtonTapped:
                player.destroy()
                return .send(.delegate(.playerClosed))
            }
        }
    }
}

public struct PlayerView: View {
    // MARK: - Properties
    @Bindable public var store: StoreOf<PlayerViewReducer>

    // MARK: - Initialization
    public init(store: StoreOf<PlayerViewReducer>) {
        self.store = store
    }

    // MARK: - Body
    public var body: some View {
        VideoPlayerView()
            .ignoresSafeArea()
            .background {
                Color.black
                    .ignoresSafeArea()
            }
            .onTapGesture {
                showControlsTapped()
            }
            .safeAreaInset(edge: .bottom) {
                controlsOverlay
            }
            .task {
                await onAppear()
            }
    }
    
    // MARK: - View Components
    private var controlsOverlay: some View {
        VStack {
            Button(action: stopPlayerButtonTapped) {
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
                        Button(action: playPauseButtonTapped) {
                            Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.neutral2)
                        }

                        CustomSlider(
                            store: store.scope(
                                state: \.sliderState,
                                action: \.slider
                            )
                        )

                        Button(action: hideControlsButtonTapped) {
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
        .animation(.easeInOut(duration: 0.3), value: store.areControlsHidden)
    }

    @ViewBuilder
    private var volumeIndicator: some View {
        HStack {
            Image(systemName: "speaker.fill")
                .foregroundStyle(Color.neutral2)
            Slider(
                value: $store.volume, in: 0...1
            )
            .tint(Color.neutral2)
            Image(systemName: "speaker.wave.3.fill")
                .foregroundStyle(Color.neutral2)
        }
    }
    
    // MARK: - Methods
    private func showControlsTapped() {
        store.send(.showControlsTapped)
    }

    private func stopPlayerButtonTapped() {
        store.send(.stopPlayerButtonTapped)
    }

    private func playPauseButtonTapped() {
        store.send(.playPauseButtonTapped)
    }

    private func hideControlsButtonTapped() {
        store.send(.hideControlsButtonTapped)
    }

    private func onAppear() async {
        store.send(.onAppear)
    }
}

// MARK: - Preview
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

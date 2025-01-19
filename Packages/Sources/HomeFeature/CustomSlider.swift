//
//  CustomSlider.swift
//  Main
//
//  Created by Hilal Hakkani on 03/12/2024.
//

import AVFoundation
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CustomSliderReducer: Sendable {
    @Dependency(\.videoPlayer) var player

    @ObservableState
    public struct State: Equatable, Sendable {
        var totalDuration: Double
        var currentTime: Double
        var playbackRange: ClosedRange<Double>?
        
        public init(
            totalDuration: Double = 0,
            currentTime: Double = 0,
            playbackRange: ClosedRange<Double>? = nil
        ) {
            self.totalDuration = totalDuration
            self.currentTime = currentTime
            self.playbackRange = playbackRange
        }
    }

    public enum Action: Sendable {
        case onAppear
        case sliderPositionChanged(position: CGPoint, containerSize: CGSize)
        case sliderDragEnded
        case videoAssetLoaded(duration: Double)
        case playbackTimeUpdated(CMTime)
    }

    public init() {}

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
                return .run { [player] send in

                    await withThrowingTaskGroup(of: Void.self) { group in
                        group.addTask {
                            for await duration in await player.duration() where duration.isValid {
                                await send(.videoAssetLoaded(duration: duration.seconds))
                            }
                        }

                        group.addTask {
                            for await time in await player.currentTime() where time.isValid {
                                await send(.playbackTimeUpdated(time))
                            }
                        }
                    }
                }

        case let .sliderPositionChanged(position, size):
            guard let range = state.playbackRange else { return .none }
            
            let progress = position.x / size.width
            let newTime = range.lowerBound + progress * (range.upperBound - range.lowerBound)
            let clampedTime = newTime.clamped(to: range)
            state.currentTime = clampedTime
            
            return .run { _ in
                let targetTime = CMTime(seconds: clampedTime, preferredTimescale: 600)
                await player.seek(targetTime)
            }

        case .sliderDragEnded:
            return .none

        case .playbackTimeUpdated(let time):
            print("sec \(time.seconds)")
            state.currentTime = time.seconds
            return .none

        case .videoAssetLoaded(let duration):
            state.totalDuration = duration
            state.playbackRange = 0...duration
            return .none
        }
    }
}

struct CustomSlider: View {
    let trackHeight: CGFloat = 8
    let store: StoreOf<CustomSliderReducer>
    
    init(
        store: StoreOf<CustomSliderReducer>
    ) {
        self.store = store
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                sliderTrack(in: geometry)
                if let range = store.playbackRange {
                    progressBar(in: geometry, range: range)
                }
            }
            .task { store.send(.onAppear) }
        }
        .frame(height: trackHeight)
    }

    @ViewBuilder
    private func sliderTrack(in geometry: GeometryProxy) -> some View {
        Capsule()
            .foregroundStyle(.gray)
            .frame(height: trackHeight)
            .onTapGesture { location in
                handleSliderInteraction(at: location, in: geometry)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        handleSliderInteraction(at: gesture.location, in: geometry)
                    }
                    .onEnded { _ in
                        store.send(.sliderDragEnded)
                    }
            )
            .contentShape(.rect)
    }

    @ViewBuilder
    private func progressBar(in geometry: GeometryProxy, range: ClosedRange<Double>) -> some View {
        let progress = (store.currentTime - range.lowerBound) / (range.upperBound - range.lowerBound)
        Capsule()
            .foregroundStyle(Color.primary1)
            .frame(
                width: CGFloat(progress) * geometry.size.width,
                height: trackHeight
            )
    }
    
    private func handleSliderInteraction(at point: CGPoint, in geometry: GeometryProxy) {
        store.send(.sliderPositionChanged(position: point, containerSize: geometry.size))
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

private extension CMTime {
    var isValid: Bool {
        self != .indefinite && self != .invalid
    }
}

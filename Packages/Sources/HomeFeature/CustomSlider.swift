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
    @Dependency(\.haptics) var haptics

    private enum CancelID { 
        case timeUpdates
    }

    @ObservableState
    public struct State: Equatable, Sendable {
        var duration: Double
        var currentTime: Double
        var isDragging: Bool
        
        public init(
            duration: Double = 0,
            currentTime: Double = 0,
            isDragging: Bool = false
        ) {
            self.duration = duration
            self.currentTime = currentTime
            self.isDragging = isDragging
        }

        var progress: Double {
            guard duration > 0 else { return 0 }
            return currentTime / duration
        }
    }

    public enum Action: Sendable {
        case onAppear
        case gestureStarted
        case gestureChanged(CGPoint, size: CGSize)
        case gestureEnded
        case videoAssetLoaded(duration: Double)
        case playbackTimeUpdated(CMTime)
        case startTimeUpdates
    }

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
                        await send(.startTimeUpdates)
                    }
                }
            }

        case .startTimeUpdates:
            return .run { [player] send in
                for await time in await player.currentTime() where time.isValid {
                    await send(.playbackTimeUpdated(time))
                }
            }
            .cancellable(id: CancelID.timeUpdates)

        case .gestureStarted:
            state.isDragging = true
            haptics.impactOccurred(.light)
            return .cancel(id: CancelID.timeUpdates)

        case let .gestureChanged(point, size):
            guard state.duration > 0 else { return .none }
            
            let progress = point.x / size.width
            let newTime = progress * state.duration
            let clampedTime = newTime.clamped(to: 0...state.duration)
            state.currentTime = clampedTime
            let targetTime = CMTime(seconds: clampedTime, preferredTimescale: 600)
            player.seek(targetTime)
            return .none

        case .gestureEnded:
            state.isDragging = false
            return .send(.startTimeUpdates)

        case let .playbackTimeUpdated(time):
            guard !state.isDragging else { return .none }
            state.currentTime = time.seconds
            return .none

        case let .videoAssetLoaded(duration):
            guard duration > 0 else { return .none }
            state.duration = duration
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
                progressBar(in: geometry)
            }
            .task { 
                store.send(.onAppear)
            }
        }
        .frame(height: trackHeight)
    }
    
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
                        if !store.isDragging {
                            store.send(.gestureStarted)
                        }
                        handleSliderInteraction(at: gesture.location, in: geometry)
                    }
                    .onEnded { _ in
                        store.send(.gestureEnded)
                    }
            )
            .contentShape(.rect)
    }
    
    private func progressBar(in geometry: GeometryProxy) -> some View {
        Capsule()
            .foregroundStyle(Color.primary1)
            .frame(
                width: CGFloat(store.progress) * geometry.size.width,
                height: trackHeight
            )
    }
    
    private func handleSliderInteraction(at point: CGPoint, in geometry: GeometryProxy) {
        store.send(.gestureChanged(point, size: geometry.size))
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

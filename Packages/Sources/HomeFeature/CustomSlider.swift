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
    @Dependency(\.continuousClock) var clock

    @ObservableState
    public struct State: Equatable, Sendable {
        var totalDuration: Double = 0
        var value: Double = 0
        var range: ClosedRange<Double>? = nil
    }

    public enum Action: Sendable {
        case onAppear
        case gestureChanged(CGPoint, size: CGSize)
        case gestureEnded
        case assetLoaded(totalDuration: Double)
        case runTimer
        case updateTimeAndProgressBar
    }

    private enum CancelID { case timer }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {

            case .onAppear:
                return .run { [player] send in
                    let totalDuration = try await player.totalDuration()
                    await send(.assetLoaded(totalDuration: totalDuration))
                    await send(.runTimer)
                }

            case .gestureChanged(let point, let size):
                guard let range = state.range else { return .none }
                let newValue =
                    range.lowerBound + Double(point.x / size.width)
                    * (range.upperBound - range.lowerBound)
                let roundedValue = min(max(newValue, range.lowerBound), range.upperBound)
                state.value = roundedValue
                let targetTime = CMTime(seconds: roundedValue, preferredTimescale: 600)
                player.seek(targetTime)
                return .cancel(id: CancelID.timer)

            case .gestureEnded:
                return .send(.runTimer)

            case .updateTimeAndProgressBar:
                let duration = player.currentTime()
                let seconds = CMTimeGetSeconds(duration)
                state.value = seconds
                print("value \(state.value)")
                return .none

            case .assetLoaded(let totalDuration):
                state.totalDuration = totalDuration
                state.range = 0...totalDuration
                return .none

            case .runTimer:
                return
                    .run { send in
                        for await _ in self.clock.timer(interval: .seconds(0.3)) {
                            await send(.updateTimeAndProgressBar, animation: .easeIn)
                        }
                    }
                    .cancellable(id: CancelID.timer, cancelInFlight: true)
        }
    }
}

struct CustomSlider: View {
    var trackHeight: CGFloat = 8
    var store: StoreOf<CustomSliderReducer>

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                Capsule()
                    .foregroundStyle(.gray)
                    .frame(height: trackHeight)
                    .onTapGesture { gesture in
                        store.send(
                            .gestureChanged(.init(x: gesture.x, y: gesture.y), size: geometry.size)
                        )
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                store.send(.gestureChanged(gesture.location, size: geometry.size))
                            }
                            .onEnded({ _ in
                                store.send(.gestureEnded)
                            })
                    )
                    .contentShape(.rect)

                if let range = store.range {
                    Capsule()
                        .foregroundStyle(Color.primary1)
                        .frame(
                            width: CGFloat(
                                (store.value - range.lowerBound)
                                    / (range.upperBound - range.lowerBound)
                            ) * geometry.size.width,
                            height: trackHeight
                        )
                }
            }
            .task {
                store.send(.onAppear)
            }
        }
        .frame(height: trackHeight)
    }
}

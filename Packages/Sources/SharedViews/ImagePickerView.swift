//
//  ImagePickerView.swift
//  Main
//
//  Created by Hilal Hakkani on 02/01/2025.
//

import ComposableArchitecture
import PhotosUI
import SwiftUI

@Reducer
public struct ImagesPicker {

    public init () {}
    
    public enum PickerMode: Equatable, Sendable {
        case single
        case multiple
    }

    @ObservableState
    public struct State: Equatable, Sendable {
        var pickerItem: PhotosPickerItem?
        var pickerItems = [PhotosPickerItem]()
        var pickerMode: PickerMode
        public init(pickerMode: PickerMode = .single) {
            self.pickerMode = pickerMode
        }
    }

    public enum Delegate: Sendable {
        case loadSingleImage(Image?, Data?)
        case loadMultipleImages([(Image, Data)])
    }

    @CasePathable
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case selectedSinglePhoto(PhotosPickerItem?)
        case loadSingleImage(Result<(Image?, Data?), Error>)
        case selectedMultiplePhotos([PhotosPickerItem])
        case loadMultipleImages(Result<[(Image, Data)], Error>)
        case delegate(Delegate)
    }


    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {

            // MARK: - Single
            case .selectedSinglePhoto(let photo):
                guard let photo else { return .none }

                return .run { send in
                    do {
                        let image = try await photo.loadTransferable(type: Image.self)
                        let data = try await photo.loadTransferable(type: Data.self)
                        await send(.loadSingleImage(.success((image, data))))
                    } catch {
                        await send(.loadSingleImage(.failure(error)))
                    }
                }

                case .loadSingleImage(.success((let data, let image))):
                    return .send(.delegate(.loadSingleImage(data, image)))

            case .loadSingleImage(.failure):
                return .none

            // MARK: - Multiple
            case .selectedMultiplePhotos(let photos):
                return .run { send in
                    do {
                        var images: [(Image, Data)] = []
                        for p in photos {
                            if let img = try await p.loadTransferable(type: Image.self), let data = try await p.loadTransferable(type: Data.self) {
                                images.append((img, data))
                            }
                        }
                        await send(.loadMultipleImages(.success(images)))
                    } catch {
                        await send(.loadMultipleImages(.failure(error)))
                    }
                }

            case .loadMultipleImages(.success(let images)):
                return .send(.delegate(.loadMultipleImages(images)))

            case .loadMultipleImages(.failure):
                return .none

                case .delegate:
                    return .none

            case .binding:
                return .none
            }
        }
    }
}

public struct ImagePickerView<Label: View>: View {
   @Bindable var store: StoreOf<ImagesPicker>
   var label: @Sendable () -> Label

    public init(store: StoreOf<ImagesPicker>, @ViewBuilder label:@escaping  @Sendable () -> Label) {
       self.store = store
       self.label = label
   }

   public var body: some View {
       switch store.state.pickerMode {
           case .single:
               PhotosPicker(
                   selection: $store.pickerItem.sending(\.selectedSinglePhoto),
                   matching: .images,
                   photoLibrary: .shared(),
                   label: label
               )
           case .multiple:
               PhotosPicker(
                   selection: $store.pickerItems.sending(\.selectedMultiplePhotos),
                   matching: .images,
                   photoLibrary: .shared(),
                   label: label
               )
       }
   }
}

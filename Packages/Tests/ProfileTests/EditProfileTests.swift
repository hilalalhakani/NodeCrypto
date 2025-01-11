import ComposableArchitecture
import Combine
import Dependencies
import ProfileFeature
import SharedModels
import Testing
import Foundation
import SwiftUI

@MainActor
struct EditProfileTests {

    @Test func testUpdateProfileSuccess() async {
        @Shared(.user) var user = .mock1

        let image = Image(systemName: "lock.fill")
        let data = Data()
        let lockIsolated = LockIsolated<CheckedContinuation<String, any Error>?>(nil)
        let imageURLString = "https://example.com/new-image.jpg"

        let store = TestStore(
          initialState: EditProfile.State(user: .mock1)
        ) {
          EditProfile()
        } withDependencies: {
          $0.imageUploader.uploadImage = { (data: Data) async throws -> String in
              try await withCheckedThrowingContinuation { cont in
                  lockIsolated.withValue({ $0 = cont })
              }
          }
        }

        // Simulate picking an image
        await store.send(.internal(.imagePicker(.delegate(.loadSingleImage(image, data))))) {
            $0.userImageData = data
            $0.userImage = image
        }

        // Simulate tapping the "Submit" button
        await store.send(.view(.submitButtonTapped))

        // Hide the checkmark
        await store.receive(\.internal.showProfileUpdatedCheckmark, false) {
            $0.isProfileSubmitted = false
        }

        // Disable the view
        await store.receive(\.internal.disableList, true) {
            $0.isDisabled = true
        }

        // Return a response
       lockIsolated.value?.resume(with: .success(imageURLString))

        // Enable the list
        await store.receive(\.internal.imageUploadResponse.success, imageURLString) {
            $0.user.profileImage = imageURLString
        }

        // Show the checkmark
        await store.receive(\.internal.showProfileUpdatedCheckmark, true) {
            $0.isProfileSubmitted = true
        }

        await store.receive(\.internal.disableList, false) {
            $0.isDisabled = false
        }

    }

    @Test func testUpdateProfileFailure() async {
        @Shared(.user) var user = .mock1

        let image = Image(systemName: "lock.fill")
        let data = Data()
        let lockIsolated = LockIsolated<CheckedContinuation<String, any Error>?>(nil)
        let error = NSError(domain: "test", code: 1)

        let store = TestStore(
          initialState: EditProfile.State(user: .mock1)
        ) {
          EditProfile()
        } withDependencies: {
          $0.imageUploader.uploadImage = { (data: Data) async throws -> String in
              try await withCheckedThrowingContinuation { cont in
                  lockIsolated.withValue({ $0 = cont })
              }
          }
        }

        // Simulate picking an image
        await store.send(.internal(.imagePicker(.delegate(.loadSingleImage(image, data))))) {
            $0.userImageData = data
            $0.userImage = image
        }

        // Simulate tapping the "Submit" button
        await store.send(.view(.submitButtonTapped))

        // Hide the checkmark
        await store.receive(\.internal.showProfileUpdatedCheckmark, false) {
            $0.isProfileSubmitted = false
        }

        // Disable the view
        await store.receive(\.internal.disableList, true) {
            $0.isDisabled = true
        }

        // Return a response
       lockIsolated.value?.resume(with: .failure(error))

        // Enable the list
        await store.receive(\.internal.imageUploadResponse) {
            $0.alert = AlertState {
                TextState("Image Upload Failed")
            } actions: {
                ButtonState(action: .dismissAlert) {
                    TextState("OK")
                }
            } message: {
                TextState("The operation couldn’t be completed. (test error 1.)")
            }
        }

        // Show the checkmark
        await store.receive(\.internal.showProfileUpdatedCheckmark, true) {
            $0.isProfileSubmitted = true
        }

        await store.receive(\.internal.disableList, false) {
            $0.isDisabled = false
        }

    }


    @Test func testRemoveImage() async {
        let store = TestStore(
            initialState: EditProfile.State(user: .mock1)
        ) {
            EditProfile()
        }

        await store.send(.view(.removeImageButtonTapped)) {
            $0.alert = AlertState {
                TextState("Remove Profile Image")
            } actions: {
                ButtonState(role: .destructive, action: .confirmRemoveImage) {
                    TextState("Remove")
                }
                ButtonState(role: .cancel, action: .dismissAlert) {
                    TextState("Cancel")
                }
            } message: {
                TextState("Are you sure you want to remove your profile image?")
            }
        }

        await store.send(.internal(.alert(.presented(.confirmRemoveImage)))) {
            $0.alert = nil
            $0.userImage = nil
            $0.userImageData = nil
            $0.user.profileImage = User.mock1.profileImage
        }
    }

    @Test func testUpdateFields() async {
        let store = TestStore(
            initialState: EditProfile.State(user: .mock1)
        ) {
            EditProfile()
        }

        await store.send(.internal(.didUpdateName("New Name"))) {
            $0.user.fullName = "New Name"
        }

        await store.send(.internal(.didUpdateBio("New Bio"))) {
            $0.user.profileDescription = "New Bio"
        }

        await store.send(.internal(.didUpdateEmail("test@example.com"))) {
            $0.user.email = "test@example.com"
        }
    }

    @Test func testNavigationFlow() async {
        let store = TestStore(
            initialState: EditProfile.State(user: .mock1)
        ) {
            EditProfile()
        }

        await store.send(\.view.backButtonTapped)
        await store.receive(\.delegate.didTapBack)
    }
}

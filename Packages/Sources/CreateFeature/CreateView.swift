
import ComposableArchitecture
import StyleGuide
import SwiftUI
import SharedViews

public struct CreateView: View {
    @Bindable var store: StoreOf<CreateFeature>

    public init(store: StoreOf<CreateFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                HStack(spacing: 16) {

                    Circle()
                        .foregroundColor(Color.neutral6)
                        .frame(width: 32, height: 32)
                        .overlay {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .foregroundStyle(Color.neutral2)
                                .frame(width: 7, height: 12)
                                .font(.headline)
                        }
                        .onTapGesture { store.send(.view(.backButtonTapped)) }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("New collectible")
                            .font(Font(FontName.poppinsBold, size: 12))
                            .foregroundColor(.neutral1)
                        HStack(spacing: 8) {
                            Image("Check")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Auto saved")
                                .font(Font(FontName.poppinsBold, size: 12))
                                .foregroundColor(.neutral4)
                        }
                    }
                    Spacer()
                    Button(action: { store.send(.view(.nextButtonTapped)) }) {
                        Text("Next")
                            .font(Font(FontName.poppinsBold, size: 12))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.primary1)
                            .cornerRadius(90)
                    }
                    .opacity(store.isNextButtonEnabled ? 1 : 0.5)
                    .disabled(!store.isNextButtonEnabled)
                }
                .padding(.horizontal, 24)
                .padding(.top, 56)
                .padding(.bottom, 20)

                // Main Content
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Upload File Section
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    Text("1")
                                        .font(Font(FontName.poppinsBold, size: 12))
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .background(Color.neutral1)
                                        .clipShape(Circle())
                                    Text("Upload file")
                                        .font(Font(FontName.poppinsBold, size: 12))
                                        .foregroundColor(.neutral1)
                                }
                                Text("Choose your file to upload")
                                    .font(Font(FontName.poppinsBold, size: 12))
                                    .foregroundColor(.neutral4)
                                    .padding(.leading, 32)
                            }

                            ImagePickerView(
                                store: store.scope(
                                    state: \.picker,
                                    action: \.internal.picker
                                ),
                                label: {
                                    VStack(spacing: 10) {
                                        Image("FileUpload")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        Text("PNG, GIF, WEBP, MP4 or MP3. Max 1Gb.")
                                            .font(Font(FontName.poppinsBold, size: 12))
                                            .foregroundColor(.neutral4)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.vertical, 48)
                                    .background(Color.white)
                                    .cornerRadius(24)
                                }
                            )
                        }
                    }
                    .padding(24)

                    // Image Grid
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose from gallery")
                            .font(Font(FontName.poppinsBold, size: 12))
                            .foregroundColor(.neutral1)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                            ImagePickerView(
                                store: store.scope(
                                    state: \.picker,
                                    action: \.internal.picker
                                ),
                                label: {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.primary1)
                                            .aspectRatio(1, contentMode: .fit)
                                            .cornerRadius(12)
                                        Image("Add")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                }
                            )

                        ForEach(Array(store.galleryImages.enumerated()), id: \.offset) { index, item in
                                item
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .cornerRadius(12)
                                    .clipped()
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .background(Color.connectWalletGradient1.opacity(0.2))
                .cornerRadius(32, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear { store.send(.view(.onAppear)) }
    }
}

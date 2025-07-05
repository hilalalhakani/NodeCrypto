
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
        VStack(spacing: 0) {
            // Top Navigation Bar
            HStack(spacing: 16) {
                Image("ArrowLeft")
                    .resizable()
                    .frame(width: 32, height: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text("New collectible")
                        .font(.custom("Poppins-SemiBold", size: 24))
                        .foregroundColor(.neutral1)
                    HStack(spacing: 8) {
                        Image("Check")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Auto saved")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(.neutral4)
                    }
                }
                Spacer()
                Button(action: { store.send(.view(.nextButtonTapped)) }) {
                    Text("Next")
                        .font(.custom("DMSans-Bold", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.primary1)
                        .cornerRadius(90)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)
            .padding(.bottom, 20)
            .background(Color.white)

            // Main Content
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Upload File Section
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text("1")
                                    .font(.custom("Poppins-SemiBold", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(Color.neutral1)
                                    .clipShape(Circle())
                                Text("Upload file")
                                    .font(.custom("Poppins-Regular", size: 16))
                                    .foregroundColor(.neutral1)
                            }
                            Text("Choose your file to upload")
                                .font(.custom("Poppins-Regular", size: 12))
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
                                        .font(.custom("Poppins-Regular", size: 12))
                                        .foregroundColor(.neutral4)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 48)
                                .background(Color.white)
                                .cornerRadius(24)
                            })
                    }
                }
            }

            // Image Grid
            VStack(alignment: .leading, spacing: 16) {
                Text("Choose from gallery")
                    .font(.custom("Poppins-SemiBold", size: 16))
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

                    ForEach(0..<7) { index in
                        if index < store.galleryImages.count {
                            store.galleryImages[index]
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .cornerRadius(12)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.neutral6)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding(24)

        .background(Color.neutral8)
        .edgesIgnoringSafeArea(.all)
        .background(BackgroundLinearGradient(colors: [.createGradient1, .createGradient2]))
        .onAppear { store.send(.view(.onAppear)) }
    }
}

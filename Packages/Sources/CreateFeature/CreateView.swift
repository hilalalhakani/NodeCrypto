
import ComposableArchitecture
import StyleGuide
import SwiftUI
import SharedViews

public struct CreateView: View {
    // MARK: - Properties
    @Bindable var store: StoreOf<CreateFeature>

    // MARK: - Initialization
    public init(store: StoreOf<CreateFeature>) {
        self.store = store
    }

    // MARK: - Body
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    CreateTopBar(
                        isNextButtonEnabled: store.isNextButtonEnabled,
                        onBack: { store.send(.view(.backButtonTapped)) },
                        onNext: { store.send(.view(.nextButtonTapped)) }
                    )
                    
                    VStack(spacing: 0) {
                        UploadFileSection(
                            selectedImagesCount: store.selectedImages.count,
                            selectedImages: store.selectedImages,
                            picker: ImagePickerView(
                                store: store.scope(
                                    state: \.picker,
                                    action: \.internal.picker
                                ),
                                label: {
                                    VStack(spacing: 10) {
                                        Image("FileUpload")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        Text("PNG, GIF, WEBP, MP4 or MP3. Max 1Gb.", bundle: .module)
                                            .font(Font(FontName.poppinsBold, size: 12))
                                            .foregroundColor(.neutral4)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.vertical, 48)
                                    .background(Color.white)
                                    .cornerRadius(24)
                                }
                            )
                        )
                    }
                    .background(Color.connectWalletGradient1.opacity(0.2))
                    .clipShape(.rect(topLeadingRadius: 32, topTrailingRadius: 32))
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .navigationDestination(
                item: $store.scope(state: \.itemDetails, action: \.internal.itemDetails)
            ) { store in
                ItemDetailsView(store: store)
            }
            .onAppear { store.send(.view(.onAppear)) }
            #if canImport(UIKit)
            .navigationBarHidden(true)
            #endif
        }
    }
}

// MARK: - Subviews

struct CreateTopBar: View {
    let isNextButtonEnabled: Bool
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: onBack) {
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
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text("New collectible", bundle: .module)
                    .font(Font(FontName.poppinsBold, size: 12))
                    .foregroundColor(.neutral1)
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.green)
                    Text("Auto saved", bundle: .module)
                        .font(Font(FontName.poppinsBold, size: 12))
                        .foregroundColor(.neutral4)
                }
            }
            Spacer()
            Button(action: onNext) {
                Text("Next", bundle: .module)
                    .font(Font(FontName.poppinsBold, size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.primary1)
                    .cornerRadius(90)
            }
            .opacity(isNextButtonEnabled ? 1 : 0.5)
            .disabled(!isNextButtonEnabled)
        }
        .padding(.horizontal, 24)
        .padding(.top, 56)
        .padding(.bottom, 20)
    }
}

struct UploadFileSection<Picker: View>: View {
    let selectedImagesCount: Int
    let selectedImages: [CreateFeature.GalleryItem]
    let picker: Picker

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("\(selectedImagesCount)")
                            .font(Font(FontName.poppinsBold, size: 12))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color.neutral1)
                            .clipShape(Circle())
                        Text("Upload file", bundle: .module)
                            .font(Font(FontName.poppinsBold, size: 12))
                            .foregroundColor(.neutral1)
                    }
                    Text("Choose your file to upload", bundle: .module)
                        .font(Font(FontName.poppinsBold, size: 12))
                        .foregroundColor(.neutral4)
                        .padding(.leading, 32)
                }

                if selectedImages.isEmpty {
                    picker
                        .transition(.opacity)
                } else {
                    SelectedImagesContent(items: selectedImages)
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
            }
            .frame(maxHeight: .infinity)
        }
        .padding(24)
        .frame(maxHeight: .infinity)
    }
}

struct SelectedImagesContent: View {
    let items: [CreateFeature.GalleryItem]

    var body: some View {
        if items.count == 1, let item = items.first {
            SingleImageView(item: item)
        } else {
            MultipleImagesCarousel(items: items)
        }
    }
}

struct SingleImageView: View {
    let item: CreateFeature.GalleryItem

    var body: some View {
        item.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct MultipleImagesCarousel: View {
    let items: [CreateFeature.GalleryItem]

    var body: some View {
        TabView {
            ForEach(items) { item in
                item.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 4)
            }
        }
        #if canImport(UIKit)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        #endif
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

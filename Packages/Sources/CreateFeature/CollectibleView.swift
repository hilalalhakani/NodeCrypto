import ComposableArchitecture
import StyleGuide
import SwiftUI
import SharedViews

public struct CollectibleView: View {
    // MARK: - Properties
    @Bindable var store: StoreOf<CollectibleFeature>

    // MARK: - Initialization
    public init(store: StoreOf<CollectibleFeature>) {
        self.store = store
    }

    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    // MARK: - Body
    public var body: some View {
        ZStack {
            Color.neutral8
                .ignoresSafeArea()

            VStack(spacing: 0) {
                CollectibleTopBar(
                    onBack: { store.send(.view(.backButtonTapped)) }
                )

                BottomSheetBackground(cornerRadius: 32) {
                    CollectibleGridContent(store: store, columns: columns)
                }
            }

            VStack {
                Spacer()
                Button {
                    store.send(.view(.uploadItemTapped))
                } label: {
                    Text("Upload item", bundle: .module)
                        .font(Font(FontName.dmSansBold, size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Color.primary1)
                        .cornerRadius(90)
                        .shadow(color: Color.black.opacity(0.12), radius: 32, x: 0, y: 40)
                }
                .disabled(store.selectedCollectionId == nil)
                .opacity(store.selectedCollectionId == nil ? 0.6 : 1.0)
                .padding(.bottom, 24)
            }
        }
        #if canImport(UIKit)
        .navigationBarHidden(true)
        #endif
    }
}

// MARK: - Subviews

struct CollectibleGridContent: View {
    @Bindable var store: StoreOf<CollectibleFeature>
    let columns: [GridItem]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                CollectibleHeader()
                
                gridContent
                
                Spacer().frame(height: 100) // Padding for sticky bottom button if implemented that way, or just spacing
            }
            .padding(24)
        }
    }

    private var gridContent: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            // First "Create collection" Item
            createCollectionButton
            
            // Collection Items
            ForEach(store.collections) { item in
                collectionButton(for: item)
            }
        }
    }

    private var createCollectionButton: some View {
        Button {
            store.send(.view(.createCollectionTapped))
        } label: {
            CreateCollectionCell()
        }
        .buttonStyle(.plain)
    }

    private func collectionButton(for item: CollectibleFeature.CollectionItem) -> some View {
        Button {
                store.send(.view(.collectionTapped(item.id)))
        } label: {
            CollectionCell(
                item: item,
                isSelected: store.selectedCollectionId == item.id
            )
        }
        .buttonStyle(.plain)
    }
}

struct CollectibleTopBar: View {
    let onBack: () -> Void

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
                    .font(Font(FontName.poppinsBold, size: 24))
                    .foregroundColor(.neutral2)
                HStack(spacing: 8) {
                    Image("Check", bundle: .module)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Auto saved", bundle: .module)
                        .font(Font(FontName.poppinsRegular, size: 12))
                        .foregroundColor(.neutral3)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
        .padding(.bottom, 20)
    }
}

struct CollectibleHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text("2")
                    .font(Font(FontName.poppinsBold, size: 12))
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .background(Color.neutral2)
                    .clipShape(Circle())
                
                Text("Collection", bundle: .module)
                    .font(Font(FontName.poppinsRegular, size: 16))
                    .foregroundColor(.neutral2)
                    .lineLimit(1)
            }
            Text("Choose an existing collection or create a new one", bundle: .module)
                .font(Font(FontName.poppinsRegular, size: 12))
                .foregroundColor(.neutral4)
                .padding(.leading, 32)
        }
    }
}

struct CreateCollectionCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Circle()
                .fill(Color.neutral2)
                .frame(width: 32, height: 32)
                .overlay {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                }
            Spacer()
            Text("Create\ncollection", bundle: .module)
                .font(Font(FontName.dmSansBold, size: 14))
                .foregroundColor(.neutral2)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 160)
        .background(Color.neutral7)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.neutral4, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
        )
    }
}

struct CollectionCell: View {
    let item: CollectibleFeature.CollectionItem
    let isSelected: Bool
    
    var body: some View {
        Image(item.imageName, bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.3), Color.clear, Color.black.opacity(0.4)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                VStack(alignment: .leading) {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    
                    Spacer()
                    
                    Text(item.title)
                        .font(Font(FontName.dmSansBold, size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }
                .padding(20),
                alignment: .topLeading
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 160)
            .cornerRadius(16)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.primary1 : Color.clear, lineWidth: 4)
            )
    }
}



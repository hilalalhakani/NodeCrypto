import ComposableArchitecture
import StyleGuide
import SwiftUI
import TCAHelpers
import SharedViews

public struct ItemDetailsView: View {
    @Bindable var store: StoreOf<ItemDetailsFeature>

    enum Field: Hashable {
        case label, description, price
    }

    @FocusState fileprivate var focusedField: Field?

    public init(store: StoreOf<ItemDetailsFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Color.neutral8
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focusedField = nil
                }

            VStack(spacing: 0) {
                ItemDetailsTopBar(
                    onBack: { store.send(.view(.backButtonTapped)) },
                    onNext: { store.send(.view(.nextButtonTapped)) }
                )

                BottomSheetBackground(cornerRadius: 32) {
                    VStack(alignment: .leading, spacing: 32) {
                        ItemDetailsHeader()
                        
                        LabelFieldSection(
                            text: $store.label.sending(\.view.labelChanged),
                            focusedField: $focusedField
                        )
                        
                        DescriptionFieldSection(
                            text: $store.description.sending(\.view.descriptionChanged),
                            focusedField: $focusedField
                        )
                        
                        PriceTypeSelector(
                            isFixedPrice: store.isFixedPrice,
                            onFixedPrice: { store.send(.view(.fixedPriceTapped)) },
                            onLiveAuction: { store.send(.view(.liveAuctionTapped)) }
                        )
                        
                        PricingGridSection(
                            price: $store.price.sending(\.view.priceChanged),
                            currency: store.currency,
                            royalties: store.royalties,
                            onCurrencyChange: { store.send(.view(.currencyChanged($0))) },
                            onRoyaltiesChange: { store.send(.view(.royaltiesChanged($0))) },
                            focusedField: $focusedField
                        )
                        
                        TogglesSection(
                            isUnlockOncePurchased: $store.isUnlockOncePurchased.sending(\.view.unlockOncePurchasedChanged),
                            isPutOnSale: $store.isPutOnSale.sending(\.view.putOnSaleChanged)
                        )
                    }
                    .padding(24)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = nil
                    }
                }
            }
        }
        .navigationDestination(
            item: $store.scope(state: \.collectible, action: \.internal.collectible)
        ) { store in
            CollectibleView(store: store)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Subviews

struct ItemDetailsTopBar: View {
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
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
                .onTapGesture { onBack() }

            VStack(alignment: .leading, spacing: 4) {
                Text("New collectible")
                    .font(Font(FontName.poppinsBold, size: 12))
                    .foregroundColor(.neutral1)
                HStack(spacing: 8) {
                    Image("Check", bundle: .module)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Auto saved")
                        .font(Font(FontName.poppinsBold, size: 12))
                        .foregroundColor(.neutral4)
                }
            }
            Spacer()
            Button(action: onNext) {
                Text("Next")
                    .font(Font(FontName.poppinsBold, size: 12))
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
    }
}

struct ItemDetailsHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text("2")
                    .font(Font(FontName.poppinsBold, size: 12))
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .background(Color.neutral2)
                    .clipShape(Circle())
                
                Text("Item details")
                    .font(Font(FontName.poppinsBold, size: 16))
                    .foregroundColor(.neutral2)
                    .lineLimit(1)
            }
            Text("Describe your item")
                .font(Font(FontName.poppinsRegular, size: 12))
                .foregroundColor(.neutral4)
                .padding(.leading, 32)
        }
    }
}

struct LabelFieldSection: View {
    @Binding var text: String
    @FocusState.Binding var focusedField: ItemDetailsView.Field?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("LABEL")
                .font(Font(FontName.poppinsBold, size: 12))
                .foregroundColor(.neutral5)
            
            TextField("e. g. \"Redeemable Bitcoin Card with...", text: $text)
                .focused($focusedField, equals: .label)
                .font(Font(FontName.poppinsRegular, size: 14))
                .foregroundColor(.neutral4)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
        }
    }
}

struct DescriptionFieldSection: View {
    @Binding var text: String
    @FocusState.Binding var focusedField: ItemDetailsView.Field?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DESCRIPTION")
                .font(Font(FontName.poppinsBold, size: 12))
                .foregroundColor(.neutral5)
            
            TextField("e. g. “After purchasing you will able...", text: $text, axis: .vertical)
                .focused($focusedField, equals: .description)
                .font(Font(FontName.poppinsRegular, size: 14))
                .foregroundColor(.neutral4)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(height: 96, alignment: .topLeading)
                .background(Color.white)
                .cornerRadius(12)
        }
    }
}

struct PriceTypeSelector: View {
    let isFixedPrice: Bool
    let onFixedPrice: () -> Void
    let onLiveAuction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onFixedPrice) {
                Text("Fixed price")
                    .font(Font(FontName.dmSansBold, size: 14))
                    .foregroundColor(isFixedPrice ? .white : .neutral2)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(isFixedPrice ? Color.neutral2 : Color.neutral6)
                    .cornerRadius(90)
            }
            
            Button(action: onLiveAuction) {
                Text("Live auction")
                    .font(Font(FontName.dmSansBold, size: 14))
                    .foregroundColor(!isFixedPrice ? .white : .neutral2)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(!isFixedPrice ? Color.neutral2 : Color.neutral6)
                    .cornerRadius(90)
            }
        }
    }
}

struct PricingGridSection: View {
    @Binding var price: String
    let currency: String
    let royalties: String
    let onCurrencyChange: (String) -> Void
    let onRoyaltiesChange: (String) -> Void
    @FocusState.Binding var focusedField: ItemDetailsView.Field?

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                Text("FIXED PRICE")
                    .font(Font(FontName.poppinsBold, size: 12))
                    .foregroundColor(.neutral5)
                
                HStack {
                    TextField("1", text: $price)
                        .focused($focusedField, equals: .price)
                        .font(Font(FontName.poppinsBold, size: 14))
                        .foregroundColor(.neutral2)
                        .keyboardType(.decimalPad)
                        .layoutPriority(0)
                    
                    Menu {
                        Button(action: { onCurrencyChange("ETH") }) { Text("Ethereum") }
                        Button(action: { onCurrencyChange("BTC") }) { Text("Bitcoin") }
                        Button(action: { onCurrencyChange("LTC") }) { Text("Litecoin") }
                        Button(action: { onCurrencyChange("SOL") }) { Text("Solana") }
                        Button(action: { onCurrencyChange("USDC") }) { Text("USDC") }
                        Button(action: { onCurrencyChange("USDT") }) { Text("Tether") }
                    } label: {
                        HStack(spacing: 4) {
                            Image("ETH", bundle: .module)
                                .resizable()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.primary4)
                            
                            Text(currency)
                                .font(Font(FontName.poppinsBold, size: 14))
                                .foregroundColor(.primary4)
                                .fixedSize()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.primary4)
                                .font(.system(size: 10))
                        }
                    }
                    .layoutPriority(1)
                }
                .padding(.vertical, 12)
                .padding(.leading, 16)
                .padding(.trailing, 12)
                .background(Color.white)
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("ROYALTIES")
                    .font(Font(FontName.poppinsBold, size: 12))
                    .foregroundColor(.neutral5)
                
                Menu {
                    Button("0%", action: { onRoyaltiesChange("0") })
                    Button("5%", action: { onRoyaltiesChange("5") })
                    Button("10%", action: { onRoyaltiesChange("10") })
                    Button("15%", action: { onRoyaltiesChange("15") })
                    Button("20%", action: { onRoyaltiesChange("20") })
                    Button("25%", action: { onRoyaltiesChange("25") })
                } label: {
                    HStack(spacing: 4) {
                        Text("\(royalties)%")
                            .font(Font(FontName.poppinsBold, size: 14))
                            .foregroundColor(.neutral2)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.neutral2)
                            .font(.system(size: 10))
                    }
                }
                .padding(.vertical, 12)
                .padding(.leading, 16)
                .padding(.trailing, 12)
                .background(Color.white)
                .cornerRadius(12)
            }
        }
    }
}

struct TogglesSection: View {
    @Binding var isUnlockOncePurchased: Bool
    @Binding var isPutOnSale: Bool

    var body: some View {
        VStack(spacing: 32) {
            ToggleRow(
                title: "Unlock once purchased",
                subtitle: "Content will be unlocked after successful transaction",
                isOn: $isUnlockOncePurchased
            )
            
            ToggleRow(
                title: "Put on sale",
                subtitle: "You’ll receive bids on this item",
                isOn: $isPutOnSale
            )
        }
    }
}

fileprivate struct ToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font(FontName.poppinsBold, size: 16))
                    .foregroundColor(.neutral2)
                Text(subtitle)
                    .font(Font(FontName.poppinsRegular, size: 12))
                    .foregroundColor(.neutral4)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color.primary1)
        }
    }
}

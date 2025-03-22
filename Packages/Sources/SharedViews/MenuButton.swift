import SwiftUI
import StyleGuide

public struct ExpandingMenuButton: View {
    @State public var isExpanded = false
    @Binding public var selectedTitle: String
    public var titles: [String]

    public init(selectedTitle: Binding<String>, titles: [String]) {
        self._selectedTitle = selectedTitle
        self.titles = titles
    }

    public var body: some View {
        VStack(spacing: 16) {
            ForEach(isExpanded ? titles : [selectedTitle], id: \.self) { menuItem in
                Cell(title: menuItem, isSelected: selectedTitle == menuItem)
                    .contentShape(.rect)
                    .onTapGesture {
                        if isExpanded, selectedTitle == menuItem {
                            isExpanded = false
                        } else {
                            selectedTitle = menuItem
                            isExpanded.toggle()
                        }
                    }
            }
        }
        .fixedSize()
        .transition(.opacity)
        .padding(16)
        .background(
            Color.glassDark
        )
        .clipShape(
            RoundedRectangle(cornerRadius: !isExpanded ? 48 : 20, style: .circular)
        )
        .padding(16)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    struct Cell: View {
        let title: String
        let isSelected: Bool

        var body: some View {
            HStack(spacing: 40) {
                Text(title)
                    .frame(alignment: .leading)

                Spacer()

                if  isSelected {
                    Image(systemName: "checkmark")
                }
            }
            .font(.custom(FontName.poppinsRegular.rawValue, size: 14))
            .foregroundStyle(Color.neutral8)
        }
    }
}

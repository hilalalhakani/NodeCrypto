import Foundation
import SwiftUI

public enum FontName: String {
    case dmSansRegular = "DMSans-Regular"
    case dmSansBold = "DMSans-Bold"
    case poppinsRegular = "Poppins-Regular"
    case poppinsBold = "Poppins-Bold"
}

public extension Font {
    init(
        _ fontName: FontName,
        size: CGFloat? = nil,
        relativeTo textStyle: TextStyle = .body,
        bundle: Bundle? = nil
    ) {
        #if canImport(UIKit)
            let fontSize = size ?? UIFont.systemFontSize
            UIFont.registerFont(
                bundle: bundle ?? .module,
                fontName: fontName.rawValue,
                fontExtension: "ttf"
            )
        #else
            let fontSize = size ?? 12
        #endif
        self = Font.custom(
            fontName.rawValue,
            size: fontSize,
            relativeTo: textStyle
        )
    }
}

#if DEBUG
    struct Font_Previews: PreviewProvider {
        static var previews: some View {
            return VStack(alignment: .leading, spacing: 12) {
                ForEach(
                    [
                        FontName.poppinsRegular,
                        FontName.dmSansRegular,
                        FontName.poppinsBold,
                        FontName.dmSansBold
                    ],

                    id: \.self
                ) { fontName in
                    Text(verbatim: "Today’s daily challenge")
                        .font(Font(fontName, size: 22))
                }
            }
        }
    }
#endif

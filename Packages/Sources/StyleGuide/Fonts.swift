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
        size: CGFloat
    ) {
#if canImport(UIKit)
        UIFont.registerFont(
            bundle: .module,
            fontName: fontName.rawValue,
            fontExtension: "ttf"
        )
#elseif canImport(AppKit)
        NSFont.registerFont(
            bundle: .module,
            fontName: fontName.rawValue,
            fontExtension: "ttf"
        )
#endif
        self = Font.custom(fontName.rawValue, size: size)
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
                    Text(verbatim: "Today's daily challenge")
                        .font(Font(fontName, size: 22))
                }
            }
        }
    }
#endif

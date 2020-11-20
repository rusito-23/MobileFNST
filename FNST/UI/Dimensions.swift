import UIKit

struct Dim {

    // MARK: - Size

    struct Size {
        static let typeSmall: CGFloat = 16
        static let small: CGFloat = 32
        static let typeMedium: CGFloat = 60
        static let medium: CGFloat = 80
        static let large: CGFloat = 126
        static let xLarge: CGFloat = 250
    }

    // MARK: - Spacing

    struct Spacing {
        static let typeSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let typeMedium: CGFloat = 12
        static let medium: CGFloat = 16
        static let typeLarge: CGFloat = 18
        static let large: CGFloat = 32
        static let typeXLarge: CGFloat = 50
        static let xLarge: CGFloat = 64
    }

    // MARK: - Line Width

    struct LineWidth {
        static let small: CGFloat = 3
        static let medium: CGFloat = 5
        static let big: CGFloat = 7
    }
}

// MARK: - CGFloat Utils

extension CGFloat {
    var size: CGSize { CGSize(width: self, height: self) }
}

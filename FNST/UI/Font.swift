import UIKit

struct Font {

    // MARK: - Constants

    private struct Constants {
        static let name = "AvenirNext-Heavy"
    }

    // MARK: - Fonts

    static var title: UIFont { with(size: .extraLarge) }
    static var subtitle: UIFont { with(size: .medium) }
    static var body: UIFont { with(size: .small) }
    static var bodySmall: UIFont { with(size: .extraSmall) }
    static var button: UIFont { with(size: .small) }
    static var tiny: UIFont { with(size: .tiny) }

    // MARK: - Size

    private enum Size: CGFloat {
        case extraLarge = 120.0
        case large = 64.0
        case medium = 32.0
        case small = 23.0
        case extraSmall = 17.0
        case tiny = 12.0
    }

    // MARK: - Methods

    private static func with(size: Size) -> UIFont {
        return UIFont(
            name: Constants.name,
            size: size.rawValue
        ) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
}

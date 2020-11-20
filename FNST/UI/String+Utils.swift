import Foundation

extension String {

    /// Localize string
    var localized: String {
        NSLocalizedString(self, comment: self)
    }

    /// Capitalize
    var capitalized: String {
        prefix(1).capitalized + dropFirst()
    }
}

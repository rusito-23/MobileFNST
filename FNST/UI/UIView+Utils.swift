import UIKit

extension UIView {

    // MARK: - Properties

    var margins: UILayoutGuide { layoutMarginsGuide }

    // MARK: - Methods

    func addSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}

extension UIStackView {

    // MARK: - Methods

    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(view)
        }
    }
}

import UIKit

final class StyleCell: UICollectionViewCell {

    // MARK: - Properties

    var icon: UIImage? {
        get { return iconView.image }
        set { iconView.image = newValue?.withTintColor(.white) }
    }

    var name: String? {
        get { return nameLabel.text }
        set { nameLabel.text = newValue?.capitalized }
    }

    override var isSelected: Bool {
        didSet {
            iconView.layer.borderColor = isSelected ?
                UIColor.orange.cgColor :
                UIColor.white.cgColor
        }
    }

    // MARK: - Constants

    struct Constants {
        static let reuseIdentifier = "StyleCell"
        static let size: CGFloat = 100
    }

    // MARK: - Subviews

    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.borderWidth = Dim.LineWidth.small
        view.layer.cornerRadius = Dim.Size.typeMedium / 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = Font.tiny
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(iconView, nameLabel)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        iconView.top(to: self)
        iconView.centerX(to: self)
        iconView.size(Dim.Size.typeMedium.size)

        nameLabel.topToBottom(of: iconView)
        nameLabel.bottom(to: self)
        nameLabel.leading(to: self)
        nameLabel.trailing(to: self)
    }

}

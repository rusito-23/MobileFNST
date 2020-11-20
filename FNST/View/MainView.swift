import UIKit
import TinyConstraints

final class MainView: UIView {

    // MARK: - Constants

    private struct Constants {
        struct ImageBorder {
            static let radius: CGFloat = 20
            static let opacity: Float = 0.8
            static let corner: CGFloat = 100
            static let inset: CGFloat = 5
        }
    }

    // MARK: - Subviews

    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(.camera, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = Dim.LineWidth.small
        button.layer.cornerRadius = Dim.Size.medium / 2
        return button
    }()

    lazy var galleryButton: UIButton = {
        let button = UIButton()
        button.setImage(.photo, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = Dim.LineWidth.small
        button.layer.cornerRadius = Dim.Size.medium / 2;
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(
            string: "APP_TITLE".localized,
            attributes: [
                NSAttributedString.Key.strokeColor : UIColor.orange,
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.strokeWidth : 4,
                NSAttributedString.Key.font : Font.title
            ]
        )
        return label
    }()

    private lazy var centerImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "rain-princess-painting")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()

    private lazy var centerImageGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = centerImageView.bounds
        gradient.shadowRadius = Constants.ImageBorder.radius
        gradient.shadowOpacity = Constants.ImageBorder.opacity
        gradient.shadowOffset = .zero
        gradient.shadowColor = UIColor.orange.cgColor
        gradient.shadowPath = CGPath(
            roundedRect: centerImageView.bounds.insetBy(
                dx: Constants.ImageBorder.inset,
                dy: Constants.ImageBorder.inset
            ),
            cornerWidth: Constants.ImageBorder.corner,
            cornerHeight: Constants.ImageBorder.corner,
            transform: nil
        )
        return gradient
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "GET_STARTED".localized
        label.font = Font.bodySmall
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        addSubviews(
            titleLabel,
            centerImageView,
            subtitleLabel,
            galleryButton,
            cameraButton
        )

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        // update center image soft borders
        centerImageGradient.frame = centerImageView.bounds
        centerImageView.layer.mask = centerImageGradient
    }

    // MARK: - Private methods

    private func setupConstraints() {
        titleLabel.top(to: margins)
        titleLabel.leading(to: margins)
        titleLabel.trailing(to: margins)

        centerImageView.centerInSuperview()
        centerImageView.size(Dim.Size.xLarge.size)

        galleryButton.leading(to: margins, offset: Dim.Spacing.typeXLarge)
        galleryButton.bottom(to: margins, offset: -Dim.Spacing.xLarge)
        galleryButton.size(Dim.Size.medium.size)

        cameraButton.trailing(to: margins, offset: -Dim.Spacing.typeXLarge)
        cameraButton.bottom(to: margins, offset: -Dim.Spacing.xLarge)
        cameraButton.size(Dim.Size.medium.size)

        subtitleLabel.bottomToTop(of: galleryButton, offset: -Dim.Spacing.large)
        subtitleLabel.leading(to: margins, offset: Dim.Spacing.medium)
        subtitleLabel.trailing(to: margins, offset: -Dim.Spacing.medium)
    }
}

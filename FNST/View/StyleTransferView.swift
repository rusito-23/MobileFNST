import UIKit

final class StyleTransferView: UIView {

    // MARK: - Constants

    private struct Constants {
        struct StylesCollection {
            static let alpha: CGFloat = 0.5
        }
    }

    // MARK: - Subviews

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(.share, for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.leftArrow, for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()

    lazy var stylesCollectionLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    lazy var stylesCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: stylesCollectionLayout)
        view.allowsMultipleSelection = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.black.withAlphaComponent(Constants.StylesCollection.alpha)
        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        addSubviews(
            imageView,
            backButton,
            shareButton,
            stylesCollectionView
        )

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        imageView.edgesToSuperview()

        backButton.leading(to: margins, offset: Dim.Spacing.medium)
        backButton.top(to: margins, offset: Dim.Spacing.medium)

        shareButton.trailing(to: margins, offset: -Dim.Spacing.medium)
        shareButton.top(to: margins, offset: Dim.Spacing.medium)

        stylesCollectionView.bottom(to: margins)
        stylesCollectionView.leading(to: self)
        stylesCollectionView.trailing(to: self)
        stylesCollectionView.height(Dim.Size.large)
    }

}

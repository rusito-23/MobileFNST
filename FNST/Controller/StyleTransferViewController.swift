import UIKit
import SwiftSpinner

final class StyleTransferViewController: UIViewController {

    // MARK: - Properties

    private var source: UIImage
    private var styles = TransferHandler.Style.allCases
    private var selectedStyle = 0
    private lazy var transferHandler: TransferHandler = {
        let handler = TransferHandler()
        handler.delegate = self
        handler.start()
        return handler
    }()

    // MARK: - Subviews

    private lazy var styleTransferView = StyleTransferView()
    private var resultView: UIImageView { styleTransferView.imageView }
    private var backButton: UIButton { styleTransferView.backButton }
    private var shareButton: UIButton { styleTransferView.shareButton }
    private var stylesCollectionView: UICollectionView { styleTransferView.stylesCollectionView }

    // MARK: - Initializers

    init(_ source: UIImage) {
        self.source = source
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        view = styleTransferView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        resultView.image = source

        stylesCollectionView.delegate = self
        stylesCollectionView.dataSource = self
        stylesCollectionView.register(StyleCell.self, forCellWithReuseIdentifier: StyleCell.Constants.reuseIdentifier)

        backButton.addTarget(self, action: #selector(onBackButtonAction), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(onShareButtonAction), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func onBackButtonAction() {
        self.dismiss(animated: true)
    }

    @objc private func onShareButtonAction() {
        guard let result = resultView.image else {
            ErrorDialog(message: "TRANSFER_SHARE_FAILED".localized).present(self)
            return
        }

        let shareViewController = UIActivityViewController(activityItems: [result], applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = view
        self.present(shareViewController, animated: true)
    }
}

// MARK: - Collection View Delegates

extension StyleTransferViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { styles.count + 1 }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StyleCell.Constants.reuseIdentifier,
            for: indexPath
        ) as? StyleCell else { fatalError("Could not retrieve StyleCell") }

        cell.icon = UIImage(named: styles[safe: indexPath.row - 1]?.rawValue ?? "original")
        cell.name = styles[safe: indexPath.row - 1]?.rawValue ?? "original"
        cell.isSelected = selectedStyle == indexPath.row
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        // set loading view
        SwiftSpinner.show("TRANSFER_PROCESS".localized)
        defer { selectedStyle = indexPath.row }

        // perform transfer
        guard
            indexPath.row != 0,
            let style = styles[safe: indexPath.row - 1]
        else {
            SwiftSpinner.hide()
            resultView.image = source
            return
        }

        transferHandler.process(image: source, style: style)
        selectedStyle = indexPath.row
        collectionView.reloadData()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize { StyleCell.Constants.size.size }
}

// MARK: - Transfer Delegate

extension StyleTransferViewController: TransferDelegate {

    func transferHandler(
        _ transferHandler: TransferHandler,
        didFailedTransfer error: Error?
    ) {
        ErrorDialog(message: "TRANSFER_FAILED".localized).present(self)
    }

    func transferHandler(
        _ transferHandler: TransferHandler,
        didFailedInitialization style: TransferHandler.Style
    ) {
        styles = styles.filter { $0 != style }
    }

    func transferHandler(
        _ transferHandler: TransferHandler,
        didTransferStyle result: UIImage
    ) {
        SwiftSpinner.hide()
        resultView.image = result
    }
}

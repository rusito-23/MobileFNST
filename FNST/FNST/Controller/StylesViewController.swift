//
//  StylesViewController.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/19/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class StylesViewController: UIViewController {

    // MARK: views

    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var stylesCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    var loadingView: LoadingView?

    // MARK: properties

    var styles = TransferStyle.allCases
    var selectedStyle = 0
    var transfer: TransferHandler?
    var source: UIImage?

    // MARK: lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup preview
        preview.image = self.source

        // setup styles collection view
        stylesCollectionView.delegate = self
        stylesCollectionView.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        stylesCollectionView.collectionViewLayout = layout
        stylesCollectionView.register(UINib(nibName: Constants.Nibs.StyleCell, bundle: nil), forCellWithReuseIdentifier: Constants.Reuse.StyleCell)
        stylesCollectionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // setup transfer handler
        transfer = TransferHandler()
        transfer?.delegate = self
        transfer?.initModels()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let indexPath = IndexPath(row: 0, section: 0)
        self.stylesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

    // MARK: actions

    @IBAction func onBackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onDownloadButtonPressed(_ sender: Any) {
        guard let finalImage = self.preview.image else {
            let errorView = ErrorView()
            errorView.setupWithSuperView(self.view)
            return
        }
        let shareVC = UIActivityViewController(activityItems: [finalImage], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }

}

// MARK: Style Transfer Delegate

extension StylesViewController: TransferDelegate {

    func modelInitializationFailure(with style: TransferStyle) {
        logger.warn("Model intialization failure for style: \(style.rawValue)")

        // remove failed style
        self.styles = self.styles.filter { $0 != style }
    }

    func transferSuccess(image: UIImage) {
        self.loadingView?.removeFromSuperview()
        self.loadingView = nil
        self.preview.image = image
    }

    func transferFailure() {
        let errorView = ErrorView()
        errorView.setupWithSuperView(self.view)
    }

}

// MARK: Collection View Delegate

extension StylesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styles.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Reuse.StyleCell, for: indexPath) as! StyleViewCell

        // cell setup
        if indexPath.row == 0 {
            cell.setup(with: nil)
        } else {
            let style = styles[indexPath.row - 1]
            cell.setup(with: style)
        }

        // set selected
        cell.selected(self.selectedStyle == indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // set loading view
        self.loadingView = LoadingView()
        self.loadingView?.setupWithSuperView(self.view)

        // perform transfer
        if indexPath.row == 0, let source = self.source {
            self.transferSuccess(image: source)
        } else if let source = self.source {
            self.transfer?.process(image: source, style: self.styles[indexPath.row - 1])
        }

        // selection toggle
        self.selectedStyle = indexPath.row
        let cell = collectionView.cellForItem(at: indexPath) as! StyleViewCell
        cell.selected(true)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // selection toggle
        let cell = collectionView.cellForItem(at: indexPath) as? StyleViewCell
        cell?.selected(false)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

}

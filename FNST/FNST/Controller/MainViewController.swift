//
//  MainViewController.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/18/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var getStartedInfoLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var galleryLabel: UILabel!
    private lazy var imagePicker = ImagePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup image picker
        imagePicker.delegate = self

        // setup ui
        titleLabel.addTextOutline("APP_TITLE".localized(), usingFont: MainFont.title())

        cameraLabel.text = "CAMERA_BUTTON".localized()
        cameraLabel.font = MainFont.superMiniParagraph()
        galleryLabel.text = "GALLERY_BUTTON".localized()
        galleryLabel.font = MainFont.superMiniParagraph()

        getStartedInfoLabel.text = "GET_STARTED".localized()
        getStartedInfoLabel.font = MainFont.miniParagraph()

        mainImage.softenBorders()
    }

    @IBAction func startFromGallery(_ sender: Any) {
        imagePicker.photoGalleryAccessRequest()
    }

    @IBAction func startFromCamera(_ sender: Any) {
        imagePicker.cameraAccessRequest()
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.present(parent: self, sourceType: sourceType)
    }

    private func showStylesController(image: UIImage) {
        if let mvc = UIStoryboard(name: Constants.Storyboards.MAIN, bundle: nil)
            .instantiateViewController(withIdentifier: Constants.ViewControllers.STYLES) as? StylesViewController {
        mvc.source = image
        self.present(mvc, animated: true, completion: nil)
      }
    }

    

}

extension MainViewController: ImagePickerDelegate {

    func imagePickerDelegate(didSelect image: UIImage, delegatedForm: ImagePicker) {
        imagePicker.dismiss()
        showStylesController(image: image)
    }

    func imagePickerDelegate(didCancel delegatedForm: ImagePicker) {
        imagePicker.dismiss()
    }

    func imagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        if accessIsAllowed {
            presentImagePicker(sourceType: .photoLibrary)
        }
    }

    func imagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        if accessIsAllowed {
            presentImagePicker(sourceType: .camera)
        }
    }
}


import UIKit
import SwiftSpinner

final class MainViewController: UIViewController {

    // MARK: - Properties

    private lazy var imagePickerController: ImagePickerController = {
        let picker = ImagePickerController()
        picker.delegate = self
        return picker
    }()

    // MARK: - Subviews

    private lazy var mainView = MainView()
    private var galleryButton: UIButton { mainView.galleryButton }
    private var cameraButton: UIButton { mainView.cameraButton }

    // MARK: - View Lifecycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        galleryButton.addTarget(self, action: #selector(onGalleryButtonAction), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(onCameraButtonAction), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func onGalleryButtonAction(_ sender: UIButton) {
        imagePickerController.photoGalleryAccessRequest()
    }

    @objc private func onCameraButtonAction(_ sender: UIButton) {
        imagePickerController.cameraAccessRequest()
    }

    // MARK: - Methods

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerController.present(parent: self, sourceType: sourceType)
    }
}

// MARK: - ImagePickerControllerDelegate

extension MainViewController: ImagePickerControllerDelegate {
    func imagePicker(_ imagePicker: ImagePickerController, canUseCamera allowed: Bool) {
        guard allowed else {
            log.error("Camera access request failed!")
            ErrorDialog(
                message: "CAMERA_ACCESS_FAILED".localized
            ).present(self)
            return
        }

        presentImagePicker(sourceType: .camera)
    }

    func imagePicker(_ imagePicker: ImagePickerController, canUseGallery allowed: Bool) {
        guard allowed else {
            log.error("Gallery access request failed!")
            ErrorDialog(
                message: "GALLERY_ACCESS_FAILED".localized
            ).present(self)
            return
        }

        presentImagePicker(sourceType: .photoLibrary)
    }

    func imagePicker(_ imagePicker: ImagePickerController, didSelect image: UIImage) {
        imagePicker.dismiss { [weak self] in
            let styleTransferViewController = StyleTransferViewController(image)
            styleTransferViewController.modalPresentationStyle = .fullScreen
            self?.present(styleTransferViewController, animated: true)
        }
    }

    func imagePicker(_ imagePicker: ImagePickerController, didCancel cancel: Bool) {
        if cancel { imagePicker.dismiss() }
    }

    func imagePicker(_ imagePicker: ImagePickerController, didFail failed: Bool) {
        if failed {
            imagePicker.dismiss()
            ErrorDialog(
                message: "LOAD_IMAGE_FAILED".localized
            ).present(self)
        }
    }
}

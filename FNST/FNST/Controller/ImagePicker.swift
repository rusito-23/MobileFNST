import AVFoundation
import Photos
import UIKit

protocol ImagePickerDelegate: class {
    func imagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ImagePicker)
    func imagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ImagePicker)
    func imagePickerDelegate(didSelect image: UIImage, delegatedForm: ImagePicker)
    func imagePickerDelegate(didCancel delegatedForm: ImagePicker)
}

class ImagePicker: NSObject {

    private weak var controller: UIImagePickerController?
    weak var delegate: ImagePickerDelegate? = nil

    func present(parent viewController: UIViewController, sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = sourceType
            controller.modalPresentationStyle = .fullScreen
            self.controller = controller
            viewController.present(controller, animated: true, completion: nil)
        }
    }

    func dismiss() { controller?.dismiss(animated: true, completion: nil) }
}

extension ImagePicker {

    private func showAlert(targetName: String, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async {
            let errorView = ErrorView()
            errorView.titleLabel.text = String(format: "PICKER_ERROR_TITLE".localized(), targetName)
            errorView.descriptionLabel.text = String(format: "PICKER_ERROR_DESCRIPTION".localized(), targetName)
            let windows = UIApplication.shared.windows
            if let rootVC = (windows.filter{ $0.isKeyWindow }.first?.rootViewController) {
                errorView.setupWithSuperView(rootVC.view)
            }
        }
    }

    func cameraAccessRequest() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            delegate?.imagePickerDelegate(canUseCamera: true, delegatedForm: self)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    self.delegate?.imagePickerDelegate(canUseCamera: granted, delegatedForm: self)
                } else {
                    self.showAlert(targetName: "camera") {
                        self.delegate?.imagePickerDelegate(canUseCamera: $0, delegatedForm: self)
                    }
                }
            }
        }
    }

    func photoGalleryAccessRequest() {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            if result == .authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.imagePickerDelegate(canUseGallery: result == .authorized, delegatedForm: self)
                }
            } else {
                self.showAlert(targetName: "photo gallery") {
                    self.delegate?.imagePickerDelegate(canUseCamera: $0, delegatedForm: self)
                }
            }
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            DispatchQueue.main.async {
                self.delegate?.imagePickerDelegate(didSelect: image, delegatedForm: self)
            }
            return
        }

        if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.delegate?.imagePickerDelegate(didSelect: image, delegatedForm: self)
            }
        } else {
            print("Other source")
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            self.delegate?.imagePickerDelegate(didCancel: self)
        }
    }
}

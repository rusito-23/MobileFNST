import Foundation
import UIKit
import VideoToolbox

// MARK: - Styles

enum TransferStyle: String, CaseIterable {
    case Candy = "candy"
    case Pointilism = "pointilism"
    case Mosaic = "mosaic"
    case RainPrincess = "rain-princess"
    case Udnie = "udnie"
}

// MARK: - Delegate

protocol TransferDelegate: class {
    func modelInitializationFailure(with style:TransferStyle)
    func transferSuccess(image:UIImage)
    func transferFailure()
}

// MARK: - TransferHandler

class TransferHandler {

    // MARK: - Constants

    private struct Constants {
        struct Size {
            static let width = 224
            static let height = 224
            static let size = CGSize(width: width, height: height)
        }

        struct PixelBuffer {
            static let format = kCVPixelFormatType_32ARGB
            static let bitsPerComponent = 8 // UInt8
            static let alphaInfo: CGImageAlphaInfo = .noneSkipFirst
            static let attributes: CFDictionary = [
                kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
            ] as CFDictionary
        }

        struct Queue {
            static let label = "com.rusito23.FNST.serial"
        }
    }

    // MARK: - Properties

    weak var delegate: TransferDelegate?
    private var models: [TransferStyle:TransferModel] = [:]
    private let queue = DispatchQueue(label: Constants.Queue.label)

    // MARK: - Methods

    func start() {
        for style in TransferStyle.allCases {
            guard let model = TransferModel(name: style.rawValue) else {
                self.delegate?.modelInitializationFailure(with: style)
                continue
            }
            self.models[style] = model
        }
    }

    func process(image: UIImage, style: TransferStyle) {
        // preprocess input
        guard let input = preprocess(image) else {
            logger.warn("Style transfer preprocessing failed")
            self.delegate?.transferFailure()
            return
        }

        // pass through the net
        queue.async {
            guard
                let model = self.models[style],
                let output = try? model.prediction(input: input)
            else {
                logger.warn("Style transfer failed")
                DispatchQueue.main.async { self.delegate?.transferFailure() }
                return
            }

            DispatchQueue.main.async {
                // get output & postprocessing
                guard let imageOutput = self.postprocess(
                    output.outputBuffer,
                    originalSize: image.size
                ) else {
                    logger.warn("Style transfer postprocessing failed")
                    self.delegate?.transferFailure()
                    return
                }

                self.delegate?.transferSuccess(image: imageOutput)
            }
        }
    }

    private func preprocess(
        _ image: UIImage,
        width: Int = Constants.Size.width,
        height: Int = Constants.Size.height
    ) -> TransferInput? {
        // initialize pixel buffer
        var pixelBuffer: CVPixelBuffer?
        guard
            kCVReturnSuccess == CVPixelBufferCreate(
                kCFAllocatorDefault,
                width,
                height,
                Constants.PixelBuffer.format,
                Constants.PixelBuffer.attributes,
                &pixelBuffer
            ),
            let buffer = pixelBuffer
        else { return nil }

        // lock pixel buffer read
        CVPixelBufferLockBaseAddress(buffer, .write)
        defer { CVPixelBufferUnlockBaseAddress(buffer, .write) }

        // initialize context
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: Constants.PixelBuffer.bitsPerComponent,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: Constants.PixelBuffer.alphaInfo.rawValue
        ) else { return nil }

        // draw image
        UIGraphicsPushContext(context)
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        image.draw(in: CGRect(origin: .zero, size: Constants.Size.size))
        UIGraphicsPopContext()

        return TransferInput(with: buffer)
    }

    func postprocess(
        _ outputBuffer: CVPixelBuffer?,
        width: Int = Constants.Size.width,
        height: Int = Constants.Size.height,
        originalSize: CGSize
    ) -> UIImage? {
        // check output buffer
        guard let buffer = outputBuffer else { return nil }

        // create cgImage
        var maybeCGImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(buffer, options: nil, imageOut: &maybeCGImage)
        guard let cgImage = maybeCGImage else { return nil }

        // create image and resize to original
        let image = UIImage(cgImage: cgImage)
        let resized = UIGraphicsImageRenderer(
            size: originalSize,
            format: .default()
        ).image { _ in image.draw(in: CGRect(origin: .zero, size: originalSize)) }

        return resized
    }
}

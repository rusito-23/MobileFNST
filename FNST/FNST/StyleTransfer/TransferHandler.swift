//
//  TransferHandler.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/18/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

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

    // MARK: - Properties

    weak var delegate: TransferDelegate?
    private var models: [TransferStyle:TransferModel] = [:]

    // MARK: - Methods

    /// Initialize all available models
    func start() {
        for style in TransferStyle.allCases {
            guard let model = TransferModel(name: style.rawValue) else {
                self.delegate?.modelInitializationFailure(with: style)
                continue
            }
            self.models[style] = model
        }
    }

    // MARK: functions

    func process(image: UIImage, style: TransferStyle) {
        // create input
        let originalSize = image.size
        guard let pixelInput = image.pixelBuffer(width: 224, height: 224) else {
            logger.warn("Transfer failure in step: preprocessing")
            self.delegate?.transferFailure()
            return
        }
        let input = TransferInput(with: pixelInput)

        // pass through the net
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            guard let model = self.models[style],
                  let output = try? model.prediction(input: input) else {
                logger.warn("Transfer failure in step: processing")
                DispatchQueue.main.async { self.delegate?.transferFailure() }
                return
            }

            DispatchQueue.main.async {
                // get output & postprocessing
                guard
                    let outputBuffer = output.outputBuffer,
                    let imageOutput = UIImage(pixelBuffer: outputBuffer)
                else {
                    logger.warn("Transfer failure in step: post-processing")
                    self.delegate?.transferFailure()
                    return
                }

                let resizedOutput = imageOutput.resized(to: originalSize)
                self.delegate?.transferSuccess(image: resizedOutput)
            }
        }
    }

}

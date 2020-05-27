//
//  TransferHandler.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/18/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

// MARK: Styles

enum TransferStyle: String, CaseIterable {
    case Candy = "candy"
    case Pointilism = "pointilism"
    case Mosaic = "mosaic"
    case RainPrincess = "rain-princess"
    case Udnie = "udnie"
}

// MARK: Delegate

protocol TransferDelegate: class {
    func modelInitializationFailure(with style:TransferStyle)
    func transferSuccess(image:UIImage)
    func transferFailure()
}

// MARK: TransferHandler

class TransferHandler {

    // MARK: properties

    var models:[TransferStyle:TransferModel] = [:]
    private var processing = false
    weak var delegate: TransferDelegate?

    // MARK: initialization

    func initModels() {
        for style in TransferStyle.allCases {
            guard let model = TransferModel(with: style.rawValue) else {
                self.delegate?.modelInitializationFailure(with: style)
                continue
            }
            self.models[style] = model
        }
    }

    // MARK: functions

    func process(image: UIImage, style:TransferStyle) {
        guard !self.processing else {
            // avoid processing twice
            return
        }
        self.processing = true

        // create input
        let originalSize = image.size
        guard let pixelInput = image.pixelBuffer(width: 224, height: 224) else {
            logger.warn("Transfer failure in step: preprocessing")
            self.delegate?.transferFailure()
            self.processing = false
            return
        }
        let input = TransferInput(with: pixelInput)

        // pass through the net
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            guard let model = self.models[style],
                  let output = try? model.prediction(input: input) else {
                logger.warn("Transfer failure in step: processing")
                self.delegate?.transferFailure()
                self.processing = false
                return
            }

            DispatchQueue.main.async {
                // get output & postprocessing
                guard let imageOutput = UIImage(pixelBuffer: output.imageOutput) else {
                    logger.warn("Transfer failure in step: post-processing")
                    self.delegate?.transferFailure()
                    self.processing = false
                    return
                }

                let resizedOutput = imageOutput.resized(to: originalSize)
                self.delegate?.transferSuccess(image: resizedOutput)
                self.processing = false
            }
        }
    }

}

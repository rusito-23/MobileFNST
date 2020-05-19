//
//  Transfer.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/18/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

import Foundation
import UIKit

class Transfer {

    let candy = Candy()
    weak var delegate: TransferDelegate?

    func process(image: UIImage?) {
        guard let image = image else {
            self.delegate?.transferFailure(with: NSError(domain: "ERROR", code: 10, userInfo: nil))
            return
        }

        guard
            let pixelInput = image.pixelBuffer(width: 224, height: 224),
            let output = try? self.candy.prediction(input1: pixelInput) else {
            self.delegate?.transferFailure(with: NSError(domain: "ERROR", code: 10, userInfo: nil))
            return
        }

        guard let imageOutput = UIImage(pixelBuffer: output.output1) else {
            self.delegate?.transferFailure(with: NSError(domain: "ERROR", code: 10, userInfo: nil))
            return
        }

        self.delegate?.transferSuccess(with: imageOutput)
    }

}




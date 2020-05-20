//
//  UILabel+Outline.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/20/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addTextOutline(_ text: String, usingFont font: UIFont) {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor : UIColor.orange,
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.strokeWidth : 4,
                NSAttributedString.Key.font : font
        ]
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

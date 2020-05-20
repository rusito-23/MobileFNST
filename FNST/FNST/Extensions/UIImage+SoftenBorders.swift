//
//  UIImage+SoftenBorders.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/20/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {

    func softenBorders() {
        let maskLayer = CAGradientLayer()
        maskLayer.frame = self.bounds
        maskLayer.shadowRadius = 20
        maskLayer.shadowPath = CGPath(roundedRect: self.bounds.insetBy(dx: 5, dy: 5), cornerWidth: 100, cornerHeight: 100, transform: nil)
        maskLayer.shadowOpacity = 0.8;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.orange.cgColor
        self.layer.mask = maskLayer;
    }

}

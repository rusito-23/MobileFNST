//
//  CustomButton.swift
//  MemeGenerator
//
//  Created by Igor Andruskiewitsch on 5/2/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class RoundButton: UIButton {

    override init(frame: CGRect) {
     super.init(frame: frame)
     setup()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setup()
    }

    func setup() {
        self.titleLabel?.font = MainFont.button();
        self.layer.cornerRadius = self.frame.height / 2;
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
        self.backgroundColor = .black
        self.tintColor = .white;
    }

}

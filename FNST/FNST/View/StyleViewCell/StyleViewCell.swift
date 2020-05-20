//
//  StyleViewCell.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/19/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class StyleViewCell: UICollectionViewCell {

    @IBOutlet weak var styleName: UILabel!
    @IBOutlet weak var styleIconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(with style: TransferStyle?) {
        self.styleIconView.layer.cornerRadius = 30
        self.styleIconView.layer.borderWidth = 3
        self.styleIconView.layer.borderColor = UIColor.white.cgColor
        self.styleIconView.tintColor = .white

        self.styleName.font = MainFont.superMiniParagraph()

        if let styleName = style?.rawValue {
            self.styleIconView.image = UIImage(named: styleName)?.withTintColor(.white)
            self.styleName.text = styleName
        } else {
            self.styleIconView.image = UIImage()
            self.styleName.text = "NONE".localized()
        }
    }

    func selected(_ sel: Bool) {
        if sel {
            self.styleIconView.layer.borderColor = UIColor.orange.cgColor
        } else {
            self.styleIconView.layer.borderColor = UIColor.white.cgColor
        }
    }

}

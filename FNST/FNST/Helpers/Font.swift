//
//  Font.swift
//  MemeGenerator
//
//  Created by Igor Andruskiewitsch on 5/2/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import Foundation
import UIKit

struct MainFont {
    private static let NAME = "AvenirNext-Heavy"
    private static let titleSize: CGFloat = 100
    private static let subtitleSize: CGFloat = 32
    private static let paragraphSize: CGFloat = 23
    private static let miniParagraphSize: CGFloat = 17
    private static let superMiniParagraphSize: CGFloat = 12
    private static let buttonSize: CGFloat = 23

    private static func font(size: CGFloat) -> UIFont {
        return UIFont(name: NAME, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func title() -> UIFont {
        return font(size: titleSize)
    }

    static func subtitle() -> UIFont {
        return font(size: subtitleSize)
    }

    static func button() -> UIFont {
        return font(size: buttonSize)
    }

    static func paragraph() -> UIFont {
        return font(size: paragraphSize)
    }

    static func miniParagraph() -> UIFont {
        return font(size: miniParagraphSize)
    }

    static func superMiniParagraph() -> UIFont {
        return font(size: superMiniParagraphSize)
    }
}

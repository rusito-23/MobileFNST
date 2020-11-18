//
//  String+Localized.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/19/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import Foundation

extension String {

    func localized() -> String {
        return NSLocalizedString(self, comment:"")
    }

}

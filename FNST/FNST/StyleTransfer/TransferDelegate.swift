//
//  TransferDelegate.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/18/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

import Foundation
import UIKit

protocol TransferDelegate: class {
    func transferSuccess(with image:UIImage?)
    func transferFailure(with error:NSError)
}

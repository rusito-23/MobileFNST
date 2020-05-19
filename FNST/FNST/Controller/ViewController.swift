//
//  ViewController.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/18/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TransferDelegate {

    @IBOutlet weak var original: UIImageView!
    @IBOutlet weak var result: UIImageView!

    var transfer: TransferHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup example
        self.original.image = UIImage(named: "cv")

        // setup transfer
        self.transfer = TransferHandler()
        self.transfer?.delegate = self

        self.runExample()
    }

    func runExample() {
        if let image = self.original.image {
            self.transfer?.process(image: image, with: .Mosaic)
        }
    }

    func transferSuccess(image: UIImage) {
        self.result.image = image;
    }

    func transferFailure() {
        logger.warn("Transfer failure")
    }

}


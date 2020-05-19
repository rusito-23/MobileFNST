//
//  ViewController.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/18/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TransferDelegate {

    @IBOutlet weak var original: UIImageView!
    @IBOutlet weak var result: UIImageView!

    var transfer: Transfer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup example
        self.original.image = UIImage(named: "cv")

        // setup transfer
        self.transfer = Transfer()
        self.transfer?.delegate = self

        self.runExample()
    }

    func runExample() {
        self.transfer?.process(image: self.original.image)
    }

    func transferSuccess(with image: UIImage?) {
        self.result.image = image;
    }

    func transferFailure(with error: NSError) {
        print("ERror bitHC")
    }

}


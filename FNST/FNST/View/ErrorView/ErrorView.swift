//
//  ErrorView.swift
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/20/20.
//  Copyright © 2020 Igor Andruskiewitsch. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var errorIconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: CustomButton!

    required convenience init() {
        self.init(frame: CGRect.zero)
        customSetup()
    }

    private func customSetup() {
        loadBundle()
        loadUI()
    }

    private func loadBundle() {
        Bundle.main.loadNibNamed(Constants.Nibs.ErrorView, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = UIColor.black
    }

    private func loadUI() {
        // setup icon
        self.errorIconView.image = UIImage(named: "candy")?.withTintColor(.white)
        self.errorIconView.layer.cornerRadius = 50
        self.errorIconView.layer.borderWidth = 3
        self.errorIconView.layer.borderColor = UIColor.white.cgColor

        // setup button
        self.button.setTitle("ERROR_DEFAULT_BUTTON".localized(), for: .normal)

        // setup labels
        self.titleLabel.font = MainFont.paragraph()
        self.titleLabel.text = "ERROR_DEFAULT_TITLE".localized()
        self.descriptionLabel.font = MainFont.miniParagraph()
        self.descriptionLabel.text = "ERROR_DEFAULT_DESCRIPTION".localized()

        // setup content view
        self.roundedView.layer.cornerRadius = 10
        self.roundedView.layer.borderWidth = 3
        self.roundedView.layer.borderColor = UIColor.white.cgColor

        // setup view
        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }

    // MARK: Size and constraints handling

    public func setupWithSuperView(_ superView: UIView) {
        // setup size
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.frame = superView.bounds

        // add to superView
        superView.addSubview(self)
        let animation = CATransition()
        animation.type = .fade
        superView.layer.add(animation, forKey: "layerAnimation")

        // constraints
        self.contentView?.heightAnchor.constraint(equalTo: superView.heightAnchor).isActive = true
        self.contentView?.widthAnchor.constraint(equalTo: superView.widthAnchor).isActive = true
    }

    @IBAction func onButtonPressed(_ sender: Any) {
        self.removeFromSuperview()
    }

}

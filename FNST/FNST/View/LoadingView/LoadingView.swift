//
//  LoadingView.swift
//  MovieDB
//
//  Created by Igor Andruskiewitsch on 25/02/2019.
//  Copyright © 2019 Igor Andruskiewitsch. All rights reserved.
//

import UIKit


class LoadingView: UIView {
    
    //   MARK: setup
    @IBOutlet var contentView: UIView!
    
    required convenience init() {
        self.init(frame: CGRect.zero)
        customSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customSetup()
    }
    
    private func customSetup() {
        loadBundle()
        loadAnimation()
    }
    
    private func loadBundle() {
        Bundle.main.loadNibNamed(Constants.Nibs.LoadingView, owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private func loadAnimation() {
        let indicator = UIActivityIndicatorView()
        indicator.center = self.center;
        self.addSubview(indicator)
        indicator.startAnimating()
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
    
}


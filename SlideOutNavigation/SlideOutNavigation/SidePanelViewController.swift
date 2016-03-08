//
//  SidePanelViewController.swift
//  DTSlideOutNavigation
//
//  Created by WsyMbp on 16/3/8.
//  Copyright © 2016年 dorayakitech. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController {
    
    // MARK: - Property
    private lazy var infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = self.infoText
        return label
    }()
    
    var infoText: String = "" {
        didSet {
            self.infoLabel.text = self.infoText
        }
    }
    
    var infoColor: UIColor = UIColor.blackColor() {
        didSet {
            self.infoLabel.textColor = self.infoColor
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var image: UIImage? {
        didSet {
            self.imageView.image = self.image
        }
    }
    
    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
}

// MARK: - UI Operation
extension SidePanelViewController {
    private func setupUI() {
        // add the infoLabel and imageView
        self.view.addSubview(self.infoLabel)
        self.view.addSubview(self.imageView)
        // layout subviews
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            self.imageView.heightAnchor.constraintEqualToConstant(150),
            self.imageView.widthAnchor.constraintEqualToAnchor(self.imageView.heightAnchor),
            self.imageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
            self.imageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor),
            self.infoLabel.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
            self.infoLabel.bottomAnchor.constraintEqualToAnchor(self.imageView.topAnchor, constant: -30)
        ])
    }
}















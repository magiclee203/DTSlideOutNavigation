//
//  CenterViewController.swift
//  DTSlideOutNavigation
//
//  Created by WsyMbp on 16/3/8.
//  Copyright © 2016年 dorayakitech. All rights reserved.
//

import UIKit

@objc protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
}

class CenterViewController: UIViewController {
    
    // MARK: - Property
    weak var delegate: CenterViewControllerDelegate?
    
    private lazy var boyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "boy"))
        return imageView
    }()
    
    private lazy var girlImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "girl"))
        return imageView
    }()
    
    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setupUI()
    }


}

// MARK: - NavigationItem Operation
extension CenterViewController {
    @objc private func toggleLeftPanel() {
        self.delegate?.toggleLeftPanel?()
    }
    
    @objc private func toggleRightPanel() {
        self.delegate?.toggleRightPanel?()
    }
}

// MARK: - UI Operation
extension CenterViewController {
    private func setupUI() {
        // add two imageView
        self.view.addSubview(self.boyImageView)
        self.view.addSubview(self.girlImageView)
        // layout the imageView
        self.boyImageView.translatesAutoresizingMaskIntoConstraints = false
        self.girlImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            self.boyImageView.heightAnchor.constraintEqualToConstant(150),
            self.boyImageView.widthAnchor.constraintEqualToAnchor(self.boyImageView.heightAnchor),
            self.girlImageView.heightAnchor.constraintEqualToConstant(150),
            self.girlImageView.widthAnchor.constraintEqualToAnchor(self.girlImageView.heightAnchor),
            self.boyImageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor),
            self.girlImageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor),
            self.boyImageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor, constant: -80),
            self.girlImageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor, constant: 80)
        ])
        // configure the navigationItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Boy", style: .Plain, target: self, action: Selector("toggleLeftPanel"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Girl", style: .Plain, target: self, action: Selector("toggleRightPanel"))
    }
}























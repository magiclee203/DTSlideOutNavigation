//
//  ContainerViewController.swift
//  DTSlideOutNavigation
//
//  Created by WsyMbp on 16/3/8.
//  Copyright © 2016年 dorayakitech. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    // MARK: - Property
    enum State {
        case LeftPanelIsShow
        case RightPanleIsShow
        case BothPanelIsHidden
    }
    var currentState: State = .BothPanelIsHidden
    
    // Controllers
    var centerNavViewController: UINavigationController!
    private lazy var leftPanel: SidePanelViewController = {
        let panel = SidePanelViewController()
        panel.infoText = "Handsome Boy!!!"
        panel.infoColor = UIColor.blueColor()
        panel.image = UIImage(named: "boy")
        panel.view.backgroundColor = UIColor.whiteColor()
        return panel
    }()
    private lazy var rightPanel: SidePanelViewController = {
        let panel = SidePanelViewController()
        panel.infoText = "Pretty Girl!!!"
        panel.infoColor = UIColor.redColor()
        panel.image = UIImage(named: "girl")
        panel.view.backgroundColor = UIColor.whiteColor()
        return panel
    }()
    
    // Animation Constant
    let slidingOutPercent: CGFloat = 0.8
    
    
    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // add CenterViewController as child
        let cvc = CenterViewController()
        cvc.delegate = self
        self.centerNavViewController = UINavigationController(rootViewController: cvc)
        self.addChildViewController(self.centerNavViewController)
        self.view.addSubview(self.centerNavViewController.view)
        self.centerNavViewController.didMoveToParentViewController(self)
        // add gesture to implement slide out operation
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        self.centerNavViewController.view.addGestureRecognizer(panGesture)
    }
}

// MARK: - CenterViewController Delegate
extension ContainerViewController: CenterViewControllerDelegate {
    func toggleLeftPanel() {
        // if left panel is hidden, then show it. Otherwise hide it
        if self.currentState != .LeftPanelIsShow {
            // update the state
            self.currentState = .LeftPanelIsShow
            // add the left panel to view controller's hierarchy
            self.addSidePanel(self.leftPanel)
            // aniamte the CenterViewController
            self.showSidePanelAnimation(self.currentState)
        } else {
            // update the state
            self.currentState = .BothPanelIsHidden
            // animate the CenterViewController
            self.hideSidePanelAnimation()
        }
    }
    
    func toggleRightPanel() {
        // if right panel is hidden, then show it. Otherwise hide it
        if self.currentState != .RightPanleIsShow {
            // update the state
            self.currentState = .RightPanleIsShow
            // add the right panel to view controller's hierarchy
            self.addSidePanel(self.rightPanel)
            // aniamte the CenterViewController
            self.showSidePanelAnimation(self.currentState)
        } else {
            // update the state
            self.currentState = .BothPanelIsHidden
            // animate the CenterViewController
            self.hideSidePanelAnimation()
        }
    }
}

// MARK: - Slide Out Operation
extension ContainerViewController {
    private func addSidePanel(sidePanel: SidePanelViewController) {
        self.addChildViewController(sidePanel)
        self.view.insertSubview(sidePanel.view, atIndex: 0)
        sidePanel.didMoveToParentViewController(self)
    }
    
    private func removeSidePanel() {
        let sidePanel = self.childViewControllers.last as! SidePanelViewController
        sidePanel.willMoveToParentViewController(nil)
        sidePanel.view.removeFromSuperview()
        sidePanel.removeFromParentViewController()
    }
    
    private func showSidePanelAnimation(state: State) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            switch state {
            case .LeftPanelIsShow:
                self.centerNavViewController.view.frame.origin.x = self.centerNavViewController.view.bounds.width * self.slidingOutPercent
            case .RightPanleIsShow:
                self.centerNavViewController.view.frame.origin.x = -self.centerNavViewController.view.bounds.width * self.slidingOutPercent
            case .BothPanelIsHidden:
                break
            }
            self.centerNavViewController.view.layer.shadowOpacity = 0.8
            }, completion: nil)
    }
    
    private func hideSidePanelAnimation() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavViewController.view.frame.origin.x = 0
            self.centerNavViewController.view.layer.shadowOpacity = 0.0
            }, completion: { finished in
                // remove leftViewController from the view controller's hierarchy
                self.removeSidePanel()
        })
    }
}

// MARK: - Gesture Operation
extension ContainerViewController {
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        // determine the direction of sliding operation
        let slideFromLeftToRight = gesture.velocityInView(self.centerNavViewController.view).x > 0
        // Slide out operation
        switch gesture.state {
        case .Began:
            // if both panel is hidden, then create the corresponding panel.
            // otherwise return
            if self.currentState == .BothPanelIsHidden {
                if slideFromLeftToRight {
                    self.addSidePanel(self.leftPanel)
                } else {
                    self.addSidePanel(self.rightPanel)
                }
            }
        case .Changed:
            // handle the situation where the left panel is already shown and you still wanna slide from left to right
            if (slideFromLeftToRight && self.currentState == .LeftPanelIsShow) ||
                (!slideFromLeftToRight && self.currentState == .RightPanleIsShow) {
                    return
            }
            let offsetX = gesture.translationInView(self.centerNavViewController.view).x
            self.centerNavViewController.view.frame.origin.x += offsetX
            gesture.setTranslation(CGPointZero, inView: self.centerNavViewController.view)
        case .Ended:
            self.panGestureEndProcess(slideFromLeftToRight)
        default:
            break
        }
    }
    
    private func panGestureEndProcess(slideFromLeftToRight: Bool) {
        if slideFromLeftToRight {
            switch self.currentState {
            case .BothPanelIsHidden:
                if self.centerNavViewController.view.frame.origin.x < self.view.bounds.size.width * 0.5 {
                    self.currentState = .LeftPanelIsShow
                }
                self.toggleLeftPanel()
            case .RightPanleIsShow:
                if self.centerNavViewController.view.frame.origin.x < -self.view.bounds.size.width * 0.5 {
                    self.currentState = .BothPanelIsHidden
                }
                self.toggleRightPanel()
            default:
                break
            }
        } else {
            switch self.currentState {
            case .BothPanelIsHidden:
                if self.centerNavViewController.view.frame.origin.x > -self.view.bounds.size.width * 0.5 {
                    self.currentState = .RightPanleIsShow
                }
                self.toggleRightPanel()
            case .LeftPanelIsShow:
                if self.centerNavViewController.view.frame.origin.x > self.view.bounds.size.width * 0.5 {
                    self.currentState = .BothPanelIsHidden
                }
                self.toggleLeftPanel()
            default:
                break
            }
        }
    }
}










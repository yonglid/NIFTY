//
//  ContainerViewController.swift
//  NIFTY
//
//  Created by James Frost on 03/08/2014.
//  Edited by William Schmitt and Yong Li Dich on 12/5/15.
//  Copyright (c) 2014 James Frost. All rights reserved.
//
//  Code adapted from http://www.raywenderlich.com/78568/create-slide-out-navigation-panel-swift
//

import UIKit
import QuartzCore

// Create variables to log state of view
enum SlideOutState {
    case MenuCollapsed
    case MenuPanelExpanded
}

class ContainerViewController: UIViewController {
    
    
    
    // MARK: Properties
    var centerNavigationController: UINavigationController!
    var headlinesTableViewController: HeadlinesTableViewController!
    var menuViewController: MenuTableViewController?
    let centerPanelExpandedOffset: CGFloat = 60
    var headlinesURL = "https://news.google.com/news?cf=all&hl=en&pz=1&ned=us&output=rss"
    var headlinesTitle = "Top Stories"
    var currentState: SlideOutState = .MenuCollapsed {
        didSet {
            let shouldShowShadow = currentState != .MenuCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }

    
    
    
    // MARK: Configure View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create headline view
        headlinesTableViewController = UIStoryboard.headlinesTableViewController()
        headlinesTableViewController.delegate = self
        headlinesTableViewController.headlinesURL = headlinesURL
        headlinesTableViewController.title = headlinesTitle
        
        // wrap the headlinesTableViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: headlinesTableViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMoveToParentViewController(self)
        
        // allow user to access menu via swiping
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
}

// MARK: HeadlinesViewController delegate

extension ContainerViewController: HeadlinesTableViewControllerDelegate {
    
    // toggle menu display
    func toggleMenuPanel() {
        let notAlreadyExpanded = (currentState != .MenuPanelExpanded)
        
        if notAlreadyExpanded {
            addMenuPanelViewController()
        }
        
        animateMenuPanel(shouldExpand: notAlreadyExpanded)
    }
    
    // Create menu panel view
    func addMenuPanelViewController() {
        if (menuViewController == nil) {
            menuViewController = UIStoryboard.menuViewController()
            
            addChildMenuPanelController(menuViewController!)
        }

    }
    
    // insert menu panel view into container view controller so both menu and headlines can be shown
    func addChildMenuPanelController(menuPanelController: MenuTableViewController) {
        view.insertSubview(menuPanelController.view, atIndex: 0)
        
        addChildViewController(menuPanelController)
        menuPanelController.didMoveToParentViewController(self)
    }
    
    // make change in display animated
    func animateMenuPanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .MenuPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .MenuCollapsed
                
                self.menuViewController!.view.removeFromSuperview()
                self.menuViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    // create a shadow between menu and headline views so user can distinguish between them
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    // MARK: Gesture recognizer
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            if (currentState == .MenuCollapsed) {
                if (gestureIsDraggingFromLeftToRight) {
                    addMenuPanelViewController()
                }
                
                showShadowForCenterViewController(true)
            }
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            recognizer.setTranslation(CGPointZero, inView: view)
        case .Ended:
            if (menuViewController != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateMenuPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
    
}

// allow for creation of menu and headline views in code 
private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func menuViewController() -> MenuTableViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("idMenuTableViewController") as? MenuTableViewController
    }
    
    class func headlinesTableViewController() -> HeadlinesTableViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("idHeadlinesTableViewController") as? HeadlinesTableViewController
    }
    
}
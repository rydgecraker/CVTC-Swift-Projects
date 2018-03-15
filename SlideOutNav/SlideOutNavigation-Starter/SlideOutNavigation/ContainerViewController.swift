/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
  
  //Set up an ENUM (a new datatype defined by labels) to define a set of related values, in our case, to keep track of the current state of the side panels.
  enum SlideOutState{
    case bothCollapsed
    case leftPanelExpanded
    case rightPanelExpaned
  }
  
  //View controller that manages tha navigation of hierarchical content
  var centerNavigationController: UINavigationController!
  var centerViewController: CenterViewController!
  
  var currentState: SlideOutState = .bothCollapsed {
    
    //Setup a didSet observer on this property that will be called whenever the property's value changes.
    //If either of the side panels are expanded, then it shows the shadow on the center view controller.
    didSet {
      let shouldShowShadow = currentState != .bothCollapsed
      showShadowForCenterViewController(shouldShowShadow)
    }
    
  }
  
  var leftViewContoller: SidePanelViewController?
  var rightViewController: SidePanelViewController?
  
  //The width in pts of the portion of the centerViewController that will be left visible once it has animated (moved) offscreen.
  let centerPanelExpandedOffsetL: CGFloat = 80
  let centerPanelExpandedOffsetR: CGFloat = 98
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    centerViewController = UIStoryboard.centerViewController()
    centerViewController.delegate = self
    
    //Wrap the centerViewController in a NavigationController so we can push views to it and display a bar button item in the navbar.
    centerNavigationController = UINavigationController(rootViewController: centerViewController)
    
    
    // Add the navigation controller's view to ContainerViewController's (self) view as a subview aka childView
    //Also, use addChildViewController() and didMove(toParentViewController:) to set up a parent-child relationship.
    view.addSubview(centerNavigationController.view)
    
    addChildViewController(centerNavigationController)
    
    centerNavigationController.didMove(toParentViewController: self)
    
    //Define a UIPanGestureRecognizer and assign the handlePanGesture(_:) method to it to handle any detected pan gestures (swiping)
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    
    //By default, a panGestureRecognizer detects a single touch with a single finger, so it doesn't need any extra configuration. We just need to add the newly created gestureRecognizer to the centerNavigationController's view.
    centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    
  }
}


//MARK: - CenterViewControllerDelegate
extension ContainerViewController: CenterViewControllerDelegate {
  
  func toggleLeftPanel() {
    //Check if leftSidePanel is already expanded or not
    let notAlreadyExpanded = (currentState != .leftPanelExpanded)
    
    //if the leftSidePanel is not yet expanded, add it to the view hierarchy.
    if notAlreadyExpanded {
      addLeftPanelViewController()
    }
    
    // Animate the left panel to its 'open' position if it was not expanded. Or to its 'closed' position if it was already expanded. (toggle it)
    animateLeftPanel(shouldExpand: notAlreadyExpanded)
  }
  
  func toggleRightPanel() {
    let notAlreadyExpanded = (currentState != .rightPanelExpaned)
    
    if notAlreadyExpanded {
      addRightPanelViewController()
    }
    
    animateRightPanel(shouldExpand: notAlreadyExpanded)
  }
  
  func addLeftPanelViewController() {
    
    //If the leftViewController is not nil, return.
    guard leftViewContoller == nil else {
      return
    }
    
    //Optional Binding
    //We know that leftViewController is nil, so...
    //Get a reference to the leftViewController in the main storyboard and create a new sidePanelViewController setting its list of animals to display only cats.
    if let vc = UIStoryboard.leftViewController() {
      
      //Animal is a struct that has an allCats() static function that returns an array of Animal Structs set to the various cat's info. (properties named: title, creator, and image)
      vc.animals = Animal.allCats()
      
      
      addChildSidePanelController(vc)
      
      leftViewContoller = vc
      
    }
  }
  
  func addRightPanelViewController() {
    guard rightViewController == nil else {
      return
    }
    
    if let vc = UIStoryboard.rightViewController() {
      
      vc.animals = Animal.allDogs()
      
      addChildSidePanelController(vc)
      
      rightViewController = vc
      
    }
  }
  
  func addChildSidePanelController(_ sidePanelController: SidePanelViewController){
    
    sidePanelController.delegate = centerViewController
    
    // Insert the passed-in view controller's view into the containerViewController's view and insert it at z-index of 0, which means it will be below (under) the centerViewController
    view.insertSubview(sidePanelController.view, at: 0)
    
    
    //Set up the parent-child relationship by adding the passed-in view controller (sidePanelController) as a child of the containerViewController.
    addChildViewController(sidePanelController)
    sidePanelController.didMove(toParentViewController: self)
    
  }
  

  
  func animateLeftPanel(shouldExpand: Bool) {
    
    if shouldExpand { //Expand the left panel
      
      currentState = .leftPanelExpanded
      
      //Animate the center panel open.
      animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffsetL)
      
    } else { // Collpase the left panel
      
      
      //Animate the center panel closed and use a completion block (closure) to set the state and remove the view.
      animateCenterPanelXPosition(targetPosition: 0) { finished in
        
        self.currentState = .bothCollapsed
        
        //Unlink the view from its superView and its window, and remove it from the responder change
        self.leftViewContoller?.view.removeFromSuperview()
        self.leftViewContoller = nil
        
      }
      
    }
    
  }
  
  
  func animateRightPanel(shouldExpand: Bool) {
    if shouldExpand {
      
      currentState = .rightPanelExpaned
      
      //Animate the center panel open.
      animateCenterPanelXPosition(targetPosition: -centerNavigationController.view.frame.width + centerPanelExpandedOffsetR)
      
    } else {
      
      
      //Animate the center panel closed and use a completion block (closure) to set the state and remove the view.
      animateCenterPanelXPosition(targetPosition: 0) { finished in
        
        self.currentState = .bothCollapsed
        
        //Unlink the view from its superView and its window, and remove it from the responder change
        self.rightViewController?.view.removeFromSuperview()
        self.rightViewController = nil
        
      }
      
    }
  }
  
  //Note the optional completion closure will be only passed-in via the call in the else clause in our animatePanel methods.
  func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
    
    //Perform an animation on this view using a timing curve corresponding to the mothion of a physical spring.
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut, animations:
                      {self.centerNavigationController.view.frame.origin.x = targetPosition},
                   completion: completion)
    
  }
  
  
  //Adjust the opacity of the navigationController's shadow to make it visible (or hidden) depending on the state. Once we code this, we'll go back to the currentState property and change it to be a computed property that will implement a didSet property observer that will trigger a closure.
  func showShadowForCenterViewController(_ showShadow: Bool){
    if(showShadow){
      centerNavigationController.view.layer.shadowOpacity = 0.8
    } else {
      centerNavigationController.view.layer.shadowOpacity = 0.0
    }
  }
  
  
  // Check the current state of the side panels and collapse whichever one is open, if any.
  func collapseSidePanels() {
    
    switch currentState {
    case .rightPanelExpaned:
      toggleRightPanel()
    case .leftPanelExpanded:
      toggleLeftPanel()
    default:
      break
    }
    
  }
  
}


//MARK: Gesture Recognizer
extension ContainerViewController: UIGestureRecognizerDelegate {
  
  //The pan gesture recognizer detects pans in any direction, but we are only interested in the x axis.
  
  @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
    
    //Left or right motion in the current view controller's main view.
    // > 0 is moving left to right
    let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
    
    //recognizer.state is the current state of the gesture recognizer.
    //
    //We need to track 3 states. .began, .changed, and .ended
    switch recognizer.state {
      
    // If the user starts panning and neither side panel is visible, then show the correct side panel based on the pan direction, making the shadow visible.
    case .began:
      if currentState == .bothCollapsed {
        if gestureIsDraggingFromLeftToRight {
          addLeftPanelViewController()
        } else {
          addRightPanelViewController()
        }
        showShadowForCenterViewController(true)
      }
      
    //If the user is already panning, move the center view controller's view by the amount the user has panned.
    case .changed:
      
      if let rview = recognizer.view {
        rview.center.x += recognizer.translation(in: view).x
        
        recognizer.setTranslation(CGPoint.zero, in: view)
      }
      //When the pan ends, check whether the left or right view controller is visible. Depending on which is visible, if any, and how far the pan has gone. Perform the appropriate animation.
    case .ended:
      if let _ = leftViewContoller, let rview = recognizer.view {
        
        //Animate the side panel open/closed based on whether the view has moved more or less than half way.
        animateLeftPanel(shouldExpand: rview.center.x > view.bounds.size.width)
      } else if let _ = rightViewController, let rview = recognizer.view {
        
        animateRightPanel(shouldExpand: rview.center.x < 0)
        
      }
      
    default:
      break
    }
    
  }
  
}


private extension UIStoryboard {
  
  static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
  
  static func leftViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
  }
  
  static func rightViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "RightViewController") as? SidePanelViewController
  }
  
  static func centerViewController() -> CenterViewController? {
    return mainStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? CenterViewController
  }
}


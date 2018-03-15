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

class CenterViewController: UIViewController {
  
  @IBOutlet weak fileprivate var imageView: UIImageView!
  @IBOutlet weak fileprivate var titleLabel: UILabel!
  @IBOutlet weak fileprivate var creatorLabel: UILabel!
  
  var delegate: CenterViewControllerDelegate?
  
  // MARK: Button actions  
  @IBAction func kittiesTapped(_ sender: Any) {
    
    // Use optional chaining (the ?'s and .) to call toggleLeftPanel()
    
    //Basically, if the delegate has a value, AND it has implimented the toggleLeftPanel() method, then call the method.
    delegate?.toggleLeftPanel?()
    
    // You can see the definition of the delegate protocol (rules) in CenterViewControllerDelegate.swift
    //The protocol definition has optional methods including toggleLeftPanel().
    
    //The @objc attribute makes your Swift API available in the Objective C runtime enviornment
    
    
    
  }
  
  @IBAction func puppiesTapped(_ sender: Any) {
    delegate?.toggleRightPanel?()
  }
}



extension CenterViewController: SidePanelViewControllerDelegate {
  
  func didSelectAnimal(_ animal: Animal) {
    
    //Populate the imageView and labels in the centerViewController with the passed-in animal's properties.
    imageView.image = animal.image
    titleLabel.text = animal.title
    creatorLabel.text = animal.creator
    
    // If the centerViewController has a delagate of its own (it should), tell it to collapse the side panel away so you can see the selected animal item in the center view controller.
    delegate?.collapseSidePanels?()
    
  }
  
}

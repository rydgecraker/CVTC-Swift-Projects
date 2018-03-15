//
//  ViewController.swift
//  BullsEye
//
//  Created by Cooley, Jon on 1/23/18.
//  Copyright © 2018 Cooley, Jon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentValue = 50
    var targetValue = 0
    var score = 0
    var round = 0
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewRound()
        updateLabels()
        
        
        slider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Normal"), for: .normal)
        
        slider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Highlighted"), for: .highlighted)
        
        //First, add insets which are a way of spacing
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        
        //Make the image resizable
        let trackLeftResizeable = trackLeftImage.resizableImage(withCapInsets: insets)
        
        //Use the resizeable image of the track image to the left of the slider thumb for the normal state.
        slider.setMinimumTrackImage(trackLeftResizeable, for: .normal)
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        
        //Make the image resizable
        let trackRightResizeable = trackRightImage.resizableImage(withCapInsets: insets)
        
        //Use the resizeable image of the track image to the left of the slider thumb for the normal state.
        slider.setMaximumTrackImage(trackRightResizeable, for: .normal)
        
        
    }
    
    
    @IBAction func startOver(_ sender: Any) {
        
        startNewGame()
        updateLabels()
        
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        
        // Slider values are floats.  We need an integer.
        // lroundf() rounds a given float to integer.
        currentValue = lroundf(sender.value)
        
        //showAlert(sender)
        
    }
    
    
    @IBAction func showAlert(_ sender: Any) {
        
        //print("The value of the slider currently is: \(currentValue)\nThe target value is \(targetValue)")
        
        //startNewRound()
        //updateLabels()
        
        let difference = abs(targetValue - currentValue)
        
        var points = 100 - difference
        
        let title: String
        
        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference < 5 {
            title = "You almost got it!"
            if difference == 1 {
                points += 25
            } else {
                points += 10
            }
        } else if difference < 10 {
            title = "Pretty good guess"
        } else {
            title = "Not even close..."
        }
        
        
        let message = "The value of the slider currently is: \(currentValue)\nThe target value is \(targetValue)\nYou scored \(points)"
        
        score += points
        
        // Now, let's create an alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Set up an alert action
        //
        // Note that we removed the handler parameter in the UIAlertAction
        // below and replaced it with a trailing closure (code block) in
        // which we call our startNewRound() and updateLabel() methods...
        //
        // By referencing the view controller (self) in the closure we
        // are creating a retain cycle (memory leak).  To prevent this,
        // we will pass in a capture list ([weak self]) in which
        // we will capture self (the view controller) and make it a
        // weak reference (rather than a strong reference).
        //
        // This also means that self, since it is now weak, will
        // turn into an optional so we need to use ?'s with self
        // inside the closure.
        let actionItem = UIAlertAction(title: "OK", style: .default) {
            [weak self] action in
            
            self?.startNewRound()
            self?.updateLabels()
            
        }
        
        // Add the action to the alert
        alertController.addAction(actionItem)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func startNewGame() {
        
        score = 0
        round = 0
        
        startNewRound()
        
    }
    
    
    func startNewRound() {
        
        round += 1
        
        // set up a new target value making it random
        targetValue = Int(arc4random_uniform(100)) + 1
        
        currentValue = 50
        slider.value = Float(currentValue)
        
    }
    
    func updateLabels() {
        
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
        
    }
    
}


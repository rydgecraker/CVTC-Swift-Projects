//
//  ViewController.swift
//  TipCalculator
//
//  Created by Cooley, Jon on 4/11/16.
//  Copyright © 2016 Cooley, Jon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var totalTextField: UITextField!
    @IBOutlet var taxPctSlider: UISlider!
    @IBOutlet var taxPctLabel: UILabel!
    @IBOutlet var resultsTextView: UITextView!
    
    // Connect our ViewController to our model (TipCalculatorModel.swift)
    let tipCalc = TipCalculatorModel(total: 33.25, taxPct: 0.06)
    
    
    func refreshUI() {
        
        totalTextField.text = String(format: "%0.2f", arguments: [tipCalc.total])
        
        taxPctSlider.value = Float(tipCalc.taxPct) * 100
        
        taxPctLabel.text = "Tax Percentage (\(Int(taxPctSlider.value))%)"
        
        // Clear the results text view until the user taps the Calculate Tip button
        resultsTextView.text = ""
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUI()
        
    }
    
    @IBAction func calculateTappedOn(_ sender: AnyObject) {

        // Hack to convert a String to a Double in Swift
        tipCalc.total = Double((totalTextField.text! as NSString).doubleValue)
        print(tipCalc.total)
        let possibleTips = tipCalc.returnPossibleTips()
        
        var results = ""
        
        let tipPercentages = Array(possibleTips.keys).sorted()
        
        // sort() creates a sorted copy of the array, but cannot change the
        // array itself...
        //var anotherArray = tipPercentages.sort()
        //tipPercentages.sortInPlace()   // replaces array with sorted elements
        
        for tipPercentage in tipPercentages {
            
            let tipValue = possibleTips[tipPercentage]
            let prettyTipValue = String(format: "$%.2f", tipValue!)
            results += "\(tipPercentage)%: \(prettyTipValue)\n"
            
        }
        
        // Display the results string in our UITextView
        resultsTextView.text = results
        
    }
    
    @IBAction func taxPercentageChanged(_ sender: AnyObject) {
        
        tipCalc.total = Double((totalTextField.text! as NSString).doubleValue)
        
        // Reverse the multiply by 100 behaviour
        tipCalc.taxPct = Double(taxPctSlider.value) / 100
        
        refreshUI()
        
    }
    

    @IBAction func viewTapped(_ sender: AnyObject) {
        // When the main view is tapped
        totalTextField.resignFirstResponder()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

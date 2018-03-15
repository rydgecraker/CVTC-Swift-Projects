//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by Cooley, Jon on 4/11/16.
//  Copyright © 2016 Cooley, Jon. All rights reserved.
//

import Foundation

//
// Create the TipCalculatorModel class
//
class TipCalculatorModel {
    
    // Create some properties for our class.
    
    var total: Double
    var taxPct: Double
    
    // Change subTotal to be a computed property
    //
    // A computed property does not actually store a value.
    // Instead, it is computed each time based on other values.
    // Here, we will need to calculate the subTotal each time
    // it is accessed based on the current values of total and taxPct.
    //
    // We will need to set it up as a "getter".  No "setter" is needed.
    var subTotal: Double {
        
        get {
            return total / (taxPct + 1)
        }
        
        /*
        set(newSubTotal) {
            // setter would look something like this and update
            // total and taxPct based on newSubTotal...
        }

        */
        
    }
    
    // Our tips will be pre-tax so we will
    // calculate the pre-tax amount before applying the tip
    
    //
    // Create the class intializer (constructor) that takes
    // two parameters and assigns them to two of our class
    // properties.
    //
    init(total:Double, taxPct:Double) {
        
        // self is a shortcut for our class.  Note that self
        // won't need to be used with our subTotal property
        // as that property name does not conflict with
        // any of our parameter names.
        self.total = total
        self.taxPct = taxPct
        
    }
    
    
    //
    // Method calcTipWithTipPct
    //
    // Determine the amount to tip
    //
    func calcTipWithTipPct(_ tipPercentage: Double) ->Double {
        print(subTotal)
        return subTotal * tipPercentage
        
    }
    
        
    //
    // Method returnPossibleTips
    //
    // We will be returning a dictionary of data so
    // we could use Dictionary<Int, Double>
    //
    // However, we will use a shortcut for the above
    // which is: [Int: Double]
    //
    func returnPossibleTips() -> [Int: Double] {
        
        let possibleTips = [0.15, 0.18, 0.2]
        var intPct: Int
        
        // Create an empty dictionary named tipValues which needs
        // to be a variable as we will be modifying it.
        var tipValues = Dictionary<Int, Double>()
        
        for possibleTip in possibleTips {
            
            intPct = Int(possibleTip * 100)
            
            tipValues[intPct] = calcTipWithTipPct(possibleTip)
            
        }
        
        return tipValues
        
    }
    
}

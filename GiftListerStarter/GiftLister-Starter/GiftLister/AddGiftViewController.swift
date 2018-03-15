/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

//
//  AddGiftViewController.swift
//  GiftLister
//
//  Created by George Andrews on 1/21/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit

protocol AddGiftViewControllerDelegate {
  func saveGift(gift: Gift) -> Void
  func removeGift(gift: Gift) -> Void
}

typealias USDollars = Double

class AddGiftViewController: UIViewController {
  
  @IBOutlet weak var name: UITextField!
  @IBOutlet weak var price: UITextField!
  @IBOutlet weak var bought: UISwitch!
  
  var gift: Gift?
  
  var delegate: AddGiftViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let gift = gift {
      name.text = gift.name
      price.text = USDollars.formatter.string(from: gift.price as NSNumber)
      bought.setOn(gift.isPurchased, animated: true)
    }
    
    name.delegate = self
  }
  
  @IBAction func cancelGift(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveGift(_ sender: Any) {
    
    if let gift = gift, let name = name.text, let price = price.text {
      
      var priceInDollars: USDollars
    
      if let priceAsNumber = USDollars.formatter.number(from: price)?.doubleValue {
        priceInDollars = priceAsNumber
      } else {
        priceInDollars = USDollars(price) ?? 0
      }
      
      gift.name = name
      gift.price = priceInDollars
      gift.isPurchased = bought.isOn
      
      delegate?.saveGift(gift: gift)
      
      dismiss(animated: true, completion: nil)
      
    } else {
      // YELL AT USER
    }
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    price.resignFirstResponder()
  }
  
}

// MARK: - UITextFieldDelegate

extension AddGiftViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

// MARK: - USDollars

extension USDollars {
  static let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()
}

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
//  AddFriendViewController.swift
//  GiftLister
//
//  Created by George Andrews on 1/21/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

protocol AddFriendViewControllerDelegate {
  func addedFriend(friend: Friend) -> Void
}

class AddFriendViewController: UIViewController {
  
  @IBOutlet weak var picker: UIPickerView!
  @IBOutlet weak var name: UITextField!
  
  fileprivate let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  fileprivate var selectedMonth: Int = 1
  fileprivate var selectedDay: Int = 1
  fileprivate var selectedYear: Int = Calendar.current.component(.year, from: Date())
  
  var delegate: AddFriendViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bounds = UIScreen.main.bounds
    let background = UIImageView(frame: bounds)
    background.image = UIImage(named: "background")
    
    view.insertSubview(background, at: 0)
    
    name.delegate = self
    picker.dataSource = self
    picker.delegate = self
    
  }
  
  @IBAction func cancel(_ sender: Any) {
    _ = navigationController?.popViewController(animated: true)
  }
  
  @IBAction func saveFriend(_ sender: Any) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let context = appDelegate.persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: "Friend", in: context) else {
      return
    }
    
    if name.hasText, isValidDateComposedOf(month: selectedMonth, day: selectedDay, year: selectedYear) {
      
      let calendar = Calendar.init(identifier: .gregorian)
      var components = DateComponents()
      components.month = selectedMonth
      components.day = selectedDay
      components.year = selectedYear
      
      let birthday = calendar.date(from: components)
      
      let friend = Friend(entity: entity, insertInto: context)
      friend.setValue(name.text, forKey: "name")
      friend.setValue(birthday, forKey: "birthday")
      
      do {
        try context.save()
        delegate?.addedFriend(friend: friend)
      } catch let error as NSError {
        print("Could not save \(error), \(error.userInfo)")
      }
      
      _ = navigationController?.popViewController(animated: true)
      
    } else {
      
      // YELL AT USER
      
    }
    
  }
  
  fileprivate func getCurrentYear() -> Int {
    return Calendar.current.component(.year, from: Date())
  }
  
  fileprivate func isValidDateComposedOf(month: Int, day: Int, year: Int) -> Bool {
    
    // HMM .. TOO MUCH WORK RIGHT NOW
    // WILL ADD LATER
    // TODO: Add validation code
    
    return true
  }
  
}

// MARK: - UIPickerViewDelegate

extension AddFriendViewController: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    switch component {
    case 0:
      return 130
    case 1:
      return 50
    default:
      return 70
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch component {
    case 0:
      selectedMonth = row + 1
    case 1:
      selectedDay = row + 1
    default:
      selectedYear = getCurrentYear() - row
    }
  }
  
}

// MARK: - UIPickerViewDataSource

extension AddFriendViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 3
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch component {
    case 0:
      return 12
    case 1:
      return 31
    default:
      return getCurrentYear() - 1900
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch component {
    case 0:
      return months[row]
    case 1:
      return "\(row + 1)"
    default:
      return "\(getCurrentYear() - row)"
    }
  }
}

// MARK: - UITextFieldDelegate

extension AddFriendViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

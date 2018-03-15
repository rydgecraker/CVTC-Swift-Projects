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
//  GiftListViewController.swift
//  GiftLister
//
//  Created by George Andrews on 1/21/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

class GiftListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  let saved = 0
  let bought = 1
  
  var friend: Friend?
  var dataView: Int = 0
  
  var savedGifts = [Gift]()
  var boughtGifts = [Gift]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundView = nil
    tableView.backgroundColor = UIColor.clear
    tableView.tableFooterView = UIView() // clean up empty rows so separators don't appear over background image
    
    let bounds = UIScreen.main.bounds
    let background = UIImageView(frame: bounds)
    background.image = UIImage(named: "background")
    
    view.insertSubview(background, at: 0)
    
    segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
    segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    if let friend = friend {
      
      title = friend.name
      
      guard let gifts = friend.gifts as? Set<Gift> else {
        return
      }
      
      for gift in gifts {
        if gift.isPurchased {
          boughtGifts.append(gift)
        } else {
          savedGifts.append(gift)
        }
      }
      
    }

  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "AddOrEditGift" {
      
      var gift: Gift?
      
      if let indexPath = sender as? IndexPath {
        
        if dataView == saved {
          gift = savedGifts[indexPath.row]
        } else {
          gift = boughtGifts[indexPath.row]
        }
        
      } else {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Gift", in: context) {
          gift = Gift(entity: entity, insertInto: context)
        }
        
      }
      
      if let destination = segue.destination as? AddGiftViewController {
        destination.gift = gift
        destination.delegate = self
      }
      
    }
    
  }
  
  @IBAction func changeView(_ sender: Any) {
    dataView = segmentedControl.selectedSegmentIndex
    tableView.reloadData()
  }
  
}

// MARK: - UITableViewDataSource

extension GiftListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch dataView {
    case saved:
      return savedGifts.count
    case bought:
      return boughtGifts.count
    default:
      return 1 // At least display a message
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    var gift: Gift?
    
    if dataView == saved {
      gift = savedGifts[indexPath.row]
    } else {
      gift = boughtGifts[indexPath.row]
    }
    
    if let gift = gift {
      cell.textLabel?.text = gift.name
      cell.isUserInteractionEnabled = true
    } else {
      if dataView == saved {
        cell.textLabel?.text = "There are no saved gifts."
      } else {
        cell.textLabel?.text = "There are no bought gifts."
      }
      cell.isUserInteractionEnabled = false
    }
    
    return cell
  }
  
}

// MARK: - UITableViewDelegate

extension GiftListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "AddOrEditGift", sender: indexPath)
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
}

// MARK: - AddGiftViewControllerDelegate

extension GiftListViewController: AddGiftViewControllerDelegate {
  
  func saveGift(gift: Gift) {
    
    if gift.isPurchased {
      if !boughtGifts.contains(gift) {
        boughtGifts.append(gift)
        if let index = savedGifts.index(of: gift) {
          savedGifts.remove(at: index)
        }
      }
    } else {
      if !savedGifts.contains(gift) {
        savedGifts.append(gift)
        if let index = boughtGifts.index(of: gift) {
          boughtGifts.remove(at: index)
        }
      }
    }
    
    friend?.addToGifts(gift)
    
    dismiss(animated: true, completion: nil)
    tableView.reloadData()
  }
  
  func removeGift(gift: Gift) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let context = appDelegate.persistentContainer.viewContext
    context.delete(gift)
    dismiss(animated: true, completion: nil)
  }
  
}

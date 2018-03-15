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
//  ViewController.swift
//  GiftLister
//
//  Created by George Andrews on 1/16/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

class FriendSelectionViewController: UIViewController {
  
  @IBOutlet weak var friendsTableView: UITableView!
  
  var friends: [Friend] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
/*
    print("in viewDidLoad")
    print("Loading friends...")
  */
    friendsTableView.backgroundView = nil
    friendsTableView.backgroundColor = UIColor.clear
    friendsTableView.tableFooterView = UIView() // clean up empty rows so separators don't appear over background image
    
    friendsTableView.dataSource = self
    friendsTableView.delegate = self

    let bounds = UIScreen.main.bounds
    let background = UIImageView(frame: bounds)
    background.image = UIImage(named: "background")

    view.insertSubview(background, at: 0)
    
    navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 3/255, green: 158/255, blue: 114/255, alpha: 1)
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
    
    do {
      friends = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
    
    friendsTableView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "AddFriend", let destination = segue.destination as? AddFriendViewController {
      destination.delegate = self
    }
    
    if segue.identifier == "AddGifts", let destination = segue.destination as? GiftListViewController, let indexPath = sender as? IndexPath {
      destination.friend = friends[indexPath.row]
    }
    
  }
  
}

// MARK: - AddFriendViewControllerDelegate

extension FriendSelectionViewController: AddFriendViewControllerDelegate {
  func addedFriend(friend: Friend) {
    friends.append(friend)
    friendsTableView.reloadData()
  }
}

// MARK: - UITableViewDataSource

extension FriendSelectionViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell: UITableViewCell
    
    if indexPath.row == friends.count {
      
      cell = UITableViewCell()
      cell.textLabel?.text = "Add a friend"
      
    } else {
      
      cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
      let friend = friends[indexPath.row]
      
      if let friendCell = cell as? FriendCell, let birthday = friend.birthday as? Date {
        
        friendCell.friendName.text = friend.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        friendCell.birthday.text = formatter.string(from: birthday)
        
        friendCell.totalGifts.text = "Total Gifts: \(friend.gifts?.count ?? 0)"
      }
      
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.row == friends.count {
      return false
    }
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      let context = appDelegate.persistentContainer.viewContext
      
      context.delete(friends[indexPath.row])
      
      friends.remove(at: indexPath.row)
      friendsTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
  }
  
}

// MARK: - Reusable UITableViewCell

class FriendCell: UITableViewCell {
  
  @IBOutlet weak var friendName: UILabel!
  @IBOutlet weak var birthday: UILabel!
  @IBOutlet weak var totalGifts: UILabel!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

// MARK: - UITableViewDelegate

extension FriendSelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == friends.count {
      performSegue(withIdentifier: "AddFriend", sender: indexPath)
    } else {
      performSegue(withIdentifier: "AddGifts", sender: indexPath)
    }
  }
}

//
//  Pet.swift
//  PetFinder
//
//  Created by Luke Parham on 8/31/15.
//  Copyright © 2015 Luke Parham. All rights reserved.
//

import Foundation
import UIKit

class Pet: NSObject {
  
  var name = ""
  var age = 0
  var imageData = Data()
  var id = 0
  
  var imageURL = URL(fileURLWithPath: "")
  
  override init() {
    super.init()
    imageURL = Pet.randomPetURL()
  }
  
  required convenience init(coder decoder: NSCoder) {
    self.init()
    
    if let archivedName = decoder.decodeObject(forKey: "name") as? String {
      name = archivedName
    }
    
    if let archivedAge = decoder.decodeObject(forKey: "age") as? Int {
      age = archivedAge
    }
    
    if let archivedImage = decoder.decodeObject(forKey: "image") {
      imageData = archivedImage as! Data
    }
    
    id = decoder.decodeInteger(forKey: "id")
  }
  
  class func randomPet() -> Pet {
    let pet = Pet()
    
    pet.name = randomName()
    pet.age = randomAge()
    
    return pet
  }
  
  fileprivate class func randomName() -> String {
    return PetNameGenerator.randomName()
  }
  
  fileprivate class func randomAge() -> Int {
    return Int(arc4random_uniform(10)) + 1
  }
  
  fileprivate class func randomPetURL() -> URL {
    let width = Int(arc4random_uniform(500)) + 200
    let height = Int(arc4random_uniform(500)) + 200
    
    return URL(string: "https://placekitten.com/\(width)/\(height)")!
  }
  
}

extension Pet: NSCoding {
  
  func encode(with coder: NSCoder) {
    coder.encode(name, forKey: "name")
    coder.encode(age, forKey: "age")
    coder.encode(imageData, forKey: "image")
    coder.encode(id, forKey: "id")
  }
  
}

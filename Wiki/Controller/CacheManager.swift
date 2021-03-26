//
//  CacheManager.swift
//  Wiki
//
//  Created by Anton Levin on 25.03.2021.
//

import Foundation

class CacheManager {
  
  static var imageDictionary = [String:Data]()
  
  static func saveData(_ url:String, _ imageData:Data) {
    
    // Save the image data along with the url
    imageDictionary[url] = imageData
  }
  
  static func retrieveData(_ url:String) -> Data? {
    
    // Return the saved image data or nil
    return imageDictionary[url]
  }
}

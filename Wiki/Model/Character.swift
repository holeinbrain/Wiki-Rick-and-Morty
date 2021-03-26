//
//  Character.swift
//  Wiki
//
//  Created by Anton Levin on 25.03.2021.
//

import Foundation

struct Character: Decodable {
  
  var id: Int?
  var name: String?
  var status: String?
  var species: String?
  var type: String?
  var gender: String?
  var origin: Place?
  var location: Place?
  var image: String?
  var episode: [String]?
  var url: String?
  var created: String?
  
}

struct Place: Decodable {
  
  var name: String?
  var url: String?
  
}

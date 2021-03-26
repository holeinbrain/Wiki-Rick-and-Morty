//
//  CharacterService.swift
//  Wiki
//
//  Created by Anton Levin on 25.03.2021.
//

import Foundation

struct CharacterService: Decodable {
  
  var info: infolist?
  var results: [Character]?
}

struct infolist: Decodable {
  
  var count: Int?
  var pages: Int?
  var next: String?
  var prev: String?
  
}

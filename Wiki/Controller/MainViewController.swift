//
//  MainViewController.swift
//  Wiki
//
//  Created by Anton Levin on 25.03.2021.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
  
  @IBOutlet weak var tableview: UITableView!
  
  var characters = [Character]()
  
  var filteredCharacters: [Character] = []
  
  let searchController = UISearchController(searchResultsController: nil)
  
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the view controller as the delegate and datasource of table view
    tableview.delegate = self
    tableview.dataSource = self
    
    // Title navigation bar tint color fix bug
    navigationItem.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    
    // Get the character from character model
    getCharacters()
    
    // Search Controller Set Up
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Characters"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Detect the index path the user selected
    let indexPath = tableview.indexPathForSelectedRow
    guard indexPath != nil else {
      return
    }
    
    // Get the article the user tapped on
    let character: Character
    if isFiltering {
      character = filteredCharacters[indexPath!.row]
    } else {
      character = characters[indexPath!.row]
    }
    
    // Get a refrence to the detail view controller
    let detailVC = segue.destination as! DetailViewController
    
    // Pass the character to the detai
    detailVC.character = character
  }
}

// MARK: - Search Bar
extension MainViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
  
  // Filters characters based on search text
  func filterContentForSearchText(_ searchText: String) {
    filteredCharacters = characters.filter { (car : Character) -> Bool in
      return car.name!.lowercased().contains(searchText.lowercased())
    }
    self.tableview.reloadData()
  }
}

// MARK: - Table View
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering {
      return filteredCharacters.count
    }
    return characters.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Get a cell
    let cell = tableview.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
    // Get the character that the cell requests
    let character: Character
    if isFiltering {
      character = filteredCharacters[indexPath.row]
    } else {
      character = characters[indexPath.row]
    }
    // Customize it
    cell.displayCharacter(character)
    // Return the cell
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // Height of cell
    return 130.0
  }
  
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    // Add scrolling animetions and corners
    cell.layer.borderWidth = 0.7
    cell.layer.borderColor = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.5019607843, alpha: 0.24)
    cell.layer.cornerRadius = cell.frame.size.height / 5
    cell.layer.transform = CATransform3DMakeScale(0.7,0.7,1)
    UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
      cell.layer.transform = CATransform3DMakeScale(1,1,1)
    }, completion: nil)
    UIView.animate(withDuration: 0.7, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
    }, completion: nil)
  }
}

// MARK: - Alamofire
extension MainViewController {
  
  func getCharacters() {
    let dispatchGroup = DispatchGroup()
    for page in 1...25 {
      let url = "https://rickandmortyapi.com/api/character/?page=\(page)"
      dispatchGroup.enter()
      AF.request(url).validate()
        .responseDecodable(of: CharacterService.self)  { (response) in
          guard let charServ = response.value else { return }
          self.characters.append(contentsOf: charServ.results!)
          self.tableview.reloadData()
        }
      dispatchGroup.leave()
    }
  }
}

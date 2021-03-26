//
//  DetailViewController.swift
//  Wiki
//
//  Created by Anton Levin on 25.03.2021.
//

import UIKit

class DetailViewController: UIViewController {
  
  var character: Character?
  
  var infoCells: [InfoCell] = []
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    imageSetup()
    getInfoCells(character: character!)
  }
  
  private func setupNavigationBar() {
    title = character!.name!
    if let topItem = navigationController?.navigationBar.topItem {
      topItem.backBarButtonItem = UIBarButtonItem(title: "Back",
                                                  style: .plain,
                                                  target: nil,
                                                  action: nil)
    }
  }
  
  func getInfoCells(character: Character) {
    let infoCell1: InfoCell = InfoCell(title: "Status", info: character.status!)
    let infoCell2: InfoCell = InfoCell(title: "Spesies", info: character.species!)
    let infoCell3: InfoCell = InfoCell(title: "Gender", info: character.gender!)
    let infoCell4: InfoCell = InfoCell(title: "Origin", info: character.created!)
    let infoCell5: InfoCell = InfoCell(title: "Loction", info: (character.location?.name)!)
    
    infoCells.append(infoCell1)
    infoCells.append(infoCell2)
    infoCells.append(infoCell3)
    infoCells.append(infoCell4)
    infoCells.append(infoCell5)
    tableView.reloadData()
  }
  
  func imageSetup() {
    imageView.layer.cornerRadius = 10
    // Set character image
    let urlString = character!.image!
    
    // Check the cache manager before downloading any image data
    if let imageData = CacheManager.retrieveData(urlString) {
      
      // There is imageData, set the characterPic
      imageView.image = UIImage(data: imageData)
      return
    }
    let url = URL(string: urlString)
    guard url != nil else {
      return
    }
    let session = URLSession.shared
    let dataTask = session.dataTask(with: url!) { (data, response, error) in
      
      // Check if there are no errors
      if data != nil && error == nil {
        DispatchQueue.main.async {
          self.imageView.image = UIImage(data: data!)
        }
      }
    }
    dataTask.resume()
  }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40.0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return infoCells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCell {
      cell.configureWith(info: infoCells[indexPath.row])
      // Turn-off visual selection
      cell.selectionStyle = .none
      return cell
    }
    return UITableViewCell()
  }
}

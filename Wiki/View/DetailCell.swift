//
//  DetailCell.swift
//  Wiki
//
//  Created by Anton Levin on 25.03.2021.
//

import UIKit

class DetailCell: UITableViewCell {
  
  @IBOutlet private var infoLabel: UILabel!
  @IBOutlet private var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configureWith(info: InfoCell) {
    infoLabel.text = info.info
    titleLabel.text = info.title
  }
}

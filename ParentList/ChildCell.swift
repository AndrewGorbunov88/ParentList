//
//  ChildCell.swift
//  TestApp
//
//  Created by Андрей Горбунов on 25.07.2021.
//

import UIKit

class ChildCell: UITableViewCell {

    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childAgeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

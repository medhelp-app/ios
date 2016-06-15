//
//  RatingCell.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 6/15/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class RatingCell: UITableViewCell {
    
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var rating: CosmosView!
    
//    init(style: UITableViewCellStyle, reuseIdentifier: String) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

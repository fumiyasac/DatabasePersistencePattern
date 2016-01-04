//
//  ListCell.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/04.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    //Outlet
    @IBOutlet weak var listDate: UILabel!
    @IBOutlet weak var listAverage: UILabel!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var listComments: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

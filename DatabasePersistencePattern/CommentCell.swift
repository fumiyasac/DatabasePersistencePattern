//
//  CommentCell.swift
//  DatabasePersistencePattern
//
//  Created by 酒井文也 on 2016/01/04.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    //Outlet
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentPoint: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

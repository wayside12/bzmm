//
//  followersCell.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/7/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit

class followersCell: UITableViewCell {

    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var usernameLbl: UILabel!    
    @IBOutlet var followBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

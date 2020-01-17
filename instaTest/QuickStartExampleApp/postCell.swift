//
//  postCell.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/15/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit

class postCell: UITableViewCell {

    //header objects
    
    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var usernameBtn: UIButton!
    @IBOutlet var dateLbl: UILabel!
    
    //main picture
    @IBOutlet var picImg: UIImageView!
    
    //buttons
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var moreBtn: UIButton!
    @IBOutlet var commentBtn: UIButton!
    
    
    //labels
    @IBOutlet var likeLbl: UILabel!
    @IBOutlet var uuidLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

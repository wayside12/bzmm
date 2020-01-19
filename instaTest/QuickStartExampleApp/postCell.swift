//
//  postCell.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/15/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse

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
    
    
    //default function
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let width = UIScreen.main.bounds.width
        
        //allow constraints
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
      
        picImg.translatesAutoresizingMaskIntoConstraints = false
        
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        commentBtn.translatesAutoresizingMaskIntoConstraints = false
        
        likeLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        usernameBtn.setTitle(PFUser.current()?.username, for: UIControl.State.normal)
        
        let pictureWidth = width - 20
        
        //constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[ava(30)]-10-[pic(\(pictureWidth))]-5-[like(30)]", options: [], metrics: nil, views: ["ava": avaImg, "pic": picImg, "like": likeBtn]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[username]", options: [], metrics: nil, views: ["username" : usernameBtn]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[date]", options: [], metrics: nil, views: ["date" : dateLbl]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[like]-5-[title]-5-|", options: [], metrics: nil, views: ["like": likeBtn, "title": titleLbl]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pic]-5-[comment(30)]", options: [], metrics: nil, views: ["pic" : picImg, "comment": commentBtn]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pic]-5-[more(25)]", options: [], metrics: nil, views: ["pic" : picImg, "more": moreBtn]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pic]-10-[likes]", options: [], metrics: nil, views: ["pic" : picImg, "likes": likeLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[ava(30)]-10-[username]-10-|", options: [], metrics: nil, views: ["ava" : avaImg, "username": usernameBtn]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[date]-10-|", options: [], metrics: nil, views: ["date" : dateLbl]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[pic]-10-|", options: [], metrics: nil, views: ["pic" : picImg]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[like(30)]-10-[likelbl]-20-[comment(30)]", options: [], metrics: nil, views: ["like" : likeBtn, "likelbl": likeLbl, "comment": commentBtn]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[more(25)]-15-|", options: [], metrics: nil, views: ["more": moreBtn]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]-15-|", options: [], metrics: nil, views: ["title" : titleLbl]))
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
        
        
        
    }

    

}

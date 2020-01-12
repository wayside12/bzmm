//
//  followersCell.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/7/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse
class followersCell: UITableViewCell {

    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var usernameLbl: UILabel!    
    @IBOutlet var followBtn: UIButton!
    
    
    @IBAction func followBtn_click(_ sender: Any) {
        
        //follow/unfollow
        let title = followBtn.title(for: UIControl.State.normal)
        if title?.uppercased() == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = usernameLbl.text
            
            object.saveInBackground { (success, error) in
                if error == nil{
                    self.followBtn.setTitle("FOLLOWING", for: UIControl.State.normal)
                    self.followBtn.backgroundColor = .green
                    
                }else{
                    print(error?.localizedDescription)
                }
            }
        }else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()?.username)
            query.whereKey("following", equalTo: self.usernameLbl.text)
            query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
                if error == nil{
                    for object in objects! {
                        object.deleteInBackground { (success, error) in
                            if error == nil{
                                //successfully remove following relationship
                                self.followBtn.setTitle("FOLLOW", for: UIControl.State.normal)
                                self.followBtn.backgroundColor = .lightGray
                                
                                
                            }else{
                                print(error?.localizedDescription)
                            }
                        }
                    }
                    
                }else{
                    print(error?.localizedDescription)
                }
            }
            
        }
         
    }
    
    
    //default function
    override func awakeFromNib() {
        super.awakeFromNib()

        //alignment
        let width = UIScreen.main.bounds.width
        
        avaImg.frame = CGRect(x: 10, y: 10, width: width/5.3, height: width/5.3)
        usernameLbl.frame = CGRect(x: avaImg.frame.size.width + 20, y: 30, width: width/3.2, height: 30)
        //followBtn.frame = CGRect(x: usernameLbl.frame.origin.x + usernameLbl.frame.size.width + 10, y: 30, width: width/3.5, height: 30)
        followBtn.frame = CGRect(x: width - width/3.5 - 10, y: 30, width: width/3.5, height: 30)
        
        //round image
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
    }


}

        

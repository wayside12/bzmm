//
//  ViewController.swift
//  QuickStartExampleApp
//
//  Created by Joren Winge on 11/8/17.
//  Copyright © 2017 Back4App. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet var picture: UIImageView!
    let message = String()
    let sender = String()
    let receiver = String()
    let file = [PFFileObject]()
    
    
    @IBOutlet var sender_label: UILabel!
    
    @IBOutlet var receiver_label: UILabel!
    
    @IBOutlet var message_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create table and data in database
        /*
        //unwrap, take image file data from UIImageView
        let data = UIImagePNGRepresentation(picture.image!)
        
        //convert taken image to file
        let file = PFFileObject(name: "picture.jpg", data: data!)
        
        //create a class/table/collection in back4apps
        let table = PFObject(className: "messages")
        table["sender"] = "Jun"
        table["receiver"] = "Bo"
        table["message"] = "How are you?"
        table["picture"] = file
                
        table.saveInBackground(block: { (success:Bool, error:NSError?) in
            if success {
                print("Saved in server")
            }else {
            
                print(error ?? "error")                       }
            } as? PFBooleanResultBlock)
         */
        
        //Retrieving data from server
        
        let information = PFQuery(className: "messages")
        information.findObjectsInBackground { (objects:[AnyObject]?, error) in
            if error == nil {
                for object in objects! {
                          
                    if let sender = object["sender"] as? String {
                        self.sender_label.text = "Sender: \(sender)"
                    }
                    if let receiver = object["receiver"] as? String{
                        self.receiver_label.text = "Receiver: \(receiver)"
                    }
                    if let message = object["message"] as? String {
                        self.message_label.text = "Message: \(message)"
                    }
                    //self.sender_label.text = object["sender"] as! String
                    //self.receiver_label.text = object["receiver"] as! String
                    //self.message_label.text = object["message"] as! String
                           
                    
                    //need to cast object["picture"] as PFFileObject first
                    let imageFile = object["picture"] as? PFFileObject
                    imageFile?.getDataInBackground(block: { (data, error) in
                        if error == nil{
                            if let imageData = data {
                                self.picture.image = UIImage(data: imageData)
                            }
                        } else {
                            print(error!)
                        }
                        
                    })
                   
                    
                    //print(object)
                }
                
                
            }else {
                print(error!)
            }
            
        }
        //as! PFQueryArrayResultBlock
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


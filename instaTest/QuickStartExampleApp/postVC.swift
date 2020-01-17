//
//  postVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/15/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse

var postuuid = [String]()

class postVC: UITableViewController {

    //arrays to hold information from server
    var avaArray = [PFFileObject]()
    var userArray = [String]()
    var dateArray = [NSDate]()
    var picArray = [PFFileObject]()
    var uuidArray = [String]()
    var titleArray = [String]()
    
    //default function
    override func viewDidLoad() {
        super.viewDidLoad()

        print("postuuid count = \(postuuid.count)")
        //title label at the top
        self.navigationItem.title = "PHOTO"
        
        //new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        //swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        backSwipe.direction = .right
        self.view.addGestureRecognizer(backSwipe)
        
        //dynamic cell height
        //tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 500
            
        //find post
        let postQuery = PFQuery(className: "post")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            //print("objects count = \(objects?.count ?? 0)")
            if error == nil{
                
                //clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.avaArray.removeAll(keepingCapacity: false)
                self.userArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.avaArray.append(object.value(forKey: "ava") as! PFFileObject)
                    self.userArray.append(object.value(forKey: "username") as! String)
                    self.dateArray.append(object.value(forKey: "createdAt") as! NSDate)
                    self.picArray.append(object.value(forKey: "pic") as! PFFileObject)
                    self.uuidArray.append((object.value(forKey: "uuid")) as! String)
                    self.titleArray.append((object.value(forKey: "title")) as! String)
                    //print(object.value(forKey: "createdAt") as! Date)  //convert NSdate to date
                    
                }
                self.tableView.reloadData()
                
            }else {
                print(error?.localizedDescription)
            }
        }
        
        
        
    }

    @objc func back(sender: UIBarButtonItem){
        
        //push back
        self.navigationController?.popToRootViewController(animated: true)
        
        //clean comment uuid from last
        if !postuuid.isEmpty {
            postuuid.removeLast()
        }
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //print("** userarray count = \(self.userArray.count)")
        return self.userArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        //define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! postCell
        
        //connect objects with informaiton from server
        cell.usernameBtn.setTitle(titleArray[indexPath.row], for: UIControl.State.normal)
        cell.uuidLbl.text = uuidArray[indexPath.row]
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.sizeToFit()
        
        //place profile pic
        avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil{
                cell.avaImg.image = UIImage(data: data!)
            }else{
                print(error?.localizedDescription)
            }
        }
        //place post pic
        picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil{
                cell.picImg.image = UIImage(data: data!)
            }
        }
        
        //calculate post date
        let from = dateArray[indexPath.row]
        let to = NSDate.now
        let components : Set<Calendar.Component> = [.second,.minute, .hour, .day, .weekOfMonth]
        let difference = NSCalendar.current.dateComponents(components, from: from as Date, to: to)
        
        //logic what to show: seconds, minutes, hours, days, weeks
        if difference.second! <= 0{
            cell.dateLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0{
            cell.dateLbl.text = "\(difference.second)s"
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(difference.minute)m"
        }
        if difference.hour! > 0 && difference.day == 0 {
            cell.dateLbl.text = "\(difference.hour)h"
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(difference.day)d"
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth)w"
        }                
        return cell
    }

}

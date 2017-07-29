//
//  MapAttendingListTableViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 13/04/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MapAttendingListTableViewController: UITableViewController {

    var attendingUsers = PFUser.current()?.objectId
    var attendingArray = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var refreshAttenders = [String]()
    var userNames = [String]()
    var refresher = UIRefreshControl()
    
    //Alert Creator function
    func createAlert(title: String, message: String)
    {
        let missingAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        missingAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        self.present(missingAlert, animated: true, completion: nil)
    }
    
    
    func refresh()
    {
        self.refreshAttenders.removeAll()
        self.userNames.removeAll()
        
        _ = refreshNames(completion: {
            
            //Loop through users objectId and retrive details
            for numbers in self.refreshAttenders
            {
                let userQuery = PFQuery(className: "_User")
                userQuery.whereKey("objectId", equalTo: numbers)
                userQuery.findObjectsInBackground(block: { (objects, error) in
                    if error != nil
                    {
                        print(error ?? "error in query mapAttendingList")
                    }
                    else
                    {
                      //loop through user object and append username to userNames array
                        var i = 0
                        while i < (objects?.count)!
                        {
                            let currentObject = objects?[i]
                            self.userNames.append((currentObject!["chosenUsername"] as? String)!)
                            
                            i+=1
                        }
                    }
                    self.tableView.reloadData()
                })
            }
        })
        refresher.endRefreshing()
        print("ended refreshing")
    }
    
    
    func refreshNames(completion: () -> ())
    {
        //Query chosen event and retrieve attenders array
        let query = PFQuery(className: "Events")
        query.whereKey("objectId", equalTo: self.appDelegate.clickedMapEventId)
        do
        {
            let object = try query.findObjects()
            if let values = object[0] as PFObject!
            {
                if let array = values["attenders"] as? [String]
                {
                    //set attenders array to refreshAttenders
                    self.refreshAttenders = array
                }
            }
            //Remove first element if empty
            if refreshAttenders[0] == ""
            {
                self.refreshAttenders.remove(at: 0)
            }
        }
        catch
        {
            print(error)
        }
        completion()
    }
    
    @IBAction func addAttendance3(_ sender: Any)
    {
        
        //let userObjectId = PFUser.current()?.objectId
        let query = PFQuery(className: "Events")
        query.whereKey("objectId", equalTo: self.appDelegate.clickedMapEventId)
        query.findObjectsInBackground { (object, error) in
            if error != nil
            {
                print(error ?? "error when adding attendance - map attending list")
            }
            else
            {
                if let eventValues = object?[0]
                {
                    //Get attenders array and set it to attendingArray
                    if let attendingArrayTemp = eventValues["attenders"] as? [String]
                    {
                        self.attendingArray = attendingArrayTemp
                        //Check is user is already attending
                        if self.attendingArray.contains(self.attendingUsers!)
                        {
                            self.createAlert(title: "Already Attending", message: "You are already attending this event")
                        }
                        else
                        {
                            self.attendingArray.append(self.attendingUsers!)
                            self.createAlert(title: "Succes", message: "You are now attending this event")
                        }
                    }
                    eventValues["attenders"] = []
                    //update attenders array with new array
                    eventValues["attenders"] = self.attendingArray
                    eventValues.saveInBackground()
                }
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let acl = PFACL()
        acl.getPublicReadAccess = true
        acl.getPublicWriteAccess = true
        PFACL.setDefault(acl, withAccessForCurrentUser: true)
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(TableViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        
        refresh()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        
        return userNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.userNames[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let currentCell = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            
            let chosenCellUsername = currentCell
            self.appDelegate.attendingUsername = chosenCellUsername
            
        }
        //Segue to selected attending user
        performSegue(withIdentifier: "toMapUser", sender: self)
    }
}

//
//  AttendingListTableViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 14/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import Bolts

class AttendingListTableViewController: UITableViewController {

    var attendingUsers = PFUser.current()?.objectId
    var attendingArray = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var refreshAttenders = [String]()
    var userNames = [String]()
    var refresher = UIRefreshControl()
    
    //Alert Creator Method
    func createAlert(title: String, message: String)
    {
        let missingAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        missingAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        self.present(missingAlert, animated: true, completion: nil)
    }

    
    func refresh()
    {
        //Remove array elements to prevent duplicate data
        self.refreshAttenders.removeAll()
        self.userNames.removeAll()
        
        _ = refreshNames(completion: {

            //Loop through attending users
            for numbers in self.refreshAttenders
            {
                //Query user class to retrieve user info
                let userQuery = PFQuery(className: "_User")
                userQuery.whereKey("objectId", equalTo: numbers)
                userQuery.findObjectsInBackground(block: { (objects, error) in
                    if error != nil
                    {
                        print(error ?? "error in query - attendingListTableVC")
                    }
                    else
                    {
                        //Loop through object and append users username to userNames array
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
        //Query events class for selected event
        let query = PFQuery(className: "Events")
        query.whereKey("objectId", equalTo: self.appDelegate.rowId)
        do
        {
            //Retrieve attenders array
            let object = try query.findObjects()
            print(object)
            if let values = object[0] as? PFObject
            {
                if let array = values["attenders"] as? [String]
                {
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
        
    
    @IBAction func addAttendance(_ sender: Any)
    {
        //Query events class for selected event
        _ = PFUser.current()?.objectId
        let query = PFQuery(className: "Events")
        query.whereKey("objectId", equalTo: self.appDelegate.rowId)
        query.findObjectsInBackground { (object, error) in
            if error != nil
            {
                print(error ?? "error in query ")
            }
            else
            {
                if let eventValues = object?[0]
                {
                    //Get attenders array and set as attendingArrayTemp
                    if let attendingArrayTemp = eventValues["attenders"] as? [String]
                    {
                        //Check if user is already attending
                        self.attendingArray = attendingArrayTemp
                        if self.attendingArray.contains(self.attendingUsers!)
                        {
                            self.createAlert(title: "Already Attending", message: "You are already attending this event")
                        }
                        else
                        {
                            //Success, user is added to attending list
                            self.attendingArray.append(self.attendingUsers!)
                            self.createAlert(title: "Success", message: "You are now attending this event")
                        }
                       
                    }
                    //Update attenders array
                    eventValues["attenders"] = []
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
        if let currentCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
        {
            let chosenCellUsername = currentCell
            self.appDelegate.attendingUsername = chosenCellUsername
            print(self.appDelegate.attendingUsername)
        }
        //Segue to attending user details
        performSegue(withIdentifier: "toOtherUser", sender: self)
    }
}

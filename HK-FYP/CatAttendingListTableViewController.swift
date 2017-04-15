//
//  CatAttendingListTableViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 17/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class CatAttendingListTableViewController: UITableViewController {

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
        
        let closure = refreshNames(completion: {
            
            print("\(self.refreshAttenders) tototototo")
            
            for numbers in self.refreshAttenders
            {
                print("\(numbers) numbers")
                let userQuery = PFQuery(className: "_User")
                userQuery.whereKey("objectId", equalTo: numbers)
                userQuery.findObjectsInBackground(block: { (objects, error) in
                    if error != nil
                    {
                        print(error)
                    }
                    else
                    {
                        print(objects)
                        var i = 0
                        while i < (objects?.count)!
                        {
                            var currentObject = objects?[i]
                            self.userNames.append((currentObject!["chosenUsername"] as? String)!)
                            
                            i+=1
                        }
                        
                    }
                    print(self.userNames)
                    self.tableView.reloadData()
                })
                
            }
            
            
        })
        
        refresher.endRefreshing()
        print("ended refreshing")
        
    }
    
    
    func refreshNames(completion: () -> ())
    {
        let query = PFQuery(className: "Events")
        query.whereKey("objectId", equalTo: self.appDelegate.rowId)
        do
        {
            let object = try query.findObjects()
            print(object)
            if let values = object[0] as? PFObject
            {
                if let array = values["attenders"] as? [String]
                {
                    self.refreshAttenders = array
                }
            }
            if refreshAttenders[0] == ""
            {
                self.refreshAttenders.remove(at: 0)
            }
            
            print(self.refreshAttenders)
        }
        catch
        {
            print(error)
        }
        completion()
        
    }
    
    
    @IBAction func addAttendance2(_ sender: Any)
    {
        
        let userObjectId = PFUser.current()?.objectId
        let query = PFQuery(className: "Events")
        query.whereKey("objectId", equalTo: self.appDelegate.rowId)
        query.findObjectsInBackground { (object, error) in
            if error != nil
            {
                print(error)
            }
            else
            {
                print(object)
                
                if let eventValues = object?[0]
                {
                    
                    print("hello")
                    if let attendingArrayTemp = eventValues["attenders"] as? [String]
                    {
                        self.attendingArray = attendingArrayTemp
                        if self.attendingArray.contains(self.attendingUsers!)
                        {
                            self.createAlert(title: "Already Attending", message: "You are already attending this event")
                        }
                        else
                        {
                            self.attendingArray.append(self.attendingUsers!)
                            print(self.attendingArray)
                        }
                    }
                    print(self.attendingArray)
                    eventValues["attenders"] = []
                    //eventValues.saveInBackground()
                    eventValues["attenders"] = self.attendingArray
                    eventValues.saveInBackground()
                }
            }
        }
        
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
            print(self.appDelegate.attendingUsername)
            
        }
        
        performSegue(withIdentifier: "toOtherUser", sender: self)
        
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

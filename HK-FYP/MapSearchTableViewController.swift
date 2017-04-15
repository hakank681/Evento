//
//  MapSearchTableViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 13/04/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MapSearchTableViewController: UITableViewController {

    var eventTitles = [String]()
    var eventTitleAndId = [String: String]()
    var events = [PFObject]()
    var refresher = UIRefreshControl()
    var activityIndicator = UIActivityIndicatorView()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var chosenEventId = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(TableViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        refresh()
    }
    
    func refresh()
    {
        self.events.removeAll()
        self.eventTitles.removeAll()
        
        let query = PFQuery(className: "Events")
        query.findObjectsInBackground { (object, error) in
            if error != nil
            {
                print(error ?? "error")
            }
            else
            {
                if let objects = object
                {
                    //add event object to events array
                    for eventObjects in objects
                    {
                        self.events.append(eventObjects)
                    }
                    
                    // extract titles from events array and store to eventTitles array
                    var i = 0
                    while i < self.events.count
                    {
                        if let title = self.events[i].value(forKey: "title") as? String, let eventID = self.events[i].objectId
                        {
                            self.eventTitles.append(title)
                            self.eventTitleAndId[title] = eventID
                            
                        }
                        i += 1
                    }
                    print(self.eventTitleAndId)
                    print(self.eventTitles)
                }
            }
            self.tableView.reloadData()
        }
        refresher.endRefreshing()
        print("ended refreshing")
    }
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        
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
        return  eventTitles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        
        
        
        let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            cell.textLabel?.text = self.eventTitles[indexPath.row]
            
            
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let currentCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
        for (key,value) in self.eventTitleAndId
        {
            self.chosenEventId = self.eventTitleAndId[currentCell!]!
            self.appDelegate.rowId = chosenEventId
        }
        performSegue(withIdentifier: "toEventDetails", sender: self)
        print(self.chosenEventId)
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

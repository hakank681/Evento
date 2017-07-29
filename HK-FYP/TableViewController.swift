//
//  TableViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 12/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
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
        //Remove array elements to prevent duplicate items
        self.events.removeAll()
        self.eventTitles.removeAll()
        
        //Query events class
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
                }
            }
            if self.eventTitles.count > 1
            {
              self.tableView.reloadData()
            }
            
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

        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            if self.eventTitles.count > 0
            {
                cell.textLabel?.text = self.eventTitles[indexPath.row]
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let currentCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
        for (_,_) in self.eventTitleAndId
        {
            self.chosenEventId = self.eventTitleAndId[currentCell!]!
            self.appDelegate.rowId = chosenEventId
        }
        //Seque to event details
        performSegue(withIdentifier: "toEventDetails", sender: self)
    }
}

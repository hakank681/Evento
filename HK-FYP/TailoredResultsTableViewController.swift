//
//  TailoredResultsTableViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 15/04/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class TailoredResultsTableViewController: UITableViewController {
    
    var eventTitles = [String]()
    var eventTitleAndId = [String: String]()
    var events = [PFObject]()
    var refresher = UIRefreshControl()
    var activityIndicator = UIActivityIndicatorView()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var chosenEventId = ""
    var category = ""
    var userHobbies = [String]()
    var currentUser = PFUser.current()?.objectId
    var hobbiesObject = [PFObject]()
    
    //Refresh method
    func refresh()
    {
        _ = refreshList(completion: {
        self.tableView.reloadData()
      
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        category = appDelegate.clickedCategory
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(TableViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        
        //Query hobbies class for users favourites
        let hobbieQuery = PFQuery(className: "Hobbies")
        hobbieQuery.whereKey("user", equalTo: self.currentUser!)
        hobbieQuery.findObjectsInBackground { (object, error) in
            if error != nil
            {
                print(error ?? "tailored results table view query error")
            }
            else
            {
                if let objects = object?[0]
                {
                    //find all categories that are true and append to array
                    if let careerAndBusiness = objects["careerAndBusiness"] as? Bool
                    {
                        if careerAndBusiness == true
                        {
                            self.userHobbies.append("careerAndBusiness")
                        }
                    }
                    if let dancing = objects["dancing"] as? Bool
                    {
                        if dancing == true
                        {
                            self.userHobbies.append("dancing")
                        }
                    }
                    if let fashionAndBeauty = objects["fashionAndBeauty"] as? Bool
                    {
                        if fashionAndBeauty == true
                        {
                            self.userHobbies.append("fashionAndBeauty")
                        }
                    }
                    if let film = objects["film"] as? Bool
                    {
                        if film == true
                        {
                            self.userHobbies.append("film")
                        }
                    }
                    if let foodAndDrink = objects["foodAndDrink"] as? Bool
                    {
                        if foodAndDrink == true
                        {
                            self.userHobbies.append("foodAndDrink")
                        }
                    }
                    if let gaming = objects["gaming"] as? Bool
                    {
                        if gaming == true
                        {
                            self.userHobbies.append("gaming")
                        }
                    }
                    if let music = objects["music"] as? Bool
                    {
                        if music == true
                        {
                            self.userHobbies.append("music")
                        }
                    }
                    if let outdoorAndAdventure = objects["outdoorAndAdventure"] as? Bool
                    {
                        if outdoorAndAdventure == true
                        {
                            self.userHobbies.append("outdoorAndAdventure")
                        }
                    }
                    if let photography = objects["photography"] as? Bool
                    {
                        if photography == true
                        {
                            self.userHobbies.append("photography")
                        }
                    }
                    if let sportsAndFitness = objects["sportsAndFitness"] as? Bool
                    {
                        if sportsAndFitness == true
                        {
                            self.userHobbies.append("sportsAndFitness")
                        }
                    }
                    if let technology = objects["technology"] as? Bool
                    {
                        if technology == true
                        {
                            self.userHobbies.append("technology")
                        }
                    }
                    //Double check selected hobbies are appended accuratelt
                    print("Below are users hobbies")
                    print(self.userHobbies)
                }
            }
             self.refresh()
        }
    }

    
    func refreshList(completion: () -> ())
    {
        //Remove event and eventTitles elements to ensure no duplicate events
        self.events.removeAll()
        self.eventTitles.removeAll()
        
        //Loop users selected hobbies in userHobbies array
        for userCategories in self.userHobbies
        {
            //Query each selected hobbie category and retrieve events
            let query = PFQuery(className: "Events")
            query.whereKey("category", equalTo: userCategories)
            do
            {
               let objects = try query.findObjects()
                
                //Get event title and ID and append to array
                    for events in objects
                    {
                        self.eventTitles.append(events["title"] as! String)
                        self.eventTitleAndId[events["title"] as! String] = events.objectId
                        DispatchQueue.main.async
                        {
                            if self.eventTitles.count > 0
                            {
                                self.tableView.reloadData()
                            }
                        }
                    }
            }
            catch
            {
                print(error)
            }
        }
        
        refresher.endRefreshing()
        print("ended refreshing")
     
        completion()
    }
    
    //View did appear method not currently in use
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

        //Set cell font and size if require
        //cell.textLabel?.font = UIFont(name: "Prime", size: 17)
    
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            // Set cell labels with event titles
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
            //Save ID of chosen event to app delegate for future use
            self.appDelegate.rowId = chosenEventId
        }
        //Seque to tailored event details
        performSegue(withIdentifier: "toTailoredEventDetails", sender: self)
    }
}

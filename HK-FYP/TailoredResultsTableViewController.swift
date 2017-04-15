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
    
    func refresh()
    {
        
        
        let closure = refreshList(completion: {

                self.tableView.reloadData()
      
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        
        
        let hobbieQuery = PFQuery(className: "Hobbies")
        hobbieQuery.whereKey("user", equalTo: currentUser)
        hobbieQuery.findObjectsInBackground { (object, error) in
            if error != nil
            {
                print(error)
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
                    
                    print(self.userHobbies)
                }
                
            }
            
             self.refresh()
        }

       

    }
    
   
    
    func refreshList(completion: () -> ())
    {
        
        self.events.removeAll()
        self.eventTitles.removeAll()
        
        for userCategories in self.userHobbies
        {
            let query = PFQuery(className: "Events")
            query.whereKey("category", equalTo: userCategories)
            do
            {
               let objects = try query.findObjects()
                
                    for events in objects
                    {
                        self.eventTitles.append(events["title"] as! String)
                        self.eventTitleAndId[events["title"] as! String] = events.objectId
                        print("this works")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
            }
            catch
            {
                print(error)
            }
   
        }
        
        
        
        
        print(self.eventTitles)
        print(self.eventTitleAndId)
        
        refresher.endRefreshing()
        print("ended refreshing")
     
        
        completion()
        
        
        
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
        performSegue(withIdentifier: "toTailoredEventDetails", sender: self)
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

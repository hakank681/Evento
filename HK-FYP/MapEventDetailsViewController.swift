//
//  MapEventDetailsViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 13/04/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class MapEventDetailsViewController: UIViewController {

    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var evenLocationLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventCategoryLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    var alertController : UIAlertController!
    
    var attendingUsers = PFUser.current()?.objectId
    var attendingArray = [String]()
    var refreshAttenders = [String]()
    var userNames = [String]()

    //Alert Creator function
    func createAlert(title: String, message: String)
    {
        let missingAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        missingAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        
        self.present(missingAlert, animated: true, completion: nil)
    }
    
    @IBAction func optionButton(_ sender: Any)
    {
    
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var categoryNameDict: [String: String] =
        ["foodAndDrink":"Food And Drink",
         "film":"Film",
         "music":"Music",
         "technology":"Technology",
         "gaming": "Gaming",
         "sportsAndFitness":"Sports And Fitness",
         "dancing":"Dancing",
         "outdoorAndAdventure":"Outdoor And Adventure",
         "careerAndBusiness":"Career And Business",
         "fashionAndBeauty":"Fashion And Beauty",
         "photography":"Photography"
    ]
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation1: CLLocation = locations[0]
        let latitude = userLocation1.coordinate.latitude
        let longitude = userLocation1.coordinate.longitude
        _ = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        // Attend Event or remove attending
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let leaveEvent = UIAlertAction(title: "Leave Event", style: UIAlertActionStyle.default)
        { (action) in
            //this is where the event is deleted
            
            //changed at 20:21 let userObjectId = PFUser.current()?.objectId
            let query = PFQuery(className: "Events")
            query.whereKey("objectId", equalTo: self.appDelegate.clickedMapEventId)
            query.findObjectsInBackground { (object, error) in
                if error != nil
                {
                    print(error ?? "error")
                }
                else
                {
                    
                    
                    if let eventValues = object?[0]
                    {
                        
                        print("hello")
                        if let attendingArrayTemp = eventValues["attenders"] as? [String]
                        {
                            self.attendingArray = attendingArrayTemp
                            if self.attendingArray.contains(self.attendingUsers!)
                            {
                             
                                if let userID = PFUser.current()?.objectId
                                {
                                    if let indexToRemove = self.attendingArray.index(of: userID)
                                    {
                                        self.attendingArray.remove(at: indexToRemove)
                                    }
                                    
                                }
                               

                            }
                            else
                            {
                                self.createAlert(title: "Not Attending", message: "You are not attending this event")
                                
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
        
        //Add user to attending list
        let attendEvent = UIAlertAction(title: "Attend", style: UIAlertActionStyle.default)
        { (action) in
            
            //let userObjectId = PFUser.current()?.objectId
            let query = PFQuery(className: "Events")
            query.whereKey("objectId", equalTo: self.appDelegate.clickedMapEventId)
            query.findObjectsInBackground { (object, error) in
                if error != nil
                {
                    print(error ?? "error")
                }
                else
                {
                    
                    
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
        
        let cancel = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) { (action) in
            print("cancelled")
        }
        
        alertController.addAction(leaveEvent)
        alertController.addAction(attendEvent)
        alertController.addAction(cancel)
        
        
        let chosenMapEvent = self.appDelegate.clickedMapEvent
        
        let query = PFQuery(className: "Events")
        //let object = PFObject(className: "Events")
        query.whereKey("title", equalTo: chosenMapEvent)
        do
        {
            let objects = try query.findObjects()
            print(objects)
            if let eventValues = objects[0] as PFObject!
            {
                if let eventTitle =  eventValues["title"] as? String
                {
                    self.eventTitleLabel.text = eventTitle
                }
                if let eventDate = eventValues["dateString"] as? String
                {
                    self.eventDateLabel.text = eventDate
                }
                if let eventTime = eventValues["timeString"] as? String
                {
                    self.eventTimeLabel.text = eventTime
                }
                if let eventCategory = eventValues["category"] as? String
                {
                    let categoryName = self.categoryNameDict[eventCategory]
                    self.eventCategoryLabel.text = categoryName
                }
                if let eventId = eventValues.objectId
                {
                    self.appDelegate.clickedMapEventId = eventId
                    print(eventId)
                    print("this is the event id")
                }
                if let eventImage = eventValues["eventImage"] as? PFFile
                {
                    eventImage.getDataInBackground { (data, error) in
                        if error != nil
                        {
                            print(error ?? nil ?? "error")
                        }
                        else
                        {
                            let finalImage = UIImage(data: data!)
                            self.eventImageView.image = finalImage
                            print("imagSet")
                        }
                    }
                }
                
                if let eventGeoLocation = eventValues["eventGeopoint"] as? PFGeoPoint
                {
                    let userLatitude = eventGeoLocation.latitude
                    let userLongitude = eventGeoLocation.longitude
                    
                    print(userLatitude)
                    print(userLongitude)
                    
                    let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
                    
                    self.geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                        if error != nil
                        {
                            print(error ?? "error")
                        }
                        else
                        {
                            if let placemark = placemarks?[0] as CLPlacemark!
                            {
                                if let sublocality = placemark.subLocality
                                {
                                    self.evenLocationLabel.text = sublocality
                                }
                                else
                                {
                                    if let locality = placemark.locality
                                    {
                                        self.evenLocationLabel.text = locality
                                    }
                                    else
                                    {
                                        self.evenLocationLabel.text = "N/A"
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        catch
        {
            print("error when getting id")
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

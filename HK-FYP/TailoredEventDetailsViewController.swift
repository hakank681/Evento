//
//  TailoredEventDetailsViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 15/04/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class TailoredEventDetailsViewController: UIViewController {

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
    
    //Show options to attend and leave event
    @IBAction func optionButton(_ sender: Any)
    {
         self.present(alertController, animated: true, completion: nil)
    }
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Attend Event or remove attending
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //Leave event
        let leaveEvent = UIAlertAction(title: "Leave Event", style: UIAlertActionStyle.default)
        { (action) in
            //this is where the event is deleted
            _ = PFUser.current()?.objectId
            let query = PFQuery(className: "Events")
            query.whereKey("objectId", equalTo: self.appDelegate.rowId)
            query.findObjectsInBackground { (object, error) in
                if error != nil
                {
                    print(error ?? "Tailored leave event error occured")
                }
                else
                {
     
                    if let eventValues = object?[0]
                    {
                        //Set attenders array to attendingArrayTemp
                        if let attendingArrayTemp = eventValues["attenders"] as? [String]
                        {
                            //set attending array with all attenders of event
                            self.attendingArray = attendingArrayTemp
                            
                            //check if user is attending the event
                            if self.attendingArray.contains(self.attendingUsers!)
                            {
                                if let userID = PFUser.current()?.objectId
                                {
                                    //find index of users objectID
                                    if let indexToRemove = self.attendingArray.index(of: userID)
                                    {
                                        //remove at index
                                        self.attendingArray.remove(at: indexToRemove)
                                        
                                        //Confirm no longer attending
                                        self.createAlert(title: "Complete", message: "You are no longer attending this event")
                                    }
                                }
                            }
                            else
                            {
                                //User is not attending event so cant remove
                                self.createAlert(title: "Not Attending", message: "You are not attending this event")
                            }
                        }
                        eventValues["attenders"] = []
                        //Save updated array to Parse
                        eventValues["attenders"] = self.attendingArray
                        eventValues.saveInBackground()
                    }
                }
            }
            
        }
        
        //Add user to attending list
        let attendEvent = UIAlertAction(title: "Attend", style: UIAlertActionStyle.default)
        { (action) in
            
            _ = PFUser.current()?.objectId
            let query = PFQuery(className: "Events")
            query.whereKey("objectId", equalTo: self.appDelegate.rowId)
            query.findObjectsInBackground { (object, error) in
                if error != nil
                {
                    print(error ?? "Tailored event details error when adding user")
                }
                else
                {
                    if let eventValues = object?[0]
                    {
                        //set attenders array to attendingArrayTemp
                        if let attendingArrayTemp = eventValues["attenders"] as? [String]
                        {
                            //Initialize attending array
                            self.attendingArray = attendingArrayTemp
                            
                            //Check if user is already attending
                            if self.attendingArray.contains(self.attendingUsers!)
                            {
                                self.createAlert(title: "Already Attending", message: "You are already attending this event")
                            }
                            else
                            {
                                //Add users objectId to attendingArray
                                self.attendingArray.append(self.attendingUsers!)
                                self.createAlert(title: "Success", message: "You are now attending this event")
                            }
                        }
                        eventValues["attenders"] = []
                        //Save new attending array
                        eventValues["attenders"] = self.attendingArray
                        eventValues.saveInBackground()
                    }
                }
            }
        }
        
        //Cancel AlertSheet
        let cancel = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) { (action) in
            print("cancelled")
        }
        
        alertController.addAction(leaveEvent)
        alertController.addAction(attendEvent)
        alertController.addAction(cancel)
        
        //ID of chosen event
        let chosenEventId = self.appDelegate.rowId
        
        //Query events class for event
        let query = PFQuery(className: "Events")
        _ = PFObject(className: "Events")
        query.whereKey("objectId", equalTo: chosenEventId)
        do
        {
            //Get event details
            let objects = try query.findObjects()
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
                if let eventImage = eventValues["eventImage"] as? PFFile
                {
                    eventImage.getDataInBackground { (data, error) in
                        if error != nil
                        {
                            print(error ?? "Error when getting tailored event image")
                        }
                        else
                        {
                            //Image has been set
                            let finalImage = UIImage(data: data!)
                            self.eventImageView.image = finalImage
                            print("Tailored event details image set")
                        }
                    }
                }
                //Get event location details
                if let eventGeoLocation = eventValues["eventGeopoint"] as? PFGeoPoint
                {
                    let userLatitude = eventGeoLocation.latitude
                    let userLongitude = eventGeoLocation.longitude
                    
                    let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
                    
                    self.geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                        if error != nil
                        {
                            print(error ?? "tailored event details location error")
                        }
                        else
                        {
                            //Set event placemarks from reeverse geocode
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
    
}

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
        //Show action sheet
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
            
            //Query event class to get attenders array
            let query = PFQuery(className: "Events")
            query.whereKey("objectId", equalTo: self.appDelegate.clickedMapEventId)
            query.findObjectsInBackground { (object, error) in
                if error != nil
                {
                    print(error ?? "error in query mapEventDetailsVC")
                }
                else
                {
                    if let eventValues = object?[0]
                    {
                        //Retrieve attenders array and set as attendingArray
                        if let attendingArrayTemp = eventValues["attenders"] as? [String]
                        {
                            self.attendingArray = attendingArrayTemp
                            //Check if user is already attending
                            if self.attendingArray.contains(self.attendingUsers!)
                            {
                                if let userID = PFUser.current()?.objectId
                                {
                                    //Find index of user in array and remove
                                    if let indexToRemove = self.attendingArray.index(of: userID)
                                    {
                                        self.attendingArray.remove(at: indexToRemove)
                                        self.createAlert(title: "Complete", message: "You are no longer attending this event")
                                    }
                                }
                            }
                            else
                            {
                                //User is not attending
                                self.createAlert(title: "Not Attending", message: "You are not attending this event")
                            }
                        }
                        eventValues["attenders"] = []
                        //Update attenders array in Parse
                        eventValues["attenders"] = self.attendingArray
                        eventValues.saveInBackground()
                    }
                }
            }
        }
        
        //Add user to attending list
        let attendEvent = UIAlertAction(title: "Attend", style: UIAlertActionStyle.default)
        { (action) in
            
            //Query events class for attenders
            let query = PFQuery(className: "Events")
            query.whereKey("objectId", equalTo: self.appDelegate.clickedMapEventId)
            query.findObjectsInBackground { (object, error) in
                if error != nil
                {
                    print(error ?? "error in query mapEventDetailsViewController")
                }
                else
                {
                    if let eventValues = object?[0]
                    {
                        //Get attenders array and save it to attendingArray
                        if let attendingArrayTemp = eventValues["attenders"] as? [String]
                        {
                            self.attendingArray = attendingArrayTemp
                            //Check if user is already attending
                            if self.attendingArray.contains(self.attendingUsers!)
                            {
                                self.createAlert(title: "Already Attending", message: "You are already attending this event")
                            }
                            else
                            {
                                self.attendingArray.append(self.attendingUsers!)
                                self.createAlert(title: "Success", message: "You are now attending this event")
                            }
                        }
                        eventValues["attenders"] = []
                        //Update atteders array
                        eventValues["attenders"] = self.attendingArray
                        eventValues.saveInBackground()
                    }
                }
            }
        }
        
        //Dismiss actionSheet
        let cancel = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) { (action) in
            print("cancelled")
        }
        
        alertController.addAction(leaveEvent)
        alertController.addAction(attendEvent)
        alertController.addAction(cancel)
        
        
        let chosenMapEvent = self.appDelegate.clickedMapEvent
        //Query events class for event details
        let query = PFQuery(className: "Events")
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
                //Retrieve event PFFile
                if let eventImage = eventValues["eventImage"] as? PFFile
                {
                    eventImage.getDataInBackground { (data, error) in
                        if error != nil
                        {
                            print(error ?? nil ?? "error retrieving image MapEventDetailsVC")
                        }
                        else
                        {
                            let finalImage = UIImage(data: data!)
                            self.eventImageView.image = finalImage
                            print("imageSet")
                        }
                    }
                }
                //Get event location
                if let eventGeoLocation = eventValues["eventGeopoint"] as? PFGeoPoint
                {
                    let userLatitude = eventGeoLocation.latitude
                    let userLongitude = eventGeoLocation.longitude
                    let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
                    
                    self.geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                        if error != nil
                        {
                            print(error ?? "error retrieving geolocation mapEventDetailsVC")
                        }
                        else
                        {
                            if let placemark = placemarks?[0] as CLPlacemark!
                            {
                                //Set sublocality
                                if let sublocality = placemark.subLocality
                                {
                                    self.evenLocationLabel.text = sublocality
                                }
                                else
                                {
                                    //Set locality
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

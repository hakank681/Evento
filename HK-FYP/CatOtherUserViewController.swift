//
//  CatOtherUserViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 20/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class CatOtherUserViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var usersName: UILabel!
    @IBOutlet weak var usersImage: UIImageView!
    @IBOutlet weak var usersUsername: UILabel!
    @IBOutlet weak var usersLocation: UILabel!
    let geocoder = CLGeocoder()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        //Query selected user details
        let clickedUsername = appDelegate.attendingUsername
        let query = PFQuery(className: "_User")
        query.whereKey("chosenUsername", equalTo: clickedUsername)
        query.findObjectsInBackground { (objects, error) in
            if error != nil
            {
                print(error ?? "error in query - CatUserVC")
            }
            else
            {
                if let object = objects?[0]
                {
                    //set profile image
                    if let profileImage = object["profileImage"] as? PFFile
                    {
                        profileImage.getDataInBackground { (data, error) in
                            if error != nil
                            {
                                print(error ?? "error retriving image - CatUserVC")
                            }
                            else
                            {
                                let finalImage = UIImage(data: data!)
                                self.usersImage.image = finalImage
                                self.usersImage.layer.borderWidth = 1
                                self.usersImage.layer.masksToBounds = false
                                self.usersImage.layer.borderWidth = 3
                                self.usersImage.layer.borderColor = UIColor.white.cgColor
                                self.usersImage.layer.cornerRadius = self.usersImage.frame.height/2
                                self.usersImage.layer.cornerRadius = self.usersImage.frame.width/2
                                self.usersImage.clipsToBounds = true
                                print("imageSet")
                            }
                        }
                    }
                    //Set users first and last name
                    if let firstName = object["firstName"] as? String, let lastName = object["lastName"] as? String
                    {
                        let finalName = ""+firstName+" "+lastName
                        print(finalName)
                        self.usersName.text = finalName
                    }
                    
                    self.usersUsername.text = self.appDelegate.attendingUsername
                    
                    //get location of user thats attending
                    if let geouserLocation = object["userHome"] as? PFGeoPoint
                    {
                        let userLatitude = geouserLocation.latitude
                        let userLongitude = geouserLocation.longitude
                        let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
                        
                        //Get location placemarks
                        self.geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                            if error != nil
                            {
                                print(error ?? "error reverseGeocode CatUserVC")
                            }
                            else
                            {
                                if let placemark = placemarks?[0] as CLPlacemark!
                                {
                                    //Set sublocality
                                    if let sublocality = placemark.subLocality
                                    {
                                        self.usersLocation.text = sublocality
                                    }
                                    else
                                    {
                                        //Set locality
                                        if let locality = placemark.locality
                                        {
                                            self.usersLocation.text = locality
                                        }
                                        else
                                        {
                                            //Set Selected postcode
                                            self.usersLocation.text = self.appDelegate.postcode
                                        }
                                        
                                    }
                                    print("\(placemark.subAdministrativeArea) sub administrative area")
                                    print("\(placemark.subLocality) sub locality")
                                    print("\(placemark.locality) locality")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

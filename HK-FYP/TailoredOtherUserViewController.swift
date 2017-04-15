//
//  TailoredOtherUserViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 15/04/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class TailoredOtherUserViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var usersName: UILabel!
    @IBOutlet weak var usersImage: UIImageView!
    @IBOutlet weak var usersUsername: UILabel!
    @IBOutlet weak var usersLocation: UILabel!
    let geocoder = CLGeocoder()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let clickedUsername = appDelegate.attendingUsername
        let query = PFQuery(className: "_User")
        query.whereKey("chosenUsername", equalTo: clickedUsername)
        query.findObjectsInBackground { (objects, error) in
            if error != nil
            {
                print(error ?? "error")
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
                                print(error ?? nil ?? "error")
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
                                print("imagSet")
                            }
                        }
                    }
                    
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
                                        self.usersLocation.text = sublocality
                                    }
                                    else
                                    {
                                        if let locality = placemark.locality
                                        {
                                            self.usersLocation.text = locality
                                        }
                                        else
                                        {
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

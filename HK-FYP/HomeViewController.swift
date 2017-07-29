//
//  HomeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Hakan Kilic on 08/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit


class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var location: UILabel!
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tabBar = UITabBar()
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //Log out user
    @IBAction func logoutButton(_ sender: Any)
    {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "firstView") as! ViewController
        self.present(controller, animated: true, completion: { () -> Void in
        })
    }
    
    @IBAction func favButton(_ sender: Any)
    {
        //Seque to user settings
        performSegue(withIdentifier: "toFavs", sender: self)

    }
    
    
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

        //Get user profile image
        let currentUser = PFUser.current()
        if let profileImage = currentUser?.object(forKey: "profileImage") as? PFFile
        {
            profileImage.getDataInBackground { (data, error) in
                if error != nil
                {
                    print(error ?? nil ?? "error")
                }
                else
                {
                    //Set ImageView size and attributes
                    let finalImage = UIImage(data: data!)
                    self.profilePicture.image = finalImage
                    self.profilePicture.layer.borderWidth = 1
                    self.profilePicture.layer.masksToBounds = false
                    self.profilePicture.layer.borderWidth = 3
                    self.profilePicture.layer.borderColor = UIColor.white.cgColor
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.height/2
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.width/2
                    self.profilePicture.clipsToBounds = true
                    print("imagSet")
                }
            }
        }
        
        
        let firstName = currentUser?.object(forKey: "firstName") as! String
        let lastName = currentUser?.object(forKey: "lastName") as! String
        let userName = currentUser?.object(forKey: "chosenUsername") as! String
        email.text = currentUser?.email
        nameSurname.text = ""+firstName+" "+lastName
        username.text = userName
        
            //Get user location
            if let geouserLocation = currentUser?.object(forKey: "userHome") as? PFGeoPoint
            {
                let userLatitude = geouserLocation.latitude
                let userLongitude = geouserLocation.longitude
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
                            //Set sublocality
                            if let sublocality = placemark.subLocality
                            {
                                self.location.text = sublocality
                            }
                            else
                            {
                                //Set locality
                                if let locality = placemark.locality
                                {
                                    self.location.text = locality
                                }
                                else
                                {
                                    //Set chosen postcode
                                    self.location.text = self.appDelegate.postcode
                                }
                                
                            }
                            print("\(placemark.subAdministrativeArea) sub administrative area")
                            print("\(placemark.subLocality) sub locality")
                            print("\(placemark.locality) locality")
                        }
                    }
                }
            }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

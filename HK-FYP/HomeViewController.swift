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
    
    @IBAction func logoutButton(_ sender: Any)
    {
        PFUser.logOut()
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    @IBAction func favButton(_ sender: Any)
    {
        performSegue(withIdentifier: "toFavs", sender: self)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation1: CLLocation = locations[0]
        let latitude = userLocation1.coordinate.latitude
        let longitude = userLocation1.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let currentUser = PFUser.current()
    
        if let profileImage = currentUser?.object(forKey: "profileImage") as? PFFile
        {
            profileImage.getDataInBackground { (data, error) in
                if error != nil
                {
                    print(error ?? nil)
                }
                else
                {
                    let finalImage = UIImage(data: data!)
                    self.profilePicture.image = finalImage
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
        
            if let geouserLocation = currentUser?.object(forKey: "userHome") as? PFGeoPoint
            {
                let userLatitude = geouserLocation.latitude
                let userLongitude = geouserLocation.longitude
                
                print(userLatitude)
                print(userLongitude)
                
                let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
                
                self.geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                    if error != nil
                    {
                        print(error)
                    }
                    else
                    {
                        if let placemark = placemarks?[0] as? CLPlacemark!
                        {
                            if let sublocality = placemark.subLocality
                            {
                                self.location.text = sublocality
                            }
                            else
                            {
                                if let locality = placemark.locality
                                {
                                    self.location.text = locality
                                }
                                else
                                {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

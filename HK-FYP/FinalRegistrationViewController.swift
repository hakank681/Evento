//
//  FinalRegistrationViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Hakan Kilic on 04/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse


class FinalRegistrationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var postcodeField: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    
   
    
    //Get Email and Hobbies
    func getData() -> (String, String, Dictionary<String, Bool>)
    {
        let userEmail = appDelegate.userEmail
        let userPassword = appDelegate.userPassword
        var hobbies = [String: Bool]()
        hobbies = appDelegate.hobbies
        
        return (userEmail, userPassword, hobbies)
    }
    
    //Alert Creator function
    func createAlert(title: String, message: String)
    {
        let missingAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        missingAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        
        self.present(missingAlert, animated: true, completion: nil)
    }

    // Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            profileImage.image = image
        }
    
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @IBOutlet weak var profileImage: UIImageView!
    
    // Edit Image Button
    @IBAction func editImageButton(_ sender: Any)
    {
        
        let imagePickerController = UIImagePickerController()
        
        //Alert
        let invalidAlert = UIAlertController(title: "Select Source", message: "Please select source for your image", preferredStyle: UIAlertControllerStyle.alert)
        invalidAlert.addAction(UIAlertAction(title: "Camera Roll", style: .default, handler: { (action) in
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
        }))
        invalidAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
        }))
        self.present(invalidAlert, animated: true, completion: nil)
    }
    
    
    func usernameIsTaken(username: String) -> Bool
    {
        //bool to see if username is taken
        var isTaken: Bool = false
        
        //access PFUsers
        var query = PFQuery(className: "_User")
        query.whereKey("chosenUsername", equalTo: userName.text!)
        query.findObjectsInBackground { (object, error) in
            if error == nil
            {
                if (object!.count > 0)
                {
                    isTaken = true
                    print("username is taken")
                    self.createAlert(title: "Username Taken", message: "Please choose another username")
                }
                else
                {
                    print("Username is available.")
                }
            }
            else
            {
                print("error")
            }

        }
        return isTaken
    }
    
    
    @IBAction func signupButton(_ sender: Any)
    {
        var address = postcodeField.text
        let geocoder = CLGeocoder()
        
        
        if firstName.text == "" || lastName.text == "" || userName.text == "" || postcodeField.text == ""
        {
            createAlert(title: "Form Error", message: "Please fill in the fields")
        }
        else
        {
            appDelegate.postcode = postcodeField.text!
            geocoder.geocodeAddressString(address!) { (placemarks, error) in
                if error != nil
                {
                    print(error)
                }
                else
                {
                    if let placemark = placemarks?[0] as? CLPlacemark!
                    {
                        let lat = placemark.location?.coordinate.latitude as! Double!
                        let lon = placemark.location?.coordinate.longitude as! Double!
                        
                        let userGeopoint = PFGeoPoint(latitude: lat!, longitude: lon!)
                        let user = PFUser.current()
                        user?["userHome"] = userGeopoint
                        user?.saveInBackground()
                        
                        
                        print("\(placemark.subAdministrativeArea) sub administrative areafinal")
                        print("\(placemark.subLocality) sub locality final")
                        print("\(placemark.locality) locality final")
                        
                    }
                }
            }
            
            self.usernameIsTaken(username: self.userName.text!)

            let (userEmail, userPassword, hobbies) = getData()
            
            var error : NSError?
            
            let jsonData = try! JSONSerialization.data(withJSONObject: hobbies, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            let userHobbies = PFObject(className: "Hobbies")
            let user = PFUser.current()
            //PFUser.current()?["firstName"] = firstName.text
            user?["firstName"] = firstName.text
            user?["lastName"] = lastName.text
            user?["chosenUsername"] = userName.text
            user?.saveInBackground()
            
            if let uploadImage = profileImage.image
            {
                activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let imageData = UIImageJPEGRepresentation(uploadImage, 0.5)
                let imageFile = PFFile(name: "profile.jpeg", data: imageData!)

                user?["profileImage"] = imageFile
                user?.saveInBackground(block: { (sucess, error) in
 
                    if error != nil
                    {
                        print(error)
                    }
                    else
                    {
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        print("image uploaded")
                    }
                })
            }
            
            //Save hobbies in hobbies class
            for (key, value) in hobbies
            {
                userHobbies[key] = value
            }
            userHobbies["user"] = PFUser.current()?.objectId
            userHobbies.saveInBackground()
            
        }
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            // Your code with delay
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
        
    }


    //Keyboard hider
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

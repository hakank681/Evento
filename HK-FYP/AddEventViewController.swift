//
//  AddEventViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 11/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class AddEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryDropdown: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var dateTimeTextField: UITextField!
    @IBOutlet weak var dateTimeDropdown: UIDatePicker!
    @IBOutlet weak var timeField: UITextField!
    
    var categoryNameDict = [String: String]()
    var categoryNameParse = ""
    let geocoder = CLGeocoder()
    var attendingUsers = [""]
    var catImageDict = [String: UIImage]()
    
    
    //Alert Creator function
    func createAlert(title: String, message: String)
    {
        let missingAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        missingAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        }))
        self.present(missingAlert, animated: true, completion: nil)
    }
    
    @IBAction func addButton(_ sender: Any)
    {
        
        if categoryTextField.text == "" || nameTextField.text == "" || dateTimeTextField.text == "" || postcodeTextField.text == "" || timeField.text == ""
        {
            createAlert(title: "Missing Form", message: "Please fill all information")
        }
        else
        {
            if let categoryNameFormat = categoryNameDict[categoryTextField.text!]
            {
                categoryNameParse = categoryNameFormat
                print(categoryNameParse)
            }
            let events = PFObject(className: "Events")
            let user = PFUser.current()
            let address = postcodeTextField.text
            let eventDate = dateTimeTextField.text
            let eventTime = timeField.text
            let parseDateFormat = DateFormatter()
            let parseTimeFormat = DateFormatter()
            parseDateFormat.timeZone = TimeZone(abbreviation: "UTC+00:00")
            parseTimeFormat.timeZone = TimeZone(abbreviation: "UTC+00:00")
            parseDateFormat.dateFormat = "dd-MM-yyyy"
            parseTimeFormat.dateFormat = "HH:mm"
            let formattedDate = parseDateFormat.date(from: eventDate!)
            let formattedTime = parseTimeFormat.date(from: eventTime!)
            
            events["category"] = categoryNameParse
            events["title"] = nameTextField.text
            events["address"] = postcodeTextField.text
            events["dateString"] = eventDate
            events["timeString"] = eventTime
            events["eventDate"] = formattedDate
            events["eventTime"] = formattedTime
            events["createdBy"] = user?.objectId
            events["attenders"] = self.attendingUsers
            
            
            //save geolocation of event postcode
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
                        events["eventGeopoint"] = userGeopoint
                        events.saveInBackground()
                    }
                }
            }
            
            //save cat image
            let chosenImage = self.catImageDict[categoryNameParse]
            
           
            
           // let imageData = UIImageJPEGRepresentation(chosenImage!, 0.5)
            let imageData2 = UIImagePNGRepresentation(chosenImage!)
            let imageFile = PFFile(name: "event.jpeg", data: imageData2!)
            print(chosenImage)
            
            
            
            events["eventImage"] = imageFile
            events.saveInBackground(block: { (sucess, error) in
                
                if error != nil
                {
                    print(error)
                }
                else
                {
                    //self.activityIndicator.stopAnimating()
                    //UIApplication.shared.endIgnoringInteractionEvents()
                    print("image uploaded")
                }
            })

        
        
            createAlert(title: "Success", message: "Event has been created")
            
            categoryTextField.text = ""
            nameTextField.text = ""
            postcodeTextField.text = ""
            dateTimeTextField.text = ""
            timeField.text = ""
  
        }
    }
    
    var categoryList = ["Career And Business", "Dancing", "Fashion And Beauty", "Film", "Food And Drink", "Gaming", "Music", "Outdoor And Adventure", "Photography", "Sports And Fitness", "Technology"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.categoryDropdown.isHidden = true
        // Do any additional setup after loading the view.
        categoryNameDict["Career And Business"] = "careerAndBusiness"
        categoryNameDict["Dancing"] = "dancing"
        categoryNameDict["Fashion And Beauty"] = "fashionAndBeauty"
        categoryNameDict["Film"] = "film"
        categoryNameDict["Food And Drink"] = "foodAndDrink"
        categoryNameDict["Gaming"] = "gaming"
        categoryNameDict["Music"] = "music"
        categoryNameDict["Outdoor And Adventure"] = "outdoorAndAdventure"
        categoryNameDict["Photography"] = "photography"
        categoryNameDict["Sports And Fitness"] = "sportsAndFitness"
        categoryNameDict["Technology"] = "technology"
        
        catImageDict["careerAndBusiness"] = UIImage(named: "careerAndBusiness.png")
        catImageDict["dancing"] = UIImage(named: "dancing.png")
        catImageDict["fashionAndBeauty"] = UIImage(named: "fashionAndBeauty.png")
        catImageDict["film"] = UIImage(named: "film.png")
        catImageDict["foodAndDrink"] = UIImage(named: "foodAndDrink.png")
        catImageDict["gaming"] = UIImage(named: "gaming.png")
        catImageDict["music"] = UIImage(named: "music.png")
        catImageDict["outdoorAndAdventure"] = UIImage(named: "outdooradventure.png")
        catImageDict["photography"] = UIImage(named: "photography.png")
        catImageDict["sportsAndFitness"] = UIImage(named: "sportsAndFitness")
        catImageDict["technology"] = UIImage(named: "technology")
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //Date and Time Picker----------------------------------
    func datePickerChanged(sender: UIDatePicker)
    {
        let formatter = DateFormatter()
        //formatter.timeStyle = .full
        formatter.dateFormat = "dd-MM-yyyy"
        self.dateTimeTextField.text = formatter.string(from: sender.date)
        print("Try this at home")
        
    }
    
    func timePickerChanged(sender: UIDatePicker)
    {
        let formatter = DateFormatter()
        //formatter.timeStyle = .full
        //formatter.dateFormat = "dd-MM-yyyy"
        formatter.dateFormat = "HH:mm"
        self.timeField.text = formatter.string(from: sender.date)
        print("Try this at home")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.dateTimeTextField.resignFirstResponder()
        return true
    }
    
    func closekeyboard()
    {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        closekeyboard()
    }
    
    
    //Category Picker-------------------------------------------------------
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        self.view.endEditing(true)
        return categoryList[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.categoryTextField.text = self.categoryList[row]
        if self.categoryTextField.text == self.categoryList[row]{
            self.nameTextField.isHidden = false
            eventNameLabel.isHidden = false
        }
        self.categoryDropdown.isHidden = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.categoryTextField
        {
            self.categoryDropdown.isHidden = false
           // if textField.tag == 3 || textField.tag == 4 || textField.tag == 1
           // {
                textField.endEditing(true)
           // }
            self.nameTextField.isHidden = true
            eventNameLabel.isHidden = true
        }
        else if textField.tag == 3
        {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
            print("This Worked")
        }
        else if textField.tag == 4
        {
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = UIDatePickerMode.time
            timeField.inputView = timePicker
            timePicker.addTarget(self, action: #selector(timePickerChanged(sender:)), for: .valueChanged)
            
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
}

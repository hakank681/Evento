//
//  FavouritesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Hakan Kilic on 09/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class FavouritesViewController: UIViewController
{

    @IBOutlet weak var outdoorAndAdventure: UISwitch!
    @IBOutlet weak var technology: UISwitch!
    @IBOutlet weak var sportsAndFitness: UISwitch!
    @IBOutlet weak var foodAndDrink: UISwitch!
    @IBOutlet weak var music: UISwitch!
    @IBOutlet weak var film: UISwitch!
    @IBOutlet weak var careerAndBusiness: UISwitch!
    @IBOutlet weak var fashionAndBeauty: UISwitch!
    @IBOutlet weak var dancing: UISwitch!
    @IBOutlet weak var gaming: UISwitch!
    @IBOutlet weak var photography: UISwitch!
    
    var activityIndicator = UIActivityIndicatorView()
    
    var switchDict = [String : UISwitch]()
    var hobbieDict = [String : Bool]()
    let hobbyNames: [String] = ["careerAndBusiness", "dancing", "fashionAndBeauty", "film", "foodAndDrink", "gaming", "music", "outdoorAndAdventure", "photography", "sportsAndFitness", "technology"]
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
      
    }
    
    //check if switch changes
    func switchIsChanged(mySwitch: UISwitch) -> Bool
    {
        var value: Bool
        if mySwitch.isOn
        {
            value = true
        }
        else
        {
            value = false
        }
        
        return value
    }
    
    @IBAction func doneButton(_ sender: Any)
    {
        hobbieDict["outdoorAndAdventure"] = switchIsChanged(mySwitch: outdoorAndAdventure)
        hobbieDict["technology"] = switchIsChanged(mySwitch: technology)
        hobbieDict["sportsAndFitness"] = switchIsChanged(mySwitch: sportsAndFitness)
        hobbieDict["foodAndDrink"] = switchIsChanged(mySwitch: foodAndDrink)
        hobbieDict["music"] = switchIsChanged(mySwitch: music)
        hobbieDict["film"] = switchIsChanged(mySwitch: film)
        hobbieDict["careerAndBusiness"] = switchIsChanged(mySwitch: careerAndBusiness)
        hobbieDict["fashionAndBeauty"] = switchIsChanged(mySwitch: fashionAndBeauty)
        hobbieDict["dancing"] = switchIsChanged(mySwitch: dancing)
        hobbieDict["gaming"] = switchIsChanged(mySwitch: gaming)
        hobbieDict["photography"] = switchIsChanged(mySwitch: photography)
        performSegue(withIdentifier: "toProfile", sender: self)
        
        //Query Hobbies class with users row
        let user = PFUser.current()?.objectId
        let someQuery = PFQuery(className: "Hobbies")
        someQuery.whereKey("user", equalTo: user!)
        someQuery.findObjectsInBackground { (object, error) in
            if error != nil
            {
                print(error ?? "error")
            }
            else
            {
                if let userHobbies = object?[0]
                {
                    //Loop through updated hobbieDict and set new values
                    for (key, value) in self.hobbieDict
                    {
                        userHobbies[key] = value
                    }
                    userHobbies.saveInBackground()
                }
            }
        }
    }

    
    func getHobbies()
    {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    
        switchDict["outdoorAndAdventure"] = outdoorAndAdventure
        switchDict["technology"] = technology
        switchDict["sportsAndFitness"] = sportsAndFitness
        switchDict["foodAndDrink"] = foodAndDrink
        switchDict["music"] = music
        switchDict["film"] = film
        switchDict["careerAndBusiness"] = careerAndBusiness
        switchDict["fashionAndBeauty"] = fashionAndBeauty
        switchDict["dancing"] = dancing
        switchDict["gaming"] = gaming
        switchDict["photography"] = photography
        
        //Query hobbies class and get users hobbies
        let user = PFUser.current()?.objectId
        let query = PFQuery(className: "Hobbies")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackground { (objects, error) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                let firstObject = objects?[0]
                
                self.hobbieDict["careerAndBusiness"] = firstObject?["careerAndBusiness"] as? Bool
                self.hobbieDict["dancing"] = firstObject?["dancing"] as? Bool
                self.hobbieDict["fashionAndBeauty"] = firstObject?["fashionAndBeauty"] as? Bool
                self.hobbieDict["film"] = firstObject?["film"] as? Bool
                self.hobbieDict["foodAndDrink"] = firstObject?["foodAndDrink"] as? Bool
                self.hobbieDict["gaming"] = firstObject?["gaming"] as? Bool
                self.hobbieDict["music"] = firstObject?["music"] as? Bool
                self.hobbieDict["outdoorAndAdventure"] = firstObject?["outdoorAndAdventure"] as? Bool
                self.hobbieDict["sportsAndFitness"] = firstObject?["sportsAndFitness"] as? Bool
                self.hobbieDict["photography"] = firstObject?["photography"] as? Bool
                self.hobbieDict["technology"] = firstObject?["technology"] as? Bool
                print(self.hobbieDict)
                
                    for (hobbieKey, hobbieValue) in self.hobbieDict
                    {
                        //Set UISwitch for selected hobbies
                        if hobbieValue == true
                        {
                            let trueSwitch = self.switchDict[hobbieKey]
                            trueSwitch?.setOn(true, animated: true)
                        }
                    }
            }
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getHobbies()
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

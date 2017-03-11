//
//  HobbiesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Hakan Kilic on 04/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class HobbiesViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var hobbieDictionary = [String: Bool]()
    
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
    
    // unused currently
    @IBAction func `switch`(_ sender: Any)
    {
        
    }
  
    @IBAction func toFinalRegistration(_ sender: Any)
    {
        
        hobbieDictionary["outdoorAndAdventure"] = switchIsChanged(mySwitch: outdoorAndAdventure)
        hobbieDictionary["technology"] = switchIsChanged(mySwitch: technology)
        hobbieDictionary["sportsAndFitness"] = switchIsChanged(mySwitch: sportsAndFitness)
        hobbieDictionary["foodAndDrink"] = switchIsChanged(mySwitch: foodAndDrink)
        hobbieDictionary["music"] = switchIsChanged(mySwitch: music)
        hobbieDictionary["film"] = switchIsChanged(mySwitch: film)
        hobbieDictionary["careerAndBusiness"] = switchIsChanged(mySwitch: careerAndBusiness)
        hobbieDictionary["fashionAndBeauty"] = switchIsChanged(mySwitch: fashionAndBeauty)
        hobbieDictionary["dancing"] = switchIsChanged(mySwitch: dancing)
        hobbieDictionary["gaming"] = switchIsChanged(mySwitch: gaming)
        hobbieDictionary["photography"] = switchIsChanged(mySwitch: photography)
        
        self.appDelegate.hobbies = hobbieDictionary
        print(hobbieDictionary)
        self.performSegue(withIdentifier: "finalView", sender: sender)
    }
    
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
  
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Hobbies View Loaded")
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

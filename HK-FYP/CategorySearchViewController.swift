//
//  CategorySearchViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 16/03/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class CategorySearchViewController: UIViewController {
    
    @IBOutlet weak var gaming: UIImageView!
    @IBOutlet weak var dancing: UIImageView!
    @IBOutlet weak var sportsAndFitness: UIImageView!
    @IBOutlet weak var fashionAndBeauty: UIImageView!
    @IBOutlet weak var film: UIImageView!
    @IBOutlet weak var music: UIImageView!
    @IBOutlet weak var outdoorAndAdventure: UIImageView!
    @IBOutlet weak var photography: UIImageView!
    @IBOutlet weak var technology: UIImageView!
    @IBOutlet weak var careerAndBusiness: UIImageView!
    @IBOutlet weak var foodAndDrink: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        
    
        print("imagetapped")
        let tappedImage = gestureRecognizer.view
        if let tappedCat = tappedImage?.tag
        {
            if tappedCat == 1
            {
                self.appDelegate.clickedCategory = "gaming"
            }
            if tappedCat == 2
            {
                self.appDelegate.clickedCategory = "dancing"
            }
            if tappedCat == 3
            {
                self.appDelegate.clickedCategory = "sportsAndFitness"
            }
            if tappedCat == 4
            {
                self.appDelegate.clickedCategory = "fashionAndBeauty"
            }
            if tappedCat == 5
            {
                self.appDelegate.clickedCategory = "film"
            }
            if tappedCat == 6
            {
                self.appDelegate.clickedCategory = "music"
            }
            if tappedCat == 7
            {
                self.appDelegate.clickedCategory = "outdoorAndAdventure"
            }
            if tappedCat == 8
            {
                self.appDelegate.clickedCategory = "photography"
            }
            if tappedCat == 9
            {
                self.appDelegate.clickedCategory = "technology"
            }
            if tappedCat == 10
            {
                self.appDelegate.clickedCategory = "careerAndBusiness"
            }
            if tappedCat == 11
            {
                self.appDelegate.clickedCategory = "foodAndDrink"
            }
        }
     
        performSegue(withIdentifier: "toNavController", sender: self)
    }
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gaming.tag = 1
        dancing.tag = 2
        sportsAndFitness.tag = 3
        fashionAndBeauty.tag = 4
        film.tag = 5
        music.tag = 6
        outdoorAndAdventure.tag = 7
        photography.tag = 8
        technology.tag = 9
        careerAndBusiness.tag = 10
        foodAndDrink.tag = 11
        
        
        let gamingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let dancingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let sportsAndFitnessTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let fashionAndBeautyTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let filmTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let musicTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let outdoorAndAdventureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let photographyTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let technologyTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let careerAndBusinessTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        let foodAndDrinkTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        
        gaming.addGestureRecognizer(gamingTapRecognizer)
        dancing.addGestureRecognizer(dancingTapRecognizer)
        sportsAndFitness.addGestureRecognizer(sportsAndFitnessTapRecognizer)
        fashionAndBeauty.addGestureRecognizer(fashionAndBeautyTapRecognizer)
        film.addGestureRecognizer(filmTapRecognizer)
        music.addGestureRecognizer(musicTapRecognizer)
        outdoorAndAdventure.addGestureRecognizer(outdoorAndAdventureTapRecognizer)
        photography.addGestureRecognizer(photographyTapRecognizer)
        technology.addGestureRecognizer(technologyTapRecognizer)
        careerAndBusiness.addGestureRecognizer(careerAndBusinessTapRecognizer)
        foodAndDrink.addGestureRecognizer(foodAndDrinkTapRecognizer)
        

        
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

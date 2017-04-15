//
//  ChangePasswordViewController.swift
//  HK-FYP
//
//  Created by Hakan Kilic on 15/04/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordViewController: UIViewController
{

    @IBOutlet weak var emailField: UITextField!
  
    
    //email validity vhecker
    func emailValid(emailString:String) -> Bool
    {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let tester = NSPredicate(format:"SELF MATCHES %@", regularExpression)
        return tester.evaluate(with: emailString)
    }
    
    //Alert Creator function
    func createAlert(title: String, message: String)
    {
        
        let missingAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        missingAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        
        self.present(missingAlert, animated: true, completion: nil)
    }

    
    @IBAction func changeButton(_ sender: Any)
    {
        
        if emailField.text == ""
        {
            createAlert(title: "Error In Form", message: "Please fill all fields")
        }
        else
        {
            if let emailtext = emailField.text
            {
                
                if emailValid(emailString: emailtext) == false
                {
                    createAlert(title: "Error In Form", message: "Please enter a valid email address")
                }
                else
                {
                    if PFUser.current()?.username != emailtext
                    {
                        createAlert(title: "Error In Form", message: "Please enter your email address")
                    }
                    else
                    {
                        PFUser.requestPasswordResetForEmail(inBackground: self.emailField.text!, block: { (sucess, error) in
                            if error != nil {
                                print("error")
                            }
                            else
                            {
                                print("email sent")
                            }
                        })
                    }
                    
                   
                }
            }
        }

        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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

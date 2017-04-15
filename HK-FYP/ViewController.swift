/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var haveAnAccountOutlet: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    
    
    
    //email validity vhecker
    func emailValid(emailString:String) -> Bool {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let tester = NSPredicate(format:"SELF MATCHES %@", regularExpression)
        return tester.evaluate(with: emailString)
    }
    
    //Alert Creator function
    func createAlert(title: String, message: String){
        
        let missingAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        missingAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        
        self.present(missingAlert, animated: true, completion: nil)
    }
    

    //User Exists Checker
    func usernameIsTaken(username: String) -> Bool
    {
        //bool to see if username is taken
        var isTaken = false
        
        //access PFUsers
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: emailTextField.text!)
        do
        {
            let object = try query.findObjects() as [PFObject]
            if (object.count > 0)
            {
                isTaken = true
            }
        }
        catch
        {
            print("error in query")
        }
        
        return isTaken
    }
    
 
    
    @IBAction func nextButton(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
                
        appDelegate.userEmail = emailTextField.text!
        appDelegate.userPassword = passwordTextField.text!
        
        // Email and Password Field Checker
        if emailTextField.text == "" || passwordTextField.text == ""
        {
            createAlert(title: "Error In Form", message: "Please enter an email address and password")
        }
        else
        {
            //Passes text into email validity checker
            if let emailtext = emailTextField.text
            {
              
                if emailValid(emailString: emailtext) == false
                {
                    createAlert(title: "Error In Form", message: "Please enter a valid email address")
                }
                else
                {
                    let taken = usernameIsTaken(username: emailTextField.text!)
                    if taken == true && signupMode == true
                    {
                        self.createAlert(title: "User exists", message: "Please LogIn")
                    }
                }
            }
            
            if signupMode == true
            {
                //Signup mode
                
                let user = PFUser()
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil
                    {
                        var displayErrorMessage = "Please try again later."
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String
                        {
                            displayErrorMessage = errorMessage
                        }
                        self.createAlert(title: "Error", message: displayErrorMessage)
                        
                    }
                    else
                    {
                        print("user signed up")
                    }
                    
                })
                
                
                UIApplication.shared.endIgnoringInteractionEvents()
                self.performSegue(withIdentifier: "toHobbies", sender: self)
            }
            else
            {
                //LogIn Mode
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    self.activityIndicator.stopAnimating()
                    
                    if error != nil
                    {
                        var displayErrorMessage = "Please try again later."
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String
                        {
                            displayErrorMessage = errorMessage
                        }
                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                    }
                    else
                    {
                        print("Logged in")
                        self.performSegue(withIdentifier: "toHome", sender: self)
                        let query = PFQuery(className: "Hobbies")
                        query.whereKey("user", equalTo: PFUser.current()?.objectId)
                        
                        query.findObjectsInBackground(block: { (objects, error) in
                            
                            if let objects = objects
                            {
                                print(objects)
                            }
                        })
                    }
                    
                })
            }

        }
        
    }
    
    //SignUP or LogIN Switcher
    @IBAction func haveAnAccountButton(_ sender: Any)
    {
        if signupMode == true
        {
            // change to log in mode
            let loginImage = UIImage(named: "loginButton.png")
            nextButtonOutlet.setImage(loginImage, for: [])
            haveAnAccountOutlet.setTitle("Dont have an account?", for: [])
            signupMode = false
        }
        else
        {
            // change to signup mode
            let nextImage = UIImage(named: "nextButton.png")
            nextButtonOutlet.setImage(nextImage, for: [])
            haveAnAccountOutlet.setTitle("Already have an account?", for: [])
            signupMode = true
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

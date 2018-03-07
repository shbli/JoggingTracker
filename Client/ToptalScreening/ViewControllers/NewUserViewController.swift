//
//  RegisterViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-02.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class NewUserViewController : UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var CreateUserSuccess: ((_ username: String,_ password: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @IBAction func onCancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateClicked(_ sender: UIBarButtonItem) {
        if (validateFields()) {
            SharedAccountService.createUser(username: usernameTextField.text!, password: passwordTextField.text!, first_name: firstNameTextField.text!, last_name: lastNameTextField.text!, email: emailTextField.text!, onSuccess: {
                DispatchQueue.main.async {
                    self.CreateUserSuccess?(self.usernameTextField.text!, self.passwordTextField.text!)
                    self.dismiss(animated: true, completion: nil)
                }
            }, onError: { (error) in
                AlertUtility.ShowAlert(uiViewController: self, title: "Error!", message: error)
            })
        }
    }
    
    func validateFields() -> Bool {
        if (firstNameTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "All fields must be filled!")
            return false;
        }
        if (lastNameTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "All fields must be filled!")
            return false;
        }
        if (usernameTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "All fields must be filled!")
            return false;
        }
        if (emailTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "All fields must be filled!")
            return false;
        }
        if (passwordTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "All fields must be filled!")
            return false;
        }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (emailTest.evaluate(with: emailTextField.text!) == false) {
            AlertUtility.ShowAlert(uiViewController: self, title: "Incorrect e-mail format!")
            return false;
        }
        
        if (passwordTextField.text != confirmPasswordTextField.text) {
            AlertUtility.ShowAlert(uiViewController: self, title: "Password do not match!")
            return false;
        }
        return true;
    }
}

//
//  ViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-02.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginUIButton: UIButton!
    @IBOutlet weak var registerUIButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "loginToNewUser") {
            guard let newUserNavViewController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let newUserViewController = newUserNavViewController.visibleViewController as? NewUserViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            newUserViewController.CreateUserSuccess = CreateUserSuccess(username:password:)
        }
    }
    
    func CreateUserSuccess(username: String, password: String) {
        usernameTextField.text = username
        passwordTextField.text = password
    }
    
    @IBAction func OnLoginClicked(_ sender: UIButton) {
        if (validateFields()) {
            SharedAccountService.authUser(username: usernameTextField.text!, password: passwordTextField.text!, onSuccess: {
                print("On success")
                print("UserModelToken " + UserAccountModel!.token!)
                
                if (UserAccountModel != nil) {
                    
                    let accountType: AccountType = UserAccountModel!.accountType()
                    switch accountType {
                    case AccountType.Admin:
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "login_successful_admin", sender: nil)
                        }
                        break;
                    case AccountType.UserManager:
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "login_successful_all_users", sender: nil)
                        }
                        break;
                    case AccountType.RecordsAdmin:
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "login_successful_jog_history", sender: nil)
                        }
                        break;
                    case AccountType.RegularUser:
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "login_successful_jog_history", sender: nil)
                        }
                        break;
                    case AccountType.None:
                        DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Unkowen account type!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true, completion: nil)
                        }
                        break;
                    }
                }
            },
            onError: {error -> Void in
            print(error)
            })
        }
    }
    
    func validateFields() -> Bool {
        if (usernameTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Enter username!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
        if (passwordTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Enter password!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
        
        return true;
    }
}


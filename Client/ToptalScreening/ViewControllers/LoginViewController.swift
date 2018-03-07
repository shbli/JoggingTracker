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
                        self.loadAllUsers()
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "login_successful_admin", sender: nil)
                        }
                        break;
                    case AccountType.UserManager:
                        self.loadAllUsers()
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "login_successful_all_users", sender: nil)
                        }
                        break;
                    case AccountType.RecordsAdmin:
                        self.loadAllUsers()
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
                            AlertUtility.ShowAlert(uiViewController: self, title: "Unkowen account type")
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
    
    func loadAllUsers() {
        SharedAccountService.getAllUsers(onSuccess: {},
                                         onError:
            {(error) in
                AlertUtility.ShowAlert(uiViewController: self, title: error)
        })
    }
    
    func validateFields() -> Bool {
        if (usernameTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "Enter username!")
            return false;
        }
        if (passwordTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "Enter password!")
            return false;
        }
        
        return true;
    }
}


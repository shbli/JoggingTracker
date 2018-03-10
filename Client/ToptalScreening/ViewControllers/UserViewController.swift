//
//  UserViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-06.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "Admin"
        case 1:
            return "UserManager"
        case 2:
            return "RegularUser"
        case 3:
            return "RecordsAdmin"
        default:
            return "None"
        }
    }

    var accountModel: AccountModel?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var permissionPickerView: UIPickerView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let accountModel = accountModel {
            firstNameTextField.text = accountModel.first_name!
            lastNameTextField.text = accountModel.last_name!
            usernameTextField.text = accountModel.username!
            emailTextField.text = accountModel.email!
            if let password = accountModel.password { passwordTextField.text = password }

            //hide the cancel button while editing, so we can see the "Back" button
            navigationItem.leftBarButtonItem = nil
        }
        
        //only admins are allowed to modify user permissions
        if (UserAccountModel?.accountType() == AccountType.Admin || UserAccountModel?.accountType() == AccountType.UserManager) {
            preparePermissionPicker()
        } else {
            permissionPickerView.isHidden = true
        }
    }
    
    func preparePermissionPicker() {
        permissionPickerView.dataSource = self
        permissionPickerView.delegate = self
        
        var row: Int = 0
        if let accountModel = accountModel {
            switch accountModel.accountType() {
            case .Admin:
                row = 0
                break
            case .UserManager:
                row = 1
                break
            case .RegularUser:
                row = 2
                break
            case .RecordsAdmin:
                row = 3
                break
            case .None:
                AlertUtility.ShowAlert(uiViewController: self, title: "User permission none!")
            }
        } else {
            //RegularUser will be the default permission
            row = 2
        }

        permissionPickerView.selectRow(row, inComponent: 0, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            print("The save button was not pressed, cancelling")
            return
        }
        
        if (accountModel == nil) {
            accountModel = AccountModel()
        }
        
        accountModel?.username = usernameTextField.text
        accountModel?.first_name = firstNameTextField.text
        accountModel?.last_name = lastNameTextField.text
        accountModel?.email = emailTextField.text
        accountModel?.password = passwordTextField.text
        if (permissionPickerView.isHidden == false) {
            if (accountModel?.groups == nil) {
                accountModel?.groups = [Int]()
            }
            accountModel?.groups?.removeAll()
            accountModel?.groups?.append(permissionPickerView.selectedRow(inComponent: 0) + 1)
        }
    }

    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
        if (validateFields()) {
            self.performSegue(withIdentifier: "unwindToUserListWithSender", sender: sender)
        }
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        if (accountModel == nil) {
            //for new accounts, password field must be filled
            if (passwordTextField.text?.isEmpty)! {
                AlertUtility.ShowAlert(uiViewController: self, title: "All fields must be filled!")
                return false;
            }
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

//
//  NewJogViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-03.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit


//class UserPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
//
//}

class JogViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AllUsersAccounts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AllUsersAccounts[row].username!
    }
    
    var jog: Jog?
    
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var activityTimeDatePicker: UIDatePicker!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var userPickerView: UIPickerView!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let jog = jog {
            notesTextField.text = jog.notes!
            activityTimeDatePicker.date = jog.activity_start_time!
            distanceTextField.text = String(jog.distance!)
            timeTextField.text = String(jog.time!)
            
            //hide the cancel button while editing, so we can see the "Back" button
            navigationItem.leftBarButtonItem = nil
        }
        
        if (UserAccountModel?.accountType() == AccountType.Admin || UserAccountModel?.accountType() == AccountType.RecordsAdmin) {
            prepareUserPicker()
        } else {
            userPickerView.isHidden = true
        }
    }
    
    func prepareUserPicker() {
        userPickerView.dataSource = self
        userPickerView.delegate = self
        
        var row: Int = 0
        if let jog = jog {
            row = AllUsersAccounts.index(where: {(accountModel) in
                return accountModel.id == jog.author})!
        } else {
            //my user will be the default user
            row = AllUsersAccounts.index(where: {(accountModel) in
                return accountModel.id == UserAccountModel?.id})!
        }
        print("Selected row " + String(row))
        userPickerView.selectRow(row, inComponent: 0, animated: true)
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
        
        if (jog == nil) {
            jog = Jog()
        }
        
        jog?.notes = notesTextField.text
        jog?.activity_start_time = activityTimeDatePicker.date
        jog?.distance = Int(distanceTextField.text!)
        jog?.time = Int(timeTextField.text!)
        if (userPickerView.isHidden == false) {
            jog?.author = AllUsersAccounts[userPickerView.selectedRow(inComponent: 1)].id
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
        if (validateFields()) {
            self.performSegue(withIdentifier: "unwindToJogListWithSender", sender: sender)
        }
    }

    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func valueChanged(_ sender: UITextField) {
        if let last = sender.text?.last {
            let zero: Character = "0"
            let num: Int = Int(UnicodeScalar(String(last))!.value - UnicodeScalar(String(zero))!.value)
            if (num < 0 || num > 9) {
                //remove the last character as it is invalid
                sender.text?.removeLast()
            }
        }
    }
    
    
    func validateFields() -> Bool {
        if (notesTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "All fields must be filled!")
            return false;
        }
        if (distanceTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "All fields must be filled!")
            return false;
        }
        if (timeTextField.text?.isEmpty)! {
            AlertUtility.ShowAlert(uiViewController: self, title: "All fields must be filled!")
            return false;
        }
        return true;
    }

}

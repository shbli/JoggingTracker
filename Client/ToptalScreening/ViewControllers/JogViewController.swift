//
//  NewJogViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-03.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit
import os.log

class JogViewController: UIViewController {
    
    var jog: Jog?
    
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var activityTimeDatePicker: UIDatePicker!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
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
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        if (jog == nil) {
            jog = Jog()
        }
        
        jog?.notes = notesTextField.text
        jog?.activity_start_time = activityTimeDatePicker.date
        jog?.distance = Int(distanceTextField.text!)
        jog?.time = Int(timeTextField.text!)
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
            let alert = UIAlertController(title: "All fields must be filled!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
        if (distanceTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "All fields must be filled!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
        if (timeTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "All fields must be filled!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
        return true;
    }

}

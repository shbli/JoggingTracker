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
    
    @IBOutlet weak var labelTextField: UITextField!    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let jog = jog {
            labelTextField.text = jog.label
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
        
        let label = labelTextField.text ?? ""
        jog = Jog(label: label)
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

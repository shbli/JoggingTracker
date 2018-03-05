//
//  RegisterViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-02.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class RegisterViewController : UIViewController {
    
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
}

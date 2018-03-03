//
//  ViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-02.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _login: UIButton!
    @IBOutlet weak var _register: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnLoginClicked(_ sender: UIButton) {
        print("Login clicked")
    }
    @IBAction func OnRegisterClicked(_ sender: UIButton) {
        print("Register clicked")
    }
    
}


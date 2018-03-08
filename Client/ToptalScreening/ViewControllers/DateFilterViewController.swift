//
//  DateFilterViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-08.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class DateFilterViewController: UIViewController {

    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    var from: Date?
    var to: Date?
    
    
    var FilterDate: ((_ from: Date,_ to: Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        fromDatePicker.date = from!
        toDatePicker.date = to!
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            // Your code...
            print("DateFilterViewController.viewWillDisappear")
        }
    }
    override func willMove(toParentViewController parent: UIViewController?)
    {
        super.willMove(toParentViewController: parent)
        if parent == nil
        {
            print("DateFilterViewController.willMove")
            FilterDate!(fromDatePicker.date, toDatePicker.date)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

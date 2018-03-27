//
//  DateFilterViewController.swift
//  JoggingTracker
//
//  Created by Shbli on 2018-03-08.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class DateFilterViewController: UIViewController {

    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var from: Date?
    var to: Date?

    var minimumDate: Date?
    var maximumDate: Date?

    
    var FilterDate: ((_ from: Date,_ to: Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "detailwallpaper.jpg")!)
        fromDatePicker.setValue(UIColor.white, forKey: "textColor")
        toDatePicker.setValue(UIColor.white, forKey: "textColor")

        self.navigationItem.rightBarButtonItem = saveBarButton
        
        fromDatePicker.date = from!
        fromDatePicker.minimumDate = minimumDate!
        fromDatePicker.maximumDate = maximumDate!
        toDatePicker.date = to!
        toDatePicker.minimumDate = minimumDate!
        toDatePicker.maximumDate = maximumDate!

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
        }
    }

    @IBAction func saveClicked(_ sender: Any) {
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDatePicker.date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        from = gregorian.date(from: components)
        
        components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: toDatePicker.date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        to = gregorian.date(from: components)
        
        FilterDate!(from!, to!)
        _ = navigationController?.popViewController(animated: true)
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

//
//  AlertUtility.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-06.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class AlertUtility {
    static func ShowAlert(uiViewController: UIViewController, title: String) -> Void {
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        uiViewController.present(alert, animated: true, completion: nil)
    }

    static func ShowAlert(uiViewController: UIViewController, title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        uiViewController.present(alert, animated: true, completion: nil)
    }
}

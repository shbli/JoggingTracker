//
//  UserTableViewCell.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-06.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

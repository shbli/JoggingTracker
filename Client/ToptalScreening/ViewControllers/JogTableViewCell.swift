//
//  JogTableViewCell.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-03.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class JogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var speed: UILabel!

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

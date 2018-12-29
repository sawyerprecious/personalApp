//
//  MainMenuTableViewCell.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-12-18.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        img.image = nil
        label.text = ""
        self.accessoryType = .disclosureIndicator
    }

    
}

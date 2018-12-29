//
//  ChecklistTableViewCell.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-12-19.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var onSwitch: UISwitch!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var extraDelegate: DelegateExtensions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    
    @IBAction func buttonPress(_ sender: UIButton) {
        self.extraDelegate?.buttonTap(cell: self)
    }
    
    @IBAction func switchFlip(_ sender: UISwitch) {
        self.extraDelegate?.switchFlip(cell: self)
    }
    
}

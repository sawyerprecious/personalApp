//
//  NoteTableViewCell.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-14.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var noteName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

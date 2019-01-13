//
//  DreamTableViewCell.swift
//  Ghost's Dreams
//
//  Created by Smsma Mac on 12/10/18.
//  Copyright © 2018 Samar Khaled. All rights reserved.
//

import UIKit

class DreamTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

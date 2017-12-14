//
//  StationCellTableViewCell.swift
//  HappayAssignment
//
//  Created by Sanjay Mali on 15/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit

class StationCellTableViewCell: UITableViewCell {

    @IBOutlet weak var name_Lbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var empty_slots: UILabel!
    @IBOutlet weak var free_bikes: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

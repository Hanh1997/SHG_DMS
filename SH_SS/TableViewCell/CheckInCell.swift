//
//  CheckInCell.swift
//  SH_SS
//
//  Created by phạm Hưng on 3/22/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class CheckInCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var DateCheckLbl: UILabel!
    @IBOutlet weak var cmpnameLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

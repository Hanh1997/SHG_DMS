//
//  DashboardTableViewCell.swift
//  SH_SS
//
//  Created by phạm Hưng on 5/2/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var imgStt: UIImageView!
    @IBOutlet weak var LbVistDay: UILabel!
    @IBOutlet weak var lbCmpName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lbCmpName.contentMode = .scaleToFill
        lbCmpName.numberOfLines = 2
        LbVistDay.contentMode = .scaleToFill
        LbVistDay.numberOfLines = 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

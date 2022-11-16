//
//  MessageTableViewCell.swift
//  SH_SS
//
//  Created by Hung on 6/5/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var MessageTitle: UILabel!
    @IBOutlet weak var Messageexplain: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

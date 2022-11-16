//
//  DetailMoneyTableViewCell.swift
//  SH_SS
//
//  Created by Hung on 6/20/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class DetailMoneyTableViewCell: UITableViewCell {

    @IBOutlet weak var PunishDate: UILabel!
    @IBOutlet weak var EmpPenalties: UILabel!
    @IBOutlet weak var PunishGroupName: UILabel!
    @IBOutlet weak var PunishReason: UILabel!
    @IBOutlet weak var SubtractMoney: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

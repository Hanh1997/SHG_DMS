//
//  ReportResultTableViewCell.swift
//  SH_SS
//
//  Created by phạm Hưng on 4/21/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class ReportResultTableViewCell: UITableViewCell {

    @IBOutlet weak var infoItemCode: UILabel!
    @IBOutlet weak var infoValue: UILabel!
    @IBOutlet weak var SaleQuantity: UILabel!
    @IBOutlet weak var SalePrice: UILabel!
    @IBOutlet weak var ShowroomStock: UILabel!
    @IBOutlet weak var StockQuantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoItemCode.contentMode = .scaleToFill
        infoItemCode.numberOfLines = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

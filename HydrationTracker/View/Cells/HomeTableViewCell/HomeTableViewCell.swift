//
//  HomeTableViewCell.swift
//  HydrationTracker
//
//  Created by apple on 26/11/24.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var viewForCell: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        viewForCell.layer.borderWidth = 1
        viewForCell.layer.borderColor = UIColor.gray.cgColor
        viewForCell.layer.cornerRadius = 5
        
    }
    
}

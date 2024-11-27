//
//  AddCollectionViewCell.swift
//  HydrationTracker
//
//  Created by apple on 27/11/24.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var titleLabel : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.layer.borderWidth = 1
    }

}

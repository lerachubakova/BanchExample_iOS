//
//  InfoCollectionVCell.swift
//  BanchExample
//
//  Created by User on 7.10.21.
//

import UIKit

class InfoCollectionVCell: UICollectionViewCell {

    static let identifier = "infoCollectionVCell"

    static func nib() -> UINib {
        return UINib(nibName: String(describing: Self.self), bundle: Bundle.main)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

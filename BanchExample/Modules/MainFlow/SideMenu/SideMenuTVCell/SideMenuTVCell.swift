//
//  SideMenuTVCell.swift
//  BanchExample
//
//  Created by User on 13.09.21.
//

import UIKit

class SideMenuTVCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var optionImageView: UIImageView!

    class var identifier: String {
        return String(describing: self)
    }

    class var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitle(title: String) {
        titleLabel.text = title
    }

    func setImage(image: UIImage) {
        optionImageView.image = image
    }
    
}

//
//  InfoCollectionVCell.swift
//  BanchExample
//
//  Created by User on 7.10.21.
//

import UIKit

final class InfoCollectionVCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!

    static let identifier = "infoCollectionVCell"

    private var image: UIImage?

    static func nib() -> UINib {
        return UINib(nibName: String(describing: Self.self), bundle: Bundle.main)
    }

    func configure(with image: UIImage?) {
        self.imageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

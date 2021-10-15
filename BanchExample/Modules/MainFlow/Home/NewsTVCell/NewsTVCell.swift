//
//  NewsTVCell.swift
//  BanchExample
//
//  Created by User on 14.10.21.
//

import UIKit

final class NewsTVCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    static let identifier = "newsTVCell"

    static var nib: UINib {
        UINib(nibName: String(describing: Self.self), bundle: Bundle.main)
    }

    func configure(by news: NewsModel) {
        titleLabel.text = news.getTitle()
        descriptionLabel.text = news.getDescription()
        sourceLabel.text = news.getSource()
        dateLabel.text = DateFormatter(format:"HH:mm dd.MM.yy").string(from: news.getDate())
    }
}

//
//  NewsTVCell.swift
//  BanchExample
//
//  Created by User on 14.10.21.
//

import UIKit

final class NewsTVCell: UITableViewCell {

    @IBOutlet private weak var wasViewedImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var wasDeletedImageView: UIImageView!
    @IBOutlet private weak var isUnintrestingImageView: UIImageView!

    private unowned var news: News!

    static let identifier = "newsTVCell"

    static var nib: UINib {
        UINib(nibName: String(describing: Self.self), bundle: Bundle.main)
    }

    func configure(by news: NewsModel) {
        titleLabel.text = news.title
        descriptionLabel.text = news.description
        sourceLabel.text = news.source
        dateLabel.text = DateFormatter(format:"HH:mm dd.MM.yy").string(from: news.date)
    }

    func configure(by news: News) {
        self.news = news
        titleLabel.text = news.title
        descriptionLabel.text = news.extract
        sourceLabel.text = news.source

        if news.wasViewed, var titleText = self.titleLabel.text {
            titleText.insert(contentsOf: "      ", at: titleText.startIndex)
            self.titleLabel.text = titleText
            wasViewedImageView.isHidden = false
        } else {
            wasViewedImageView.isHidden = true
        }

        if let date = news.date {
            dateLabel.text = DateFormatter(format:"HH:mm dd.MM.yy").string(from: date)
        } else {
            dateLabel.text = ""
        }

        wasDeletedImageView.isHidden = !news.wasDeleted
        isUnintrestingImageView.isHidden = news.isInteresting
    }

    func changeInterestingStatus() {
        isUnintrestingImageView.isHidden = news.isInteresting
    }

    func changeDeletedStatus() {
        wasDeletedImageView.isHidden = !news.wasDeleted
    }
}

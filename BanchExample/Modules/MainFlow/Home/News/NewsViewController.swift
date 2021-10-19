//
//  NewsViewController.swift
//  BanchExample
//
//  Created by User on 19.10.21.
//

import UIKit

class NewsViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!

    private var newsTitle: String?
    private var newsBody: String?

    func setNews(_ news: (title: String, body: String)) {
        self.newsTitle = news.title
        self.newsBody = news.body
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = newsTitle
        textLabel.text = newsBody
    }

}

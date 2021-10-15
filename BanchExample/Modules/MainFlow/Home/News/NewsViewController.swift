//
//  NewsViewController.swift
//  BanchExample
//
//  Created by User on 15.10.21.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    private var newsLink: URL?
    private var isFirstPage = true

    func setURL(url:URL?) {
        self.newsLink = url
    }

    override func viewDidLoad() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .clear
        startRequest()
    }

    private func startRequest() {
        guard let strongURL = newsLink else { return }

        // TODO: start animation
        let myRequest = URLRequest(url: strongURL)
        webView.load(myRequest)
    }

}

extension NewsViewController: WKUIDelegate {

}

extension NewsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard isFirstPage else { return }
        print("\n LOG loaded:")
        // TODO: stop animation
        isFirstPage = false
    }
}

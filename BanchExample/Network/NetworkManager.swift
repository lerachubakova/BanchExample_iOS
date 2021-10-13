//
//  NetworkManager.swift
//  BanchExample
//
//  Created by User on 12.10.21.
//

import Foundation

final class NetworkManager: NSObject {
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?

    func makeXMLNewsRequest(completion: @escaping ([News]?) -> Void) {
        guard let url = URL(string: "https://www.gazeta.ru/export/rss/lenta.xml") else { return }
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("\n NetworkManager: makeXMLNewsRequest: \(error!.localizedDescription)")
                return
            }

            if let strongResponse = response {
                 print("\n", strongResponse.debugDescription)
            }

            if let data = data, let news = NewsXMLParser().getNews(from: data) {
                completion(news)
            } else {
                print("\n NetworkManager: makeXMLNewsRequest no data or can't parse news.")
            }
        }
        dataTask?.resume()
    }
}

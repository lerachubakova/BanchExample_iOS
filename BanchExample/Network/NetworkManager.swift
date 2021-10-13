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

    func makeXMLNewsRequest(completion: @escaping (XMLResponseNewsModel?) -> Void) {
        guard let url = URL(string: "https://www.gazeta.ru/export/rss/lenta.xml") else { return }
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("\n NetworkManager: makeXMLNewsRequest: \(error!.localizedDescription)")
                return
            }

            if let strongResponse = response as? HTTPURLResponse {
                if strongResponse.statusCode != 200 {
                    print("\n", strongResponse.debugDescription)
                }
            }

            if let data = data, let news = NewsXMLParser().getNews(from: data) {
                completion(news)
            } else {
                print("\n NetworkManager: makeXMLNewsRequest no data or can't parse news.")
            }
        }
        dataTask?.resume()
    }

    func makeJSONNewsRequest(completion: @escaping (JSONResponseNewsModel?) -> Void) {

        guard var urlComponents = URLComponents(string: APIConstants.baseURL) else { return }

        urlComponents.queryItems =
            [
                URLQueryItem(name: APIConstants.nameSources, value: APIConstants.valueSources),
                URLQueryItem(name: APIConstants.nameKey, value: APIConstants.valueKey)
            ]

        guard let url = urlComponents.url else { return }
        
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("\n NetworkManager: makeJSONNewsRequest: \(error!.localizedDescription)")
                return
            }

            if let strongResponse = response as? HTTPURLResponse {
                if strongResponse.statusCode != 200 {
                    print("\n", strongResponse.debugDescription)
                }
            }
            if let data = data {
                let news = try? JSONDecoder().decode(JSONResponseNewsModel.self, from: data)
                completion(news)
            } else {
                print("\n NetworkManager: makeJSONNewsRequest no data or can't parse news.")
            }
        }
        dataTask?.resume()
    }
}

//
//  HomeViewModel.swift
//  BanchExample
//
//  Created by User on 12.10.21.
//

import Foundation

final class HomeViewModel {
    func getNews() {
        NetworkManager().makeXMLNewsRequest { news in
            guard let strongNews = news else { return }
            print("\n HomeViewModel LOG news:")
            _ = strongNews.map { print($0.debugDescription) }
        }
    }
}

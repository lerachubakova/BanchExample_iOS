//
//  HomeViewModel.swift
//  BanchExample
//
//  Created by User on 12.10.21.
//

import Foundation

final class HomeViewModel {
    private var XMLNews: [News]?

    func getXMLNews() {
        DispatchQueue.main.async {
            NetworkManager().makeXMLNewsRequest { [weak self] news in
                guard let strongNews = news else { return }
                self?.XMLNews = strongNews
            }
        }
    }
}

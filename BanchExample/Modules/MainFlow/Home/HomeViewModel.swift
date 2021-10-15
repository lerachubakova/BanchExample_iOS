//
//  HomeViewModel.swift
//  BanchExample
//
//  Created by User on 12.10.21.
//

import Foundation

enum State {
    case nobodyFinished
    case oneFinished
    case twoFinished

    mutating func toggle() {
        switch self {
        case .nobodyFinished:
            self = .oneFinished
        case .oneFinished:
            self = .twoFinished
        case .twoFinished:
           break
        }
    }
}

final class HomeViewModel {

    var newsArray = NewsArray()
    weak var controller: HomeViewController?

    private var requestState: State = .nobodyFinished {
        willSet {
            if newValue == .twoFinished {
                newsArray.sort()
                controller?.endRefresh()
                controller?.reloadTable()
            }
        }
    }

    init(vc: HomeViewController) {
        self.controller = vc
    }

    func getNews() {
        newsArray = NewsArray()
        getJSONNews()
        getXMLNews()
    }

    private func getXMLNews() {
        DispatchQueue.main.async {
            NetworkManager().makeXMLNewsRequest { [weak self] news in
                guard let strongNews = news else { return }
                self?.newsArray.append(array: strongNews)
                // add to coredata
                self?.requestState.toggle()
            }
        }
    }

    private func getJSONNews() {
        DispatchQueue.main.async {
            NetworkManager().makeJSONNewsRequest { [weak self] news in
                guard let strongNews = news else { return }
                self?.newsArray.append(array: strongNews)
                // add to coredata
                self?.requestState.toggle()
            }
        }
    }

}

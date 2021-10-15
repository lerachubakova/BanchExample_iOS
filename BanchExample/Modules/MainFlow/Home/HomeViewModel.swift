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

    var newsArray: [News]
    weak var controller: HomeViewController?

    private var requestState: State {
        willSet {
            if newValue == .twoFinished {
                newsArray = CoreDataManager.getItemsFromContext()
                controller?.endRefresh()
                controller?.reloadTable()
            }
        }
    }

    init(vc: HomeViewController) {
        self.controller = vc
        newsArray = CoreDataManager.getItemsFromContext()
        requestState = .nobodyFinished
    }

    func getNews() {
        requestState = .nobodyFinished
        getJSONNews()
        getXMLNews()
    }

    private func getXMLNews() {
        DispatchQueue.main.async {
            NetworkManager().makeXMLNewsRequest { [weak self] news in
                guard let strongNews = news else { return }
                DispatchQueue.main.async {
                    strongNews.saveInCoreData()
                    self?.requestState.toggle()
                }
            }
        }
    }

    private func getJSONNews() {
        DispatchQueue.main.async {
            NetworkManager().makeJSONNewsRequest { [weak self] news in
                guard let strongNews = news else { return }

                DispatchQueue.main.async {
                    strongNews.saveInCoreData()
                    self?.requestState.toggle()
                }
            }
        }
    }

    private func makeTimers() {
        _ = Timer.scheduledTimer(withTimeInterval: 5*60, repeats: true) { [weak self] _ in
            self?.getNews()
        }
    }

}

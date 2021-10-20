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

    public var newsArray: [News]

    private weak var controller: HomeViewController?

    private var requestState: State {
        willSet {
            if newValue == .twoFinished {
                newsArray = CoreDataManager.getItemsFromContext()
                controller?.endRefresh()
                controller?.stopSmallProgressAnimation()
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

    private func doAfterRequest(news: NewsArray?) {
        guard let strongNews = news else {
            self.controller?.stopSmallProgressAnimation()
            self.controller?.endRefresh()
            self.controller?.makeRequestErrorAlert()
            return
        }

        DispatchQueue.main.async {
            strongNews.saveInCoreData()
            self.requestState.toggle()
        }
    }
}

// MARK: - Requests
private extension HomeViewModel {
    private func getXMLNews() {
        DispatchQueue.main.async {
            NetworkManager().makeGazetaRuXMLNewsRequest { [weak self] news in
                self?.doAfterRequest(news: news)
            }
        }
    }

    private func getJSONNews() {
        DispatchQueue.main.async {
            NetworkManager().makeBBCJSONNewsRequest { [weak self] news in
                self?.doAfterRequest(news: news)
            }
        }
    }
}

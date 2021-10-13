//
//  HomeViewModel.swift
//  BanchExample
//
//  Created by User on 12.10.21.
//

import Foundation

final class HomeViewModel {
    private var XMLNews: XMLResponseNewsModel? {
        didSet {
            print(XMLNews?.debugDescription ?? "Empty")
        }
    }

    private var JSONNews: JSONResponseNewsModel? {
        didSet {
            print( JSONNews?.debugDescription ?? "Empty")
        }
    }

    func getNews() {
        getXMLNews()
        getJSONNews()

//        _ = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true) { [weak self] _ in
//            self?.getXMLNews()
//        }
//
//        _ = Timer.scheduledTimer(withTimeInterval: 13.0, repeats: true) { [weak self] _ in
//            self?.getJSONNews()
//        }
//        _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
//            let rand =  Int.random(in: 0..<(self!.XMLNews!.count - 1) )
//            print(self!.XMLNews![rand].debugDescription)
//        }
    }

    private func getXMLNews() {
        DispatchQueue.main.async {
            NetworkManager().makeXMLNewsRequest { [weak self] news in
                guard let strongNews = news else { return }
                self?.XMLNews = strongNews
            }
        }
    }

    private func getJSONNews() {
        DispatchQueue.main.async {
            NetworkManager().makeJSONNewsRequest { [weak self] news in
                guard let strongNews = news else { return }
             //   print("\n LOG JSON News: \(strongNews.toString())")
                self?.JSONNews = strongNews
            }
        }
    }
}

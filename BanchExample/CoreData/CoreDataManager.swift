//
//  CoreDataManager.swift
//  BanchExample
//
//  Created by User on 15.10.21.
//

import UIKit
import CoreData

final class CoreDataManager {
    private static let context: NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()).persistentContainer.viewContext

    private static var debugDescription: String {
        String(describing: Self.self)
    }

    static func addItem(_ news: NewsModel) {

        let items = getItemsFromContext()

        var isElementInContext = false

        _ = items.map {
            if $0.date == news.getDate() && $0.title == news.getTitle() {
                isElementInContext = true
            }
        }

        guard !isElementInContext else { return }

        let newNews = News(context: context)
        newNews.title = news.getTitle()
        newNews.extract = news.getDescription()
        newNews.date = news.getDate()
        newNews.link = news.getLink()
        newNews.source = news.getSource()

        do {
            context.insert(newNews)
            try context.save()
        } catch (let error) {
            print("\(self.debugDescription): addItem: \(error.localizedDescription)")
        }
    }

    static func getItemsFromContext() -> [News] {
        let request = News.fetchRequest() as NSFetchRequest<News>
        if var items = try? context.fetch(request) {
            items.sort(by: {$0.date! > $1.date!})
            return items
        }
        return []
    }

    static func printNews() {
        let items = CoreDataManager.getItemsFromContext()
        print("\n LOG items: \(items.count)")

        var i = 1
        _ = items.map {
            print("\t\(i)" + $0.toString())
            i+=1
        }
    }

    static func makeAsViewed(news: News) {
        news.wasViewed = true
        do {
            try context.save()
        } catch (let error) {
            print("\(self.debugDescription): makeAsViewed: \(error.localizedDescription)")
        }
    }
}

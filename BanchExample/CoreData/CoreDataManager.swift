//
//  CoreDataManager.swift
//  BanchExample
//
//  Created by User on 15.10.21.
//

import CoreData
import UIKit

enum NewsFilter: CaseIterable {
    case all, noDeleted, intresting, trash, hidden
}

final class CoreDataManager {
    private static let context: NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()).persistentContainer.viewContext

    private static var debugDescription: String {
        String(describing: Self.self)
    }

    static func addItem(_ news: NewsModel) {

        let items = getItemsFromContext(filter: .all)

        var isElementInContext = false

        _ = items.map {
            if $0.date == news.date && $0.title == news.title {
                isElementInContext = true
            }
        }

        guard !isElementInContext else { return }

        let newNews = News(context: context)
        newNews.title = news.title
        newNews.extract = news.description
        newNews.date = news.date
        newNews.link = news.link
        newNews.source = news.source

        do {
            context.insert(newNews)
            try context.save()
        } catch (let error) {
            print("\(self.debugDescription): addItem: \(error.localizedDescription)")
        }
    }

    static func getItemsFromContext(filter: NewsFilter) -> [News] {
        let request = News.fetchRequest() as NSFetchRequest<News>

        let sort = NSSortDescriptor(key: #keyPath(News.date), ascending: false)
        request.sortDescriptors = [sort]

        switch filter {
        case .all:
            break
        case .noDeleted:
            request.predicate = NSPredicate(format: "wasDeleted == NO")
        case .intresting:
            request.predicate = NSPredicate(format: "isInteresting == YES && wasDeleted == NO")
        case .trash:
            request.predicate = NSPredicate(format: "wasDeleted == YES")
        case .hidden:
            request.predicate = NSPredicate(format: "isInteresting == NO")
        }

        let items = try? context.fetch(request)
        
        return items ?? []
    }

    static func makeAsViewed(news: News) {
        news.wasViewed = true
        do {
            try context.save()
        } catch (let error) {
            print("\(self.debugDescription): makeAsViewed: \(error.localizedDescription)")
        }
    }

    static func changeIntrestingStatus(news: News ) {
        news.isInteresting.toggle()
        do {
            try context.save()
        } catch (let error) {
            print("\(self.debugDescription): makeAsUnintresting: \(error.localizedDescription)")
        }
    }

    static func changeDeletedStatus(news: News) {
        news.wasDeleted.toggle()
        do {
            try context.save()
        } catch (let error) {
            print("\(self.debugDescription): makeAsDeleted: \(error.localizedDescription)")
        }
    }

    static func printNews(filter: NewsFilter) {
        let items = CoreDataManager.getItemsFromContext(filter: filter)
        print("\n LOG items: \(items.count)")

        var i = 1
        _ = items.map {
            print("\t\(i)" + $0.toString())
            i+=1
        }
    }

}

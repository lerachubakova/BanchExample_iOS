//
//  News+CoreDataClass.swift
//  
//
//  Created by User on 15.10.21.
//
//

import Foundation
import CoreData

public class News: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var source: String?
    @NSManaged public var extract: String?
    @NSManaged public var link: URL?
    @NSManaged public var wasViewed: Bool
}

extension News {
    func toString() -> String {
        var result = ""
        result += "\n Title: \(self.title ?? "-")"
        result += "\n Date: \(DateFormatter(format: "HH:mm MM-dd-yyyy").string(from: self.date ?? Date()))"
        result += "\n Description: \(self.extract ?? "-")"
        result += "\n Source: \(self.source ?? "-")"
        result += "\n Link: \(self.link?.absoluteString ?? "")"
        result += "\n wasViewed: \(self.wasViewed)"
        return result
    }
}

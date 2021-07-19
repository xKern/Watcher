//
//  SavedSite+CoreDataProperties.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 05/07/21.
//
//

import Foundation
import CoreData


extension SavedSite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedSite> {
        return NSFetchRequest<SavedSite>(entityName: "SavedSite")
    }

    @NSManaged public var contentLength: String?
    @NSManaged public var lastUpdated: String?
    @NSManaged public var siteImageName: String?
    @NSManaged public var siteName: String?
    @NSManaged public var siteUrl: String?

}

extension SavedSite : Identifiable {

}

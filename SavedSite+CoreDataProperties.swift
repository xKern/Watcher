//
//  SavedSite+CoreDataProperties.swift
//  Watcher
//
//  Created by Abhishek J on 22/07/21.
//
//

import Foundation
import CoreData


extension SavedSite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedSite> {
        return NSFetchRequest<SavedSite>(entityName: "SavedSite")
    }

    @NSManaged public var contentLength: String?
    @NSManaged public var currentIndex: Int64
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var siteImageName: String?
    @NSManaged public var siteName: String?
    @NSManaged public var siteUrl: String?
    @NSManaged public var isScreenShotUpdated: Bool

}

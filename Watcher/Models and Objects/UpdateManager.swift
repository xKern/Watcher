//
//  UpdateManager.swift
//  Watcher
//
//  Created by Abhishek J on 19/07/21.
//

import Foundation

class GlobalUpdateManager {
   
    static let shared = GlobalUpdateManager ()
    var websiteUpdateHistory:[String:Date]?
    var previousUpdationStartTime:Date?
    var previousUpdationEndTime:Date?
    private init() {}
    
    func  shouldCheckForUpdates(forSites:[SavedSite]) -> Bool {
    return true
    }

}

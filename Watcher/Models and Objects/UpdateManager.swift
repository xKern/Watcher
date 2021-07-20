//
//  UpdateManager.swift
//  Watcher
//
//  Created by Abhishek J on 19/07/21.
//

import Foundation
enum WebSiteRecordState {
    case new, started, updated, similar, failed
}

class GlobalUpdateManager {
    
    static let shared = GlobalUpdateManager ()
    var updatedWebsiteArray:[SavedSite]?
    var previousUpdationStartTime:Date?
    var previousUpdationEndTime = Date()
    var isUpdateInProgress = false
    private init() {}
    
    func  shouldCheckForUpdates(forSites:[SavedSite]) -> Bool {
        let interval = Date().timeIntervalSince(previousUpdationEndTime)
        if Int(round(interval))>15 && isUpdateInProgress == false{
            return true
        }
        else{
            return false
        }
    }
}

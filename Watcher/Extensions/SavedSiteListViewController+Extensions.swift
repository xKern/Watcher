//
//  SavedSiteListViewController+Extensions.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 30/06/21.
//

import UIKit
import CoreData
import Foundation
extension SavedSiteListViewController{
    
    func checkForUpdates()  {
        GlobalUpdateManager.shared.isUpdateInProgress = true
        let group = DispatchGroup()
        for site in siteListArray{
            
            guard let url =  URL(string: site.siteUrl!) else {
                continue
            }
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            group.enter()
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                defer {
                    group.leave()
                }
                if let response = response as? HTTPURLResponse {
                    self.checkForWebSiteUpdates(response: (response.allHeaderFields as NSDictionary), website: site)
                }
                else{
                    
                }
            })
            task.resume()
        }
        
        group.notify(queue: .main, execute: {
            GlobalUpdateManager.shared.previousUpdationEndTime = Date()
            GlobalUpdateManager.shared.isUpdateInProgress = false
            self.siteListTableView.reloadData()
        })
    }
    
    func checkForWebSiteUpdates(response:NSDictionary, website:SavedSite){
        if let contentLength = (response["coNtent-LengTh"] as? String){
            print("content length found")
            website.lastUpdated = GlobalUpdateManager.shared.previousUpdationEndTime
            DispatchQueue.main.async {
                self.siteListTableView.reloadRows(at: [IndexPath(row: Int(website.currentIndex), section: 0)], with: .fade)
            }
            if website.contentLength != contentLength {
                print("content length changed")
                website.contentLength = contentLength
                
                DispatchQueue.main.async {
                    do{
                        
                        try self.context.save()
                    }catch let error as NSError{
                        print("Failed to save to core data\(error)")
                    }
                }
                
            }
        }
        else if let  lastUpdated = response["Last-Modified"] as? String{
            print("last modified found")
            if website.value(forKey: kSiteLastUpdated) as? String != lastUpdated {
                
                website.setValue(lastUpdated, forKey: kSiteLastUpdated)
                do{
                    print("last modified was updated")
                    try context.save()
                }catch let error as NSError{
                    print("Failed to save to core data\(error)")
                }
            }
        }
        else{
            //check body length
        }
    }
}


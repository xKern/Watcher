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
    
    func checkForUpdates(sites:[SavedSite])  {
        let group = DispatchGroup()
        for site in sites {
            guard let url =  URL(string: site.siteUrl!) else {
                continue
            }
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            group.enter()
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                if let response = response as? HTTPURLResponse {
                    self.checkForWebSiteUpdates(response: (response.allHeaderFields as NSDictionary), website:site)
                }
            })
            task.resume()
        }
        group.notify(queue: .main, execute: {
            self.siteListTableView.reloadData()
        })
    }
    
    func checkForWebSiteUpdates(response:NSDictionary, website:NSManagedObject){
        if let contentLength = (response["coNtent-LengTh"] as? String){
            print("content length found")
            if website.value(forKey: kContentLength) as? String != contentLength {
                print("content length changed")
                website.setValue(contentLength, forKey: kContentLength)
                
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


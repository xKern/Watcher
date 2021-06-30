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
    func checkForUpdates(){
        for i in 0 ..< siteListArray.count {
            let site = siteListArray[i] as! NSManagedObject
            let url = URL(string: site.value(forKey: kSiteAddress) as! String )
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "HEAD"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse {
                    self.checkForWebSiteUpdates(response: (response.allHeaderFields as NSDictionary), website:site)
                }
            }
            task.resume()
        }
    }
    
    func checkForWebSiteUpdates(response:NSDictionary, website:NSManagedObject){
        if let contentLength = (response["coNtent-LengTh"] as? String){
            print("content length found")
            if website.value(forKey: kContentLength) as? String != contentLength {
                print("content length changed")
                website.setValue(contentLength, forKey: kContentLength)
                do{
                    try context.save()
                }catch let error as NSError{
                    print("Failed to save to core data\(error)")
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


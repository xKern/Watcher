//
//  SavedSiteListViewController+Extensions.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 30/06/21.
//

import UIKit
import CoreData
import Foundation
import WebKit
import WebKit

extension SavedSiteListViewController:WKNavigationDelegate{
    
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
            website.isScreenShotUpdated = false
            DispatchQueue.main.async {
                self.siteListTableView.reloadRows(at: [IndexPath(row: Int(website.currentIndex), section: 0)], with: .fade)
            }
            if website.contentLength != contentLength {
                print("content length changed")
                website.contentLength = contentLength
                
                saveContext()
                
            }
        }
        else if let  lastUpdated = response["Last-Modified"] {
            print("last modified found")
            if website.lastUpdated != lastUpdated as? Date {
                print("last modified updated")
                website.lastUpdated = lastUpdated as? Date
                saveContext()
                website.isScreenShotUpdated = false
                
                let cellToRefresh = getCellWithId(id: website.uniqueId!) 
                let indexPath = siteListTableView.indexPath(for: cellToRefresh!)
                if isRowVisible(indexPath: indexPath!) == true{
                    DispatchQueue.main.async {
                        self.siteListTableView.reloadRows(at: [IndexPath(row: Int(website.currentIndex), section: 0)], with: .fade)
                    }
               }
            }
        }
        else{
            //check body length
        }
    }
    func createWebView(site:SavedSite){
        let webView = WKWebView()
        webView.navigationDelegate = self
        let url = URL(string: site.siteUrl!)
        webView.accessibilityIdentifier = site.uniqueId
        webView.load(URLRequest(url: url!))
        webView.frame = self.view.bounds
        self.view.insertSubview(webView, belowSubview: self.siteListTableView)
    }
    func isRowVisible(indexPath:IndexPath) -> Bool {
        if siteListTableView.indexPathsForVisibleRows!.contains(indexPath) {
            return true
        }
        return false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.saveScreenShot( webView: webView) { success in
            if success{
                webView.removeFromSuperview()
            }
        }
    }
    
    func saveScreenShot(webView:WKWebView, finished: @escaping (_ success:Bool) -> Void){
        if let index = siteListArray.firstIndex(where: { $0.uniqueId!  == webView.accessibilityIdentifier }) {
            let site = siteListArray[index]
            
            let configuration = WKSnapshotConfiguration()
            configuration.rect = CGRect(origin: .zero, size: webView.scrollView.contentSize)
            webView.takeSnapshot(with:nil) { (image, error) in
                if let image = image{
                    if self.saveImage(image: image, filename: site.siteImageName!){
                        print("saved image to file")
                    }
                    else{
                        print("couldn't save image to file")
                        
                    }
                }
                site.isScreenShotUpdated = true
                finished(true)
            }
            
        } else {
            print("Object not found.....)")
            finished(true)
        }
    }
    
    func loadSiteAndUpdateScreenShot(for record: SavedSite, at indexPath: IndexPath) {
        createWebView(site: record)
    }
    func getCellWithId(id: String) -> SiteListCell? {
      
        for cell in siteListTableView.visibleCells {
            let siteCell = cell as! SiteListCell
            if siteCell.cellID == id{
                return siteCell
            }
            else{
                return nil
            }
        }
        return  SiteListCell()
    }
}


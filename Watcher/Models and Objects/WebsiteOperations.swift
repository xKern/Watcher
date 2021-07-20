//
//  WebsiteOperations.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 05/07/21.
//

import UIKit

class WebsiteRecord {
    let name: String
    let url: URL
    var lastUpdated:Date
    var indexPath:IndexPath
    
    var state = WebSiteRecordState.new
    var image: String
    init(name:String, url:URL, image:String,lastUpdated:Date, indexPath:IndexPath) {
        self.name = name
        self.url = url
        self.image = image
        self.lastUpdated = lastUpdated
        self.indexPath = indexPath
    }
}
class PendingOperations {
    lazy var updatesInProgress: [IndexPath: Operation] = [:]
    lazy var updateQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Update queue"
         queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var screenShotInProgress: [IndexPath: Operation] = [:]
    lazy var screenShotQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "ScreenShotQueue"
        //  queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
class UpdateManager: Operation {
    let webSiteRecord: WebsiteRecord
    
    init(_ webSiteRecord: WebsiteRecord) {
        self.webSiteRecord = webSiteRecord
    }
    override func main() {
        if isCancelled {
            return
        }
        var request = URLRequest(url: webSiteRecord.url)
         request.httpMethod = "HEAD"
         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
             if let error = error {
                 print("Error took place \(error)")
                self.webSiteRecord.state = .failed
                 return
             }
             if let response = response as? HTTPURLResponse {
                self.webSiteRecord.state = .updated
//                 self.checkForWebSiteUpdates(response: (response.allHeaderFields as NSDictionary), website:site)
             }
         }
         task.resume()
        
        if isCancelled {
            return
        }
    }
}



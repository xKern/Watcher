//
//  CoreDataHelper.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 22/06/21.
//

import Foundation
import UIKit
import CoreData

let kSiteName = "siteName"
let kSiteAddress = "siteUrl"
let kSiteLastUpdated = "lastUpdated"
let kSiteImage = "siteImageName"

extension AddSiteViewController{
    func addToCoreData(siteName:String, siteAddress:String, lastUpdated:String, image:UIImage){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavedSite", in: context)
        let newSite = NSManagedObject(entity: entity!, insertInto: context)
        newSite.setValue(siteName, forKey: kSiteName)
        newSite.setValue(siteAddress, forKey: kSiteAddress)
        newSite.setValue(lastUpdated, forKey: kSiteLastUpdated)
        newSite.setValue(kSiteImage, forKey: kSiteImage)
        do{
            try context.save()
        }catch{
            print("Failed to write to core data")
        }
    }
}

extension SavedSiteListViewController{
    
}

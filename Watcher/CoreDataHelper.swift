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
    func addToCoreData(siteName:String, siteAddress:String, lastUpdated:String, image:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavedSite", in: context)
       
        //Check for duplicates
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSite")
        fetchRequest.predicate = NSPredicate(format: "siteName == %@",siteName)
        fetchRequest.predicate = NSPredicate(format: "siteUrl == %@",siteAddress)
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                print("item exists")
            }
            else{
                print("item count\(count)")
                let newSite = NSManagedObject(entity: entity!, insertInto: context)
                newSite.setValue(siteName, forKey: kSiteName)
                newSite.setValue(siteAddress, forKey: kSiteAddress)
                newSite.setValue(lastUpdated, forKey: kSiteLastUpdated)
                newSite.setValue(kSiteImage, forKey: kSiteImage)
                do{
                    try context.save()
                }catch let error as NSError{
                    print("Failed to write to core data\(error)")
                }
            }
        } catch let error as NSError {
            print("can't fetch : \(error)")
        }
    }
}

extension SavedSiteListViewController {
    func fetchSavedSites() -> [Any]{
        var sites = [Any]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSite")
        do{
             sites = try context.fetch(fetchRequest)
        }catch let error as NSError{
            print("\(error),\(error.userInfo)")
        }
        return sites
    }
}

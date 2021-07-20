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
let kContentLength = "contentLength"

extension AddSiteViewController{
    func addToCoreData(siteName:String, siteAddress:String, lastUpdated:Date, image:String){
        let entity = NSEntityDescription.entity(forEntityName: "SavedSite", in: context)
        
        //Check for duplicates
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSite")
        //   fetchRequest.predicate = NSPredicate(format: "siteName == %@",siteName)
        fetchRequest.predicate = NSPredicate(format: "siteUrl == %@",siteAddress)
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                showAlertwith(title: "Oops!", message: "Cannot add website.URL already added.")
            }
            else{
                let newSite = NSManagedObject(entity: entity!, insertInto: context)
                newSite.setValue(siteName, forKey: kSiteName)
                newSite.setValue(siteAddress, forKey: kSiteAddress)
                newSite.setValue(lastUpdated, forKey: kSiteLastUpdated)
                newSite.setValue(image, forKey: kSiteImage)
                do{
                    try context.save()
                    showAlertwith(title: "Voila!", message: "Website added to watch list.")
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
    func fetchSavedSites() -> [SavedSite]{
        var sites = [SavedSite]()
        do{
            sites = try context.fetch(SavedSite.fetchRequest())
        }catch let error as NSError{
            print("\(error),\(error.userInfo)")
        }
        return sites.reversed()
    }
}

extension UIViewController{
        var context:NSManagedObjectContext{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            return context
        }
}

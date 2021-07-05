//
//  SavedSiteListViewController.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 22/06/21.
//

import UIKit
import CoreData
class SavedSiteListViewController: UIViewController {
    
    @IBOutlet weak var siteListTableView: UITableView!
    var siteListArray=[Any]()
    var placeholderLabel = UILabel()
    var webSiteRecordsArray: [WebsiteRecord] = []
    let pendingOperations = PendingOperations()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        siteListTableView.delegate = self
        siteListTableView.dataSource = self
        configurePlaceHolderText()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: context)
        
    }
    @objc func managedObjectContextObjectsDidChange(_ notification: Notification){
        siteListArray = fetchSavedSites()
        createWebSiteRecordsArray()
        DispatchQueue.main.async {
            self.siteListTableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reeloadData()
    }
    func reeloadData(){
        siteListArray = fetchSavedSites()
        createWebSiteRecordsArray()
        placeholderLabel.isHidden = !siteListArray.isEmpty
        checkForUpdates()
    }
    
    func configurePlaceHolderText(){
        siteListTableView.addSubview(placeholderLabel)
        placeholderLabel.textColor = UIColor.white
        placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        placeholderLabel.backgroundColor = UIColor.black
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textAlignment = .center
        placeholderLabel.text = "No websites on watch list.\n Please tap on the 'Add' button on top to start."
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.leadingAnchor.constraint(equalTo: siteListTableView.leadingAnchor, constant: 10).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: siteListTableView.trailingAnchor, constant: 10).isActive = true
        placeholderLabel.centerXAnchor.constraint(equalTo: siteListTableView.centerXAnchor).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: siteListTableView.centerYAnchor).isActive = true
    }
    func configureNavBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        let testUIBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.navigateToAddSitePage))
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
    }
    @objc func navigateToAddSitePage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddSiteVC") as! AddSiteViewController
        //       navigationController?.pushViewController(nextViewController, animated: true)
        let addNavigationController = UINavigationController(rootViewController: nextViewController)
        present(addNavigationController, animated: true, completion: nil)
    }
}
extension SavedSiteListViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let site = siteListArray[indexPath.row] as! NSManagedObject
        let webSiteRecord = webSiteRecordsArray [indexPath.row]
        let siteCell = tableView.dequeueReusableCell(withIdentifier: "SiteCell")  as! SiteListCell
        siteCell.siteAddressLabel.text = site.value(forKey: kSiteAddress) as? String
        siteCell.siteNameLabel.text = site.value(forKey: kSiteName) as? String
        siteCell.siteChangesLabel.text = site.value(forKey: kSiteLastUpdated) as? String
        siteCell.siteThumbImageView.image = getSavedImage(named: (site.value(forKey: kSiteImage) as? String)!)
        switch webSiteRecord.state {
        case .failed, .similar, .updated:
            siteCell.actIivityIndicator.stopAnimating()
        case  .started:
            siteCell.actIivityIndicator.startAnimating()
        case .new:
            siteCell.actIivityIndicator.startAnimating()
            startOperations(for: webSiteRecord, at: indexPath)
            
        }
        return siteCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension SavedSiteListViewController{
    func createWebSiteRecordsArray(){
        for objects in siteListArray {
            let site = objects as! NSManagedObject
            let webSiteRecord = WebsiteRecord(name: site.value(forKey: kSiteName) as! String, url: URL(string: site.value(forKey: kSiteAddress) as! String)!, image: site.value(forKey: kSiteImage) as! String)
            webSiteRecordsArray.append(webSiteRecord)
        }
    }
    
    func startOperations(for webSiteRecord: WebsiteRecord, at indexPath: IndexPath) {
        switch (webSiteRecord.state) {
        case .new:
            startDownload(for: webSiteRecord, at: indexPath)
        case .updated:
            takeScreenShot()
        default:
            NSLog("do nothing..\(webSiteRecord.state)")
        }
    }
    
    func startDownload(for record: WebsiteRecord, at indexPath: IndexPath) {
        guard pendingOperations.updatesInProgress[indexPath] == nil else {
            return
        }
        let manager = UpdateManager(record)
        
        manager.completionBlock = {
            if manager.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.updatesInProgress.removeValue(forKey: indexPath)
                self.siteListTableView.reloadRows(at: [indexPath], with: .fade)
              
            }
        }
        pendingOperations.updatesInProgress[indexPath] = manager
        pendingOperations.updateQueue.addOperation(manager)
    }
    
    func takeScreenShot(){
        
    }
}

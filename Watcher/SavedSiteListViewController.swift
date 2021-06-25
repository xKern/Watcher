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
    var  placeHolderView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        siteListTableView.delegate = self
        siteListTableView.dataSource = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          getData()
    reeloadData()
    }
    func reeloadData(){
        siteListArray = fetchSavedSites()
        if(siteListArray.isEmpty){
            showPlaceHolderText()
        }
        else{
            placeHolderView?.removeFromSuperview()
            siteListTableView.reloadData()
        }
    }
    
    func showPlaceHolderText(){
        placeHolderView = UIView(frame: siteListTableView.bounds)
        placeHolderView?.backgroundColor = UIColor.black
        siteListTableView.addSubview(placeHolderView!)
        
        let placeholderLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: siteListTableView.frame.size.width-120, height: 150))
        placeholderLabel.center = CGPoint(x: (placeHolderView?.center.x)!, y: (placeHolderView?.center.y)!-60)
        placeHolderView?.addSubview(placeholderLabel)
        placeholderLabel.textColor = UIColor.white
        placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        placeholderLabel.backgroundColor = UIColor.black
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textAlignment = .center
        placeholderLabel.text = "No websites on watch list.\n Please tap on the 'Add' button on top to start."
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
        let siteCell = tableView.dequeueReusableCell(withIdentifier: "SiteCell")  as! SiteListCell
        siteCell.siteAddressLabel.text = site.value(forKey: kSiteAddress) as? String
        siteCell.siteNameLabel.text = site.value(forKey: kSiteName) as? String
        siteCell.siteChangesLabel.text = site.value(forKey: kSiteLastUpdated) as? String
        siteCell.siteThumbImageView.image = getSavedImage(named: (site.value(forKey: kSiteImage) as? String)!)
        
        return siteCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func getData(){
        let url = URL(string: "https://www.apple.com/in")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("dfgffdhdhddd\(response)----end")
            print("dfgffdhdhddd\(data)-----end")
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            if let data = data {
//               print("dfgjhkjdhf : : : \( String(data: data, encoding: .utf8))")
                //  self.parse(json: data)
            }
            
        }
        task.resume()
    }
   
}

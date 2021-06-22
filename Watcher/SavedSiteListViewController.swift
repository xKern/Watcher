//
//  SavedSiteListViewController.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 22/06/21.
//

import UIKit

class SavedSiteListViewController: UIViewController {
    
    @IBOutlet weak var siteListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        siteListTableView.delegate = self
        siteListTableView.dataSource = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    func configureNavBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let testUIBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.navigateToAddSitePage))
                self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
    }
    @objc func navigateToAddSitePage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddSiteVC") as! AddSiteViewController
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
extension SavedSiteListViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let siteCell = tableView.dequeueReusableCell(withIdentifier: "SiteCell")  as! SiteListCell
        return siteCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

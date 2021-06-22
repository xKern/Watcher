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
        siteListTableView.delegate = self
        siteListTableView.dataSource = self
        configureNavButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureNavButtons()
    }
    func configureNavButtons(){
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.tintColor = UIColor.green
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:"Add", style: .plain, target: self, action: #selector(navigateToAddSitePage))
    }
    @objc func navigateToAddSitePage(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddSiteVC") as! AddSiteViewController
        self.present(nextViewController, animated:true, completion:nil)
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

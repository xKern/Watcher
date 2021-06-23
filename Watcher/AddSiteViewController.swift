//
//  AddSiteViewController.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 22/06/21.
//

import UIKit
import WebKit
class AddSiteViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchFieldBg: UIView!
    @IBOutlet weak var addWebsiteButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        title = "Add a URL"
        navigationItem.setLeftBarButton(cancelButton, animated: false)
        super.viewDidLoad()
        searchFieldBg.layer.cornerRadius = 8.0
        let url = URL(string: "https://www.apple.com/in")!
        loadWebView(url: url)
    }

    func loadWebView(url:URL){
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    @IBAction func saveSiteButtonPressed(_ sender: Any) {
    }
    
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
}

extension AddSiteViewController:WKNavigationDelegate{
    
}

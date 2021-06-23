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
    @IBOutlet weak var customClearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarItems()
        searchTextField.keyboardType = .URL
        searchFieldBg.layer.cornerRadius = 16
        let url = URL(string: "https://www.apple.com/in")!
        loadWebView(url: url)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(onReturn), for: .editingDidEndOnExit)
        if searchTextField.isEditing {
            customClearButton.isHidden = false
        }
        else{
            customClearButton.isHidden = true
        }
    }
    func configureNavBarItems(){
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        title = "Add a URL"
        navigationItem.setLeftBarButton(cancelButton, animated: false)
    }
    @IBAction func onReturn(){
        searchTextField.resignFirstResponder()
    //Add validation
        loadWebView(url:URL(string:searchTextField.text!)!)
    }
    func loadWebView(url:URL){
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveSiteButtonPressed(_ sender: Any) {
        addToCoreData(siteName: "Apple", siteAddress: "https://www.apple.com/in", lastUpdated: "10-10-10", image: "tt.png")
    }
    @IBAction func didTapClearButton(_ sender: Any) {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }
}
extension AddSiteViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        customClearButton.isHidden = false
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        customClearButton.isHidden = true
    }
}
extension AddSiteViewController:WKNavigationDelegate{
    
}

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
        searchTextField.text = "https://github.com"
        let url = URL(string: "https://github.com")!
        loadWebView(url: url)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(onReturn), for: .editingDidEndOnExit)
        if searchTextField.isEditing {
            customClearButton.isHidden = false
        }
        else{
            customClearButton.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let presentingVC = self.presentingViewController as!  UINavigationController
        let vc = presentingVC.viewControllers.first as! SavedSiteListViewController
        vc.reeloadData()
    }
    func configureNavBarItems(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        title = "Add a URL"
        navigationItem.setLeftBarButton(cancelButton, animated: false)
    }
    
    func loadWebView(url:URL){
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveSiteButtonPressed(_ sender: Any) {
        //Add validation
        let configuration = WKSnapshotConfiguration()
        configuration.rect = CGRect(origin: .zero, size: webView.scrollView.contentSize)
        webView.takeSnapshot(with:nil) { (image, error) in
            if let image = image{
                let imageFileName = Date().getString()
                if self.saveImage(image: image, filename: imageFileName){
                    print("saved image to file")
                    self.addToCoreData(siteName: "No name", siteAddress: self.searchTextField.text!, lastUpdated: "10 changes since first added.", image: imageFileName)
                }
                else{
                    print("couldn't save image to file")
                }
            }
        }
    }
    @IBAction func didTapClearButton(_ sender: Any) {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }
}

//MARK: TextField Delegates & Actions
extension AddSiteViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        customClearButton.isHidden = false
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        customClearButton.isHidden = true
    }
    @IBAction func onReturn(){
        searchTextField.resignFirstResponder()
        //Add validation
        loadWebView(url:URL(string:searchTextField.text!)!)
    }
}

// MARK: Webview Delegates
extension AddSiteViewController:WKNavigationDelegate, WKUIDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("*****didcommit called****")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("*****did finish called****")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("*****did fail called****/n\(error.localizedDescription)")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("*****did fail prov. navigation called****/n\(error.localizedDescription)")
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("*****did terminate called****")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        let response = navigationResponse.response as? HTTPURLResponse
        decisionHandler(.allow)
        // print("***LastModified****\(response?.allHeaderFields["Last-Modified"])")
        print("***LastModified****\(response?.allHeaderFields)")
    }
}
//https://xkern.net

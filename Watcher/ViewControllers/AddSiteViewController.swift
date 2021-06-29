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
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var customClearButton: UIButton!
    private var canAddURL = false{
        didSet{
            addButtonView.isHidden = !canAddURL
        }
    }
    private var addButtonView = {
        () -> UIVisualEffectView in
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        view.isHidden = true
        return view
    }()
    
  //  var isReadyToReload = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarItems()
        configureAddButtonView()
        searchTextField.keyboardType = .URL
        searchTextField.autocorrectionType = .no
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
    
    func configureAddButtonView()
    {
        let bottomAdditonalSpace = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        view.addSubview(addButtonView)
        let button = RoundedButton()
        button.insets = UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)
        addButtonView.contentView.addSubview(button)
        button.setTitle("Add Website", for: .normal)
        button.backgroundColor = view.tintColor
        let buttonHeight = button.intrinsicContentSize.height
                
        addButtonView.translatesAutoresizingMaskIntoConstraints = false
        addButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        addButtonView.heightAnchor.constraint(equalToConstant: (buttonHeight * 2) + bottomAdditonalSpace).isActive =  true
        

        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: addButtonView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: addButtonView.centerYAnchor, constant: 0).isActive = true
    }
    
    func loadWebView(url:URL){
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveSiteButtonPressed(_ sender: Any) {
//        showAlertWithTextField(title: "abc", desctription: "def")
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
//        if isReadyToReload{
//            webView.reload()
//        }
//        else{
            searchTextField.text = ""
            searchTextField.resignFirstResponder()
  //      }
    }
}

//MARK: TextField Delegates & Actions
extension AddSiteViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        customClearButton.isHidden = false
        canAddURL = false
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        customClearButton.isHidden = true
    }
    @IBAction func onReturn(){
        searchTextField.resignFirstResponder()
        // TO DO : Add validation
        loadWebView(url:URL(string:searchTextField.text!)!)
    }
}

// MARK: Webview Delegates
extension AddSiteViewController:WKNavigationDelegate, WKUIDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        print("*****didcommit called****")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        canAddURL = true
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
     //   print("***LastModified****\(response?.allHeaderFields)")
    }
}
//MARK: Ignore
/*
extension AddSiteViewController{
    enum WebViewState {
        case notLoaded
        case loading
        case loadFailed
        case loadFailedDueToTypo
        case successFullyLoaded
    }
 */
    // MARK: Ignore
   /*
    func manageWebViewStateChange(webViewState:WebViewState){
        switch webViewState {
        case .notLoaded:
            self.addWebsiteButton.isHidden = true
            self.isReadyToReload = false
            customClearButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        case .loading:
            self.addWebsiteButton.isHidden = true
            self.isReadyToReload = false
        case .loadFailed:
            self.addWebsiteButton.isHidden = true
            self.isReadyToReload = false
        case .loadFailedDueToTypo:
            self.addWebsiteButton.isHidden = true
            self.isReadyToReload = false
        case .successFullyLoaded:
            self.addWebsiteButton.isHidden = true
            self.isReadyToReload = false
        }
    }
 */
//}
//https://xkern.net
//https://www.apple.com/in

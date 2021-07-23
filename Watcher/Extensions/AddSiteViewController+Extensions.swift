//
//  AddSiteViewController+Extensions.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 25/06/21.
//

import Foundation
import UIKit
import WebKit
extension AddSiteViewController: WKNavigationDelegate, WKUIDelegate,UITextFieldDelegate, UIScrollViewDelegate{
    func saveSite(siteName:String){
        let configuration = WKSnapshotConfiguration()
        configuration.rect = CGRect(origin: .zero, size: webView.scrollView.contentSize)
        webView.takeSnapshot(with:nil) { (image, error) in
            if let image = image{
//                let imageFileName = UUID().uuidString
                let imageFileName = "IMG_\(Int(Date().timeIntervalSince1970))"
                if self.saveImage(image: image, filename: imageFileName){
                    print("saved image to file")
                    self.addToCoreData(siteName: siteName, siteAddress: self.searchTextField.text!, lastUpdated: Date(), image: imageFileName,uniqueID: UUID().uuidString)
                }
                else{
                    print("couldn't save image to file")
                }
            }
        }
        
    }
    // MARK: Webview Delegates
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("*****didcommit called****")
            canAddURL = true
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
         //   let response = navigationResponse.response as? HTTPURLResponse
            decisionHandler(.allow)
            // print("***LastModified****\(response?.allHeaderFields["Last-Modified"])")
         //   print("***LastModified****\(response?.allHeaderFields)")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

      if(velocity.y>0) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.searchBgHeight.constant = 0.0
            
        }, completion: nil)

      } else {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.searchBgHeight.constant = 35.0
          }, completion: nil)
        }
     }
    
    //MARK: TextField Delegates & Actions
        func textFieldDidBeginEditing(_ textField: UITextField) {
            canAddURL = false
            customClearButton.isHidden = false
            
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


//
//  AddSiteViewController+Extensions.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 25/06/21.
//

import Foundation
import UIKit
import WebKit
extension AddSiteViewController{
    func showAlertWithTextField(title:String, desctription:String){
        let ac = UIAlertController(title: "Save to Watch List?", message: "Please add a title to save this website.", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Add to watch list.", style: .default) { [unowned ac] _ in
            let titlee = ac.textFields![0]
            
            self.saveSite(siteName:titlee.text!)
        }
        let cancelAction =  UIAlertAction(title: "Not Now", style: .cancel) {  _ in}
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        ac.addTextField(configurationHandler: {(txtFld:UITextField!) in
            txtFld.addTarget(self, action: #selector(self.textChanged(sender:)), for: .editingChanged)
        })
        (ac.actions[0] as UIAlertAction).isEnabled=false
        present(ac, animated: true)
    }
    @objc func textChanged(sender : UITextField){
        var responder:UIResponder = sender
        while !(responder is UIAlertController) {
            responder = responder.next!
        }
        let alert = responder as! UIAlertController
        let r = sender.text?.notEmptyAfterTrimmingWhiteSpaces()
        alert.actions[0].isEnabled = r!
    } 
    func saveSite(siteName:String){
        let configuration = WKSnapshotConfiguration()
        configuration.rect = CGRect(origin: .zero, size: webView.scrollView.contentSize)
        webView.takeSnapshot(with:nil) { (image, error) in
            if let image = image{
//                let imageFileName = UUID().uuidString
                let imageFileName = "IMG_\(Int(Date().timeIntervalSince1970))"
                if self.saveImage(image: image, filename: imageFileName){
                    print("saved image to file")
                    self.addToCoreData(siteName: siteName, siteAddress: self.searchTextField.text!, lastUpdated: "10 changes since first added.", image: imageFileName)
                }
                else{
                    print("couldn't save image to file")
                }
            }
        }
        
    }
}


//
//  UIViewController+Alert.swift
//  Watcher
//
//  Created by ARX8x on 29/06/21.
//

import UIKit
var okButtonTitle = "Ok"
var cancelButtonTitle = "Cancel"

extension UIViewController{
    enum AlertAction{case ok, cancel}
    
    func showAlertwith(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertwith(title:String, message:String, completionHandler:@escaping (_ finished:AlertAction) -> Void ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler(AlertAction.ok)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {action in completionHandler(AlertAction.cancel)}))
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertWithTextField(title:String, message:String, completionHandler:@escaping (_ finished:AlertAction,_ title:String) -> Void){
        let ac = UIAlertController(title: title, message:message , preferredStyle: .alert)
        let submitAction = UIAlertAction(title: okButtonTitle, style: .default) { [unowned ac] _ in
            let titlee = ac.textFields![0]
            completionHandler(AlertAction.ok, titlee.text!)
        //    self.saveSite(siteName:titlee.text!)
        }
        let cancelAction =  UIAlertAction(title: cancelButtonTitle, style: .cancel) {  _ in
            completionHandler(AlertAction.cancel, "")
        }
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
}

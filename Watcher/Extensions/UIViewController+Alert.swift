//
//  UIViewController+Alert.swift
//  Watcher
//
//  Created by ARX8x on 29/06/21.
//

import UIKit


extension UIViewController{
    func showAlertwith(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

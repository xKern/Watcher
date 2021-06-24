//
//  ViewControllerExtensions.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 23/06/21.
//
import UIKit
import Foundation
extension UIViewController{
    func showAlertwith(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertWithTextField(title:String, desctription:String){
    }
    func showLoadingIndicator(){
        
    }
    func hideLoadingIndicator(){
        
    }
    func saveImage(image: UIImage, filename:String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        print("sfgasgfafg\(directory.appendingPathComponent("\(filename).png"))")
        do {
            try data.write(to: directory.appendingPathComponent("\(filename).png")!)
            
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            print("sfgasgfafg\(URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("\(named).png").path)")
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}

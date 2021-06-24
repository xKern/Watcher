//
//  DateExtention.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 24/06/21.
//

import Foundation

extension Date{
    func getString()->String{
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: self)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let dateString = "\(year!+month!+day!+hour!+minute!+second!)"
        return dateString
    }
}

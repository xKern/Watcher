//
//  StringExtensions.swift
//  Watcher
//
//  Created by Abhishek Jayakumar on 25/06/21.
//

import Foundation
extension String{
    func notEmptyAfterTrimmingWhiteSpaces()->Bool{
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count>0 ? true : false
    }
}

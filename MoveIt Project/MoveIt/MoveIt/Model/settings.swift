//
//  settings.swift
//  MoveIt
//
//  Created by Zi Xiong on 11/28/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import Foundation

class Settings {
    static var userName = "James"
    static var dailySteps = 3000
    static var formData: [String: String] = [:]
    
    static func parseFoods(_ foods: String) -> String {
        var res = foods.components(separatedBy: ",").filter{
            $0.count != 0
        }
        
        for (id, word) in res.enumerated() {
            res[id] = word.trimmingCharacters(in: CharacterSet(charactersIn: " ")).replacingOccurrences(of: "\\s+", with: " ", options: NSString.CompareOptions.regularExpression, range: nil)
        }
        
        return res.filter {
            $0.count != 0
        }.joined(separator: ", ")
    }
}

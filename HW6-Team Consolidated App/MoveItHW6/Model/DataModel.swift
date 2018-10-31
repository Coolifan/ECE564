//
//  DataModel.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/3/18.
//  Modified by Haohong Zhao, Yifan Li and Zi Xiong on 10/28/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit


enum Gender: String, Codable {
    case Male = "Male"
    case Female = "Female"
}

enum DukeRole : String, Codable {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}

protocol BlueDevil {
    var hobbies : [String] { get }
    var role : DukeRole { get }
}


class DukePerson: BlueDevil, CustomStringConvertible, Codable {
    var hobbies: [String] = []
    var role: DukeRole = .Student
    var degree: String = ""
    var bestProgrammingLanguage: [String] = []
    var fullName: String {
      return "\(firstName) \(lastName)"
    }
    var team: String = ""
    var pic: String = ""
    
    // originally from Person class
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
    
    init() {
        
    }

    init(firstName: String, lastName: String, whereFrom: String, gender: Gender, degree: String, bestProgrammingLanguage: [String], hobbies: [String], role: DukeRole, team: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.whereFrom = whereFrom
        self.gender = gender
        self.degree = degree
        self.bestProgrammingLanguage = bestProgrammingLanguage
        self.hobbies = hobbies
        self.role = role
        self.team = team
    }
    
    
    // Add CustomStringConvertible conformance to DukePerson class by defining the description property
    var description: String {
        let (pronoun, courseRole, pronoun2) = getGenderAndRole(self.gender, self.role)
        
        var langStr: String = ""
        let numOfLangs: Int = self.bestProgrammingLanguage.count > 3 ? 3 : self.bestProgrammingLanguage.count
        for i in 0..<numOfLangs {
            if i != numOfLangs-1 {
                langStr += "\(self.bestProgrammingLanguage[i]), "
            } else {
                langStr += (i != 0) ? "and \(self.bestProgrammingLanguage[i])" : "\(self.bestProgrammingLanguage[i])"
            }
        }
        
        var hobbyStr: String = ""
        let numOfHobbies: Int = self.hobbies.count > 3 ? 3 : self.hobbies.count
        for i in 0..<numOfHobbies {
            if i != numOfHobbies-1 {
                hobbyStr += "\(self.hobbies[i]), "
            } else {
                hobbyStr += (i != 0) ? "and \(self.hobbies[i])" : "\(self.hobbies[i])"
            }
        }
        
        var personalInfo: String = ""
        if self.degree == "NA" {
            personalInfo = "\(self.fullName) is from \(self.whereFrom) and is a \(courseRole) of ECE 564. \(pronoun) is proficient in \(langStr). When not in class, \(self.firstName) enjoys \(hobbyStr)."
        } else {
            personalInfo = "\(self.fullName) is from \(self.whereFrom) and is a \(courseRole) of ECE 564 working on \(pronoun2) \(degree) degree. \(pronoun) is proficient in \(langStr). When not in class, \(self.firstName) enjoys \(hobbyStr)."
        }
        
        return personalInfo
    }
    
}


// An additional function used to clarify the gender and course role of a specific person
func getGenderAndRole(_ gender: Gender, _ role: DukeRole) -> (String, String, String) {
    var courseRole: String
    switch role {
    case .Professor:
        courseRole = "professor"
    case .Student:
        courseRole = "student"
    case .TA:
        courseRole = "TA"
    }
    
    var pronoun, pronoun2: String
    switch gender {
    case .Female:
        pronoun = "She"
        pronoun2 = "her"
    case .Male:
        pronoun = "He"
        pronoun2 = "his"
    }
    
    return (pronoun, courseRole, pronoun2)
}

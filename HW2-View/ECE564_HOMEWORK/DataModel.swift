////
////  DataModel.swift
////  ECE564_HOMEWORK
////
////  Created by Ric Telford on 7/16/17.
////  Copyright © 2018 ece564. All rights reserved.
////
//
import UIKit


enum Gender {
    case Male
    case Female
}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}

protocol BlueDevil {
    var hobbies : [String] { get }
    var role : DukeRole { get }
}
//: ### START OF HOMEWORK
//: Do not change anything above.
//: Put your code here:

class DukePerson: Person, BlueDevil, CustomStringConvertible {
    // Class properties (with a few additional properties w/ different types)
    var hobbies: [String] = []
    var role: DukeRole = .Student
    var degree: String = ""
    var bestProgrammingLanguage: [String] = []
    var fullName: String = ""

    // Add CustomStringConvertible conformance to DukePerson class by defining the description property
    var description: String {
        let profile: String = "Duke person: " + firstName + " " + lastName
        return profile
    }

    // Class initializer
    init(firstName: String, lastName: String, whereFrom: String, gender: Gender, degree: String, bestProgrammingLanguage: [String], hobbies: [String], role: DukeRole) {
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.whereFrom = whereFrom
        self.gender = gender
        self.degree = degree
        self.bestProgrammingLanguage = bestProgrammingLanguage
        self.hobbies = hobbies
        self.role = role
        self.fullName = firstName + " " + lastName
    }
}

// The array of DukePerson objects forms the ECE 564 class roster, including Prof. Ric, all the TAs, and myself.

let myself: DukePerson = DukePerson(firstName: "Yifan", lastName: "Li", whereFrom: "Hebei, China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["C", "C++", "Python"], hobbies: ["Traveling", "Playing online games", "Cardio workout"], role: .Student)
let professor: DukePerson = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC", gender: .Male, degree: "BS", bestProgrammingLanguage: ["Swift", "C", "C++"], hobbies: ["Golf", "Swimming", "Biking"], role: .Professor)
let ta1: DukePerson = DukePerson(firstName: "Walker", lastName: "Eacho", whereFrom: "Chevy Chase, MD", gender: .Male, degree: "BS", bestProgrammingLanguage: ["Swift", "Objective-C", "C"], hobbies: ["Sailing", "Climbing", "Baking"], role: .TA)
let ta2: DukePerson = DukePerson(firstName: "Niral", lastName: "Shah", whereFrom: "Central New Jersey", gender: .Male, degree: "BS in ECE & CS", bestProgrammingLanguage: ["Swift", "Python", "C"], hobbies: ["Computer Vision projects", "Tennis", "Traveling"], role: .TA)

var roster: [DukePerson] = [myself, professor, ta1, ta2]

//classmates
//let classmate1: DukePerson = DukePerson(firstName: "Zhizhou", lastName: "Zhang", whereFrom: "Wuhan, China", gender: .Male, netID: "zz134", degree: "BS in Electrical Engineering", bestProgrammingLanguage: ["Java", "C++", "C"], hobbies: ["Traveling", "Watching movies"], role: .Student, almaMater: "Wuhan University of Science and Technology", approximateAge: 23, graduated: true)
//let classmate2: DukePerson = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "Hebei, China", gender: .Male, netID: "hz147", degree: "BS in Electrical Engineering", bestProgrammingLanguage: ["C", "C++", "Java"], hobbies: ["Swimming", "Running", "Reading"], role: .Student, almaMater: "Tsinghua University", approximateAge: 24, graduated: true)


// An additional function used to ascertain the gender and course role of the given person
func getGenderAndRole(_ gender: Gender, _ role: DukeRole) -> (String, String) {
    var courseRole: String
    switch role {
    case .Professor:
        courseRole = "professor"
    case .Student:
        courseRole = "student"
    case .TA:
        courseRole = "TA"
    }

    var pronoun: String
    switch gender {
    case .Female:
        pronoun = "She"
    case .Male:
        pronoun = "He"
    }

    return (pronoun, courseRole)
}

// whoIs function
func whoIs(_ name: String) -> String {
    for person in roster {
        if person.fullName == name {
            let (pronoun, courseRole) = getGenderAndRole(person.gender, person.role)
            
            var langStr: String = ""
            for i in 0..<(person.bestProgrammingLanguage.count) {
                if i != person.bestProgrammingLanguage.count-1 {
                    langStr += "\(person.bestProgrammingLanguage[i]), "
                } else {
                    langStr += "and \(person.bestProgrammingLanguage[i])"
                }
            }
            
            var hobbyStr: String = ""
            for i in 0..<(person.hobbies.count) {
                if i != person.hobbies.count-1 {
                    hobbyStr += "\(person.hobbies[i]), "
                } else {
                    hobbyStr += "and \(person.hobbies[i])"
                }
            }
            
            let personalInfo: String = "\(name) is from \(person.whereFrom) and is a \(courseRole) of ECE 564. \(pronoun) is proficient in \(langStr). When not in class, \(person.firstName) enjoys \(hobbyStr).\n"
            return personalInfo
        }
    }

    return "Your search '" + name + "' did not match any people in ECE 564 class.\n"
}

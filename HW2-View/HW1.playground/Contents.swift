import UIKit

/*:
 ### ECE 564 HW1 assignment
 In this first assignment, you are going to create a base data model for storing information about the students, TAs and professors in ECE 564. You need to populate your data model with at least 3 records, but can add more.  You will also provide a search function ("whoIs") to search an array of those objects by first name and last name.
 I suggest you create a new class called `DukePerson` and have it subclass `Person`.  You also need to abide by 2 protocols:
 1. BlueDevil
 2. CustomStringConvertible
 
 I also suggest you try to follow good OO practices by containing any properties and methods that deal with `DukePerson` within the class definition.
 */
/*:
 In addition to the properties required by `Person`, `CustomStringConvertible` and `BlueDevil`, you need to include the following information about each person:
 * Their degree, if applicable
 * Up to 3 of their best programming languages as an array of `String`s (like `hobbies` that is in `BlueDevil`)
 */
/*:
 I suggest you create an array of `DukePerson` objects, and you **must** have at least 4 entries in your array for me to test:
 1. Yourself
 2. Me (my info is in the Class Handbook)
 3. The TAs (also in Class Handbook)
 */
/*:
 Your program must contain the following:
 - You must include 4 of the following - array, dictionary, set, class, function, closure expression, enum, struct
 - You must include 4 different types, such as string, character, int, double, bool, float
 - You must include 4 different control flows, such as for/in, while, repeat/while, if/else, switch/case
 - You must include 4 different operators from any of the various categories of assignment, arithmatic, comparison, nil coalescing, range, logical
 */
/*: 
 Base grade is a 45 but more points can be earned by adding additional functions besides whoIs (like additional search), extensive error checking, concise code, excellent OO practices, and/or excellent, unique algorithms
 */
/*:
 Below is an example of what the string output from `whoIs' should look like:
 
     Ric Telford is from Morrisville, NC and is a Professor. He is proficient in Swift, C and C++. When not in class, Ric enjoys Biking, Hiking and Golf.
 */

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
    var almaMater: String = ""
    var approximateAge: Int = 1
    var graduated: Bool = true
    var netID: String = ""
    var bloodType: Character? = "O"
    
    // Add CustomStringConvertible conformance to DukePerson class by defining the description property
    var description: String {
        let profile: String = "Duke person: " + firstName + " " + lastName
        return profile
    }
    
    // Class initializer
    init(firstName: String, lastName: String, whereFrom: String, gender: Gender, netID: String, degree: String, bestProgrammingLanguage: [String], hobbies: [String], role: DukeRole, almaMater: String, approximateAge: Int, graduated: Bool) {
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.whereFrom = whereFrom
        self.gender = gender
        self.netID = netID
        self.degree = degree
        self.bestProgrammingLanguage = bestProgrammingLanguage
        self.hobbies = hobbies
        self.role = role
        self.fullName = firstName + " " + lastName
        self.almaMater = almaMater
        self.approximateAge = approximateAge
        self.graduated = graduated
    }
}

// The array of DukePerson objects forms the ECE 564 class roster, including Prof. Ric, all the TAs, and myself.
var roster = [DukePerson]()
let myself: DukePerson = DukePerson(firstName: "Yifan", lastName: "Li", whereFrom: "Hebei, China", gender: .Male, netID: "yl506", degree: "BS in Electrical Engineering", bestProgrammingLanguage: ["C", "C++", "Python"], hobbies: ["Traveling", "Playing online games", "Cardio workout"], role: .Student, almaMater: "Purdue University", approximateAge: 23, graduated: true)
let professor: DukePerson = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC", gender: .Male, netID: "rt113", degree: "BS in Computer Science", bestProgrammingLanguage: ["Swift", "C", "C++"], hobbies: ["Golf", "Swimming", "Biking"], role: .Professor, almaMater: "Trinity University", approximateAge: 57, graduated: true)
let ta1: DukePerson = DukePerson(firstName: "Walker", lastName: "Eacho", whereFrom: "Chevy Chase, MD", gender: .Male, netID: "dwe8", degree: "BS in ECE & CS", bestProgrammingLanguage: ["Swift", "Objective-C", "C"], hobbies: ["Sailing", "Climbing", "Baking"], role: .TA, almaMater: "Duke University", approximateAge: 22, graduated: false)
let ta2: DukePerson = DukePerson(firstName: "Niral", lastName: "Shah", whereFrom: "Central New Jersey", gender: .Male, netID: "ns247", degree: "BS in ECE & CS", bestProgrammingLanguage: ["Swift", "Python", "C"], hobbies: ["Computer Vision projects", "Tennis", "Traveling"], role: .TA, almaMater: "Rutgers University", approximateAge: 23, graduated: true)

roster.append(myself)
roster.append(professor)
roster.append(ta1)
roster.append(ta2)

//classmates
let classmate1: DukePerson = DukePerson(firstName: "Zhizhou", lastName: "Zhang", whereFrom: "Wuhan, China", gender: .Male, netID: "zz134", degree: "BS in Electrical Engineering", bestProgrammingLanguage: ["Java", "C++", "C"], hobbies: ["Traveling", "Watching movies"], role: .Student, almaMater: "Wuhan University of Science and Technology", approximateAge: 23, graduated: true)
let classmate2: DukePerson = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "Hebei, China", gender: .Male, netID: "hz147", degree: "BS in Electrical Engineering", bestProgrammingLanguage: ["C", "C++", "Java"], hobbies: ["Swimming", "Running", "Reading"], role: .Student, almaMater: "Tsinghua University", approximateAge: 24, graduated: true)

roster.append(classmate1)
roster.append(classmate2)

// An additional function used to ascertain the gender and course role of the given person
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
    
    var pronoun: String, pronoun2: String
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

// whoIs function
func whoIs(_ name: String) -> String {
    for person in roster {
        if person.fullName == name {
            let (pronoun, courseRole, pronoun2) = getGenderAndRole(person.gender, person.role)
            let degreeInfo: String = person.graduated ? "received" : "will receive"
            
            let personalInfo: String = "\(name) is from \(person.whereFrom) and is a \(courseRole) of ECE 564. \(pronoun) is about \(person.approximateAge) years old. \(pronoun) \(degreeInfo) \(pronoun2) \(person.degree) from \(person.almaMater). \(pronoun) is proficient in \(person.bestProgrammingLanguage[0]), \(person.bestProgrammingLanguage[1]), and \(person.bestProgrammingLanguage[2]). When not in class, \(person.firstName) enjoys \(person.hobbies[0]), \(person.hobbies[1]), and \(person.hobbies[2]).\n"
            return personalInfo
        }
    }
    
    return "Your search '" + name + "' did not match any people in ECE 564 class.\n"
}

// An additional function used to search a person by NetID, and if any results are found, display his/her detailed information
func searchByNetID(_ netid: String) -> String {
    var i = 0
    while i < roster.count {
        if roster[i].netID == netid {
            print("NetID '\(netid)' found. Name: \(roster[i].fullName)")
            return whoIs(roster[i].fullName)
        }
        i += 1
    }
    return "NetID '\(netid)' does not match any results in ECE 564 class.\n"
}

// An additional function used to search for the people who like the specified programming language
func searchByFavoriteLanguage(_ language: String) -> String {
    var peopleWhoLikeTheLanguage = Set<String>()
    var people: String = ""
    var anyoneLikes: Int = 0
    for person in roster {
        for item in person.bestProgrammingLanguage {
            if item == language {
                peopleWhoLikeTheLanguage.insert(person.fullName)
                anyoneLikes += 1
            }
        }
    }
    for who in peopleWhoLikeTheLanguage{
        people += "\(who)"
        peopleWhoLikeTheLanguage.remove(who)
        people += peopleWhoLikeTheLanguage.isEmpty ? ".\n" : ", "
    }
    
    return anyoneLikes != 0 ? "\(anyoneLikes) people like \(language): \(people)" : "Unfortunately, nobody likes \(language).\n"
}

//: ### END OF HOMEWORK
//: Uncomment the line below to test your homework.
//: The "whoIs" function should be defined as `func whoIs(_ name: String) -> String {   }`

print(whoIs("Ric Telford"))
print(whoIs("Yifan Li"))
print(whoIs("Walker Eacho"))
print(whoIs("Niral Shah"))
print(whoIs("Haohong Zhao"))
print(whoIs("Mr.Nobody"))
print(searchByNetID("dwe8"))
print(searchByNetID("abc123"))
print(searchByFavoriteLanguage("C"))
print(searchByFavoriteLanguage("MIPS Assembly"))
print("Yifan's blood type is \(myself.bloodType ?? "O").")

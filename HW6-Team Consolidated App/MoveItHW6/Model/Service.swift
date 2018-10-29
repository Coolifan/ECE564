//
//  Service.swift
//  HW6_JSON
//
//  Created by Haohong Zhao on 10/22/18.
//  Modified by Zi Xiong on 10/28/18.
//  Copyright © 2018 Haohong Zhao. All rights reserved.
//

import UIKit

protocol ServiceDownloadDelegate {
    func didFinishDownload(dukePersons: [DukePerson])
}

struct Service {
    static let shared = Service()
    
    func downloadDukePersonsFromServer(tableViewController: ServiceDownloadDelegate) {
        let urlString = "http://ece564.colab.duke.edu:5000/get"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to download student from server:", err)
                return
            }
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let jsonPersons = try jsonDecoder.decode([JSONDukePerson].self, from: data)
                var dukePersons = [DukePerson]()
                var degreeSet = Set<String>()
                var roleSet = Set<String>()
                jsonPersons.forEach({ (jsonPerson) in
                    degreeSet.insert(jsonPerson.degree)
                    roleSet.insert(jsonPerson.role)
                    let dukePerson = DukePerson(jsonDukePerson: jsonPerson)
                    dukePersons.append(dukePerson)
                })
                print("All degree Strings on the server are listed:", degreeSet)
                print("All role Strings on the server are listed:", degreeSet)
                DispatchQueue.main.async {
                    tableViewController.didFinishDownload(dukePersons: dukePersons)
                }
            } catch let decodeErr {
                print("Failed to decode JSONDukePerson:", decodeErr)
            }
            
            }.resume()
    }
    
    func uploadDukePersonToServer(DukePerson person: DukePerson, uid: Int) {
        let jsonPerson = JSONDukePerson(uid: uid, dukePerson: person)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(jsonPerson)
            let urlString = "http://ece564.colab.duke.edu:5000/send"
            guard let url = URL(string: urlString) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = jsonData
            URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
                if let err = err {
                    print("Failed to upload json to server:", err)
                    return
                }
                print("RESP:", resp.debugDescription)
                }.resume()
        } catch let encodeErr {
            print("Failed to encode jsonDukePerson:", encodeErr)
        }
    }
}
//MARK: - JSONDukePerson | DukePerson to JSONDukePerson: Upload
struct JSONDukePerson: Codable {
    var firstname: String
    var lastname: String
    var gender: Bool
    var wherefrom: String
    var role: String
    var degree: String
    var hobbies: [String]
    var languages: [String]
    var pic: String?
    var team: String?
    var uid: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case firstname
        case lastname
        case gender
        case wherefrom
        case role
        case degree
        case hobbies
        case languages
        case pic
        case team
        case uid
    }
    
    init() {
        firstname = "First"
        lastname = "Last"
        gender = true
        wherefrom = "wherefrom"
        role = "Student"
        degree = "BS"
        hobbies = []
        languages = []
        team = nil
        pic = nil
        uid = nil
    }
    
    init(uid: Int?, firstname: String, lastname: String, gender: Bool, wherefrom: String, role: String, degree: String, team: String?, hobbies: [String], languages: [String], pic: String?) {
        self.firstname = firstname
        self.lastname = lastname
        self.gender = gender
        self.wherefrom = wherefrom
        self.role = role
        self.degree = degree
        self.hobbies = hobbies
        self.languages = languages
        self.pic = pic
        self.team = team
        self.uid = uid
    }
    
    init(uid: Int, dukePerson p: DukePerson) {
        firstname = p.firstName
        lastname = p.lastName
        gender = (p.gender == .Male) ? true : false
        wherefrom = p.whereFrom
        role = p.role.rawValue
        degree = p.degree
        hobbies = p.hobbies
        languages = p.bestProgrammingLanguage
        team = p.team
        pic = p.pic
        self.uid = uid
    }
}
//MARK: - JSONDukePerson decode: Download
extension JSONDukePerson {
    init(from decoder: Decoder) throws {
        self.init()
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            firstname = try container.decode(String.self, forKey: .firstname)
            lastname = try container.decode(String.self, forKey: .lastname)
            gender = try container.decode(Bool.self, forKey: .gender)
            wherefrom = try container.decode(String.self, forKey: .wherefrom)
            role = try container.decode(String.self, forKey: .role)
            degree = try container.decode(String.self, forKey: .degree)
            hobbies = try container.decode([String].self, forKey: .hobbies)
            if let languages = try? container.decode([String].self, forKey: .languages) {
                self.languages = languages
            } else {
                self.languages = []
            }
            team = try? container.decode(String.self, forKey: .team)
            pic = try? container.decode(String.self, forKey: .pic)
            if let uid = try? container.decode(Int.self, forKey: .uid) {
                self.uid = uid
            } else {
                self.uid = 0
            }
        } catch let decodeErr {
            print("Failed to decode DukePerson from Server:", decodeErr)
        }
    }
}
//MARK: - JSONDukePerson to DukePerson: Download
extension DukePerson {
    
    var roleDic: [String: DukeRole] {
        let dic: [String: DukeRole] = [
            "Professor": .Professor,
            "TA": .TA,
            "Teaching Assistant": .TA,
            "Student": .Student
        ]
        return dic
    }
    
    convenience init(jsonDukePerson jsonP: JSONDukePerson) {
        self.init()
        firstName = jsonP.firstname
        lastName = jsonP.lastname
        gender = (jsonP.gender) ? .Male : .Female
        whereFrom = jsonP.wherefrom
        role = roleDic[jsonP.role]!
        degree = jsonP.degree
        hobbies = jsonP.hobbies
        bestProgrammingLanguage = jsonP.languages
        pic = jsonP.pic ?? ""
        team = jsonP.team ?? ""
    }
}

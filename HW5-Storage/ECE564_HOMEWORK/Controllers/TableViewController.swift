//
//  TableViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/3/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, PassDataBack {

    var people = [DukePerson]() //Array of all DukePersons, will be saved/loaded
    var teams: [String: Int] = [:] //Dictionary used for linking between teams and their sections in table, will be saved/loaded
    var peopleArray: [[DukePerson]] = [[], []] //for easier alignment with tableViewCell indices (indexPath.section & row)
    var studentsWithNoTeams: [DukePerson] = [] //Array of DukePersons with no teams
    
    let peopleDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("People.plist")
    let teamsDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Teams.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
//        print(peopleDataFilePath)
//        print(teamsDataFilePath)
    }

    
    // MARK: - TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return peopleArray.count
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray[section].count + 1 // row 0 will be separator cells, so add 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { // display a separator cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorCell", for: indexPath) as! SeparatorCell
            if indexPath.section == 0 {
                cell.roleLabel.text = "Professor"
            } else if indexPath.section == 1 {
                cell.roleLabel.text = "TA"
            } else {
                for (teamName, sectionID) in self.teams {
                    if sectionID == indexPath.section {
                        if peopleArray[indexPath.section].isEmpty {
                            cell.isHidden = true
                        }
                        cell.roleLabel.text = "Team " + teamName
                        if teamName == "" {
                            cell.roleLabel.text = "Students With No Teams"
                            break
                        }
                    }
                }
            }
            return cell
        } else { // display a personCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
            let nextPerson: DukePerson = peopleArray[indexPath.section][indexPath.row-1]
            cell.thisPerson = nextPerson
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if peopleArray[indexPath.section].isEmpty && indexPath.row == 0 { // hide the separator cell as well
            return CGFloat(0.0)
        } else if !peopleArray[indexPath.section].isEmpty && indexPath.row == 0 { // normal separator cell
            return CGFloat(44.0)
        } else { // person cell
            return CGFloat(125.0)
        }
    }
    
    
    var personClicked: DukePerson?
    var personCellClicked: Bool = false
    // Whenever a personCell is clicked, redirect to informationView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        // Separator cells' row index are 0s, [indexPath.row-1] is out of range
        if indexPath.row > 0 {
            personClicked = peopleArray[indexPath.section][indexPath.row-1]
            personCellClicked = true
            performSegue(withIdentifier: "showInformation", sender: nil)
        }
    }
    
    
    // Disable swiping to delete for separator cells and professors & TAs sections
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == 0 || indexPath.section <= 1 {
            return UITableViewCellEditingStyle.none
        } else {
            return UITableViewCellEditingStyle.delete
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            for i in 0..<people.count {
                if people[i].fullName == peopleArray[indexPath.section][indexPath.row - 1].fullName {
                    people.remove(at: i)
                    break
                }
            }
            for i in 0..<studentsWithNoTeams.count {
                if studentsWithNoTeams[i].fullName == peopleArray[indexPath.section][indexPath.row-1].fullName {
                    studentsWithNoTeams.remove(at: i)
                    break
                }
            }
            peopleArray[indexPath.section].remove(at: indexPath.row - 1)
            
            savePeopleData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    
    //MARK: Perform Segue
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    // When anything except a personCell is clicked, do not perform segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return (personCellClicked == true) || (sender as? UIBarButtonItem == addButton) ? true : false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInformation" {
            let informationVC = segue.destination as! InformationViewController
            informationVC.person = personClicked!
            informationVC.delegate = self // set self as the delegate that will receive data passing back
        } else if segue.identifier == "addNewPerson" {
            let navVC = segue.destination as! UINavigationController
            let newPersonVC = navVC.viewControllers.first as! AddViewController
            newPersonVC.people = self.people
        }
    }
 
    
    //MARK: Data Initialization
    func loadInitialData() {
        if let tempPeople = loadPeopleData() {
            self.people = tempPeople
        } else {
            let myself: DukePerson = DukePerson(firstName: "Yifan", lastName: "Li", whereFrom: "Hebei, China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["C", "C++", "Python"], hobbies: ["Playing soccer", "Playing online games", "Cardio workout"], role: .Student, team: "MoveIt")
            let professor: DukePerson = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC", gender: .Male, degree: "NA", bestProgrammingLanguage: ["Swift", "C", "C++"], hobbies: ["Golf", "Swimming", "Biking"], role: .Professor, team: "")
            let ta1: DukePerson = DukePerson(firstName: "Walker", lastName: "Eacho", whereFrom: "Chevy Chase, MD", gender: .Male, degree: "BS", bestProgrammingLanguage: ["Swift", "Objective-C", "C"], hobbies: ["Sailing", "Climbing", "Baking"], role: .TA, team: "")
            let ta2: DukePerson = DukePerson(firstName: "Niral", lastName: "Shah", whereFrom: "Central New Jersey", gender: .Male, degree: "MENG", bestProgrammingLanguage: ["Swift", "Python", "C"], hobbies: ["Computer Vision projects", "Tennis", "Traveling"], role: .TA, team: "")
            let teammate1: DukePerson = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["C", "C++", "Java"], hobbies: ["Running", "Swimming"], role: .Student, team: "MoveIt")
            let teammate2: DukePerson = DukePerson(firstName: "Wenchao", lastName: "Zhu", whereFrom: "China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["Swift", "Python", "C++"], hobbies: ["Swimming", "Tennis", "Driving"], role: .Student, team: "MoveIt")
            let teammate3: DukePerson = DukePerson(firstName: "Zi", lastName: "Xiong", whereFrom: "China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["Swift", "Python", "Java"], hobbies: ["Coding", "Reading", "Watching Japanese TV series"], role: .Student, team: "MoveIt")
            
            self.people.append(professor)
            self.people.append(ta1)
            self.people.append(ta2)
            self.people.append(myself)
            self.people.append(teammate1)
            self.people.append(teammate2)
            self.people.append(teammate3)
            
            savePeopleData()
        }
        
        if let tempTeams = loadTeamsData() {
            self.teams = tempTeams
        } else {
            self.teams["MoveIt"] = 2
            saveTeamsData()
        }
        
        peopleArray = [[], []] // reset the array to prevent duplicate people after return from searching
        
        // search through teamsData to determine how many teams are present
        let numOfTeams = self.teams.values.max()! - 1
        for _ in 0..<numOfTeams { // and allocate enough space to prevent index out of range error
            peopleArray.append([])
        }
        
        
        for person in self.people {
            if person.role == .Professor {
                peopleArray[0].append(person)
            } else if person.role == .TA {
                peopleArray[1].append(person)
            } else {
                let sectionID: Int = self.teams[person.team]!
                peopleArray[sectionID].append(person)
                if person.team == "" {
                    studentsWithNoTeams.append(person)
                }
            }
        }
        
    }
    
    
    //MARK: Data Encoding & Decoding
    
    func loadPeopleData() -> [DukePerson]? {
        var dataLoaded: [DukePerson]?
        if let peopleData = try? Data(contentsOf: peopleDataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                dataLoaded = try decoder.decode([DukePerson].self, from: peopleData)
            } catch {
                print("Error loading people data, \(error)")
            }
        }
        return dataLoaded
    }
    
    
    func loadTeamsData() -> [String: Int]? {
        var dataLoaded: [String: Int]?
        if let teamsData = try? Data(contentsOf: teamsDataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                dataLoaded = try decoder.decode([String: Int].self, from: teamsData)
            } catch {
                print("Error loading teams data, \(error)")
            }
        }
        return dataLoaded
    }
    
    
    func savePeopleData() {
        let encoder = PropertyListEncoder()
        do {
            let peopleData = try encoder.encode(self.people)
            try peopleData.write(to: peopleDataFilePath!)
        } catch {
            print("Error saving people data, \(error)")
        }
    }
    
    
    func saveTeamsData() {
        let encoder = PropertyListEncoder()
        do {
            let teamsData = try encoder.encode(self.teams)
            try teamsData.write(to: teamsDataFilePath!)
        } catch {
            print("Error saving teams data, \(error)")
        }
    }
    
    
    //MARK: Return From Segue
    // Add a new person to the class if all information is valid
    @IBAction func returnFromNewPerson(segue: UIStoryboardSegue) {
        let source: AddViewController = segue.source as! AddViewController
        let newPerson: DukePerson = source.newPerson
        let errorOccurred: Bool = source.errorOccurred
        let cancelPressed: Bool = source.cancelPressed
        if (errorOccurred == false) && (cancelPressed == false) {
            self.people.append(newPerson)
            
            if newPerson.role == .Professor {
                peopleArray[0].append(newPerson)
            } else if newPerson.role == .TA {
                peopleArray[1].append(newPerson)
            }
            else {
                // a new student
                if newPerson.team != "" { // team name given
                    for (teamName, sectionID) in self.teams {
                        if newPerson.team == teamName { // a new student for an existing team
                            peopleArray[sectionID].append(newPerson)
                            savePeopleData()
                            self.tableView.reloadData()
                            return
                        }
                    }
                    // a new student for a new team
                    self.teams[newPerson.team] = self.teams.count + 2
                    //ex: if count = 1, the new team's indexPath.section should be 3, since the team sections starts from 2 in the table
                    self.peopleArray.append([])
                    self.peopleArray[self.teams[newPerson.team]!].append(newPerson)
                } else { // a new student without teams
                    self.studentsWithNoTeams.append(newPerson)
                    var studentsWithoutTeams: Bool = false // used to indicate if there already exists students w/o teams
                    
                    for (teamName, sectionID) in teams {
                        if teamName == "" {
                            studentsWithoutTeams = true // search through teams dict to see if 'team' of students w/o teams has been created
                            self.peopleArray[sectionID].append(newPerson) // if it already exists, append new DukePerson
                            break
                        }
                    }
                    
                    // If this DukePerson is the first person who does not have a team, create the new 'team' for him
                    if studentsWithoutTeams == false { // will be executed ONCE
                        self.teams[""] = self.teams.count + 2
                        self.peopleArray.append([])
                        self.peopleArray[self.teams[""]!].append(newPerson)
                    }
                }
            }
            savePeopleData()
            saveTeamsData()
            self.tableView.reloadData()
        }
        
    }
    
    
    // protocol method for receiving data from editing mode
    func dataReceived(personEdited: DukePerson) {
        
        for i in 0..<self.peopleArray.count {
            for j in 0..<self.peopleArray[i].count {
                if peopleArray[i][j].fullName == personEdited.fullName {
                    peopleArray[i].remove(at: j)
                    break // MUST break here! Otherwise, index out of range after removal.
                }
            }
        }
        
        for i in 0..<self.people.count {
            if self.people[i].fullName == personEdited.fullName {
                self.people[i] = personEdited
            }
        }
        
        if personEdited.role == .Professor {
            self.peopleArray[0].append(personEdited)
        } else if personEdited.role == .TA {
            self.peopleArray[1].append(personEdited)
        } else {
            // a new student
            if personEdited.team != "" { // team name given
                for (teamName, sectionID) in self.teams {
                    if personEdited.team == teamName { // a new student for an existing team
                        peopleArray[sectionID].append(personEdited)
                        savePeopleData()
                        self.tableView.reloadData()
                        return
                    }
                }
                // a new student for a new team
                self.teams[personEdited.team] = self.teams.count + 2
                self.peopleArray.append([])
                self.peopleArray[self.teams[personEdited.team]!].append(personEdited)
            } else { // a new student without teams
                self.studentsWithNoTeams.append(personEdited)
                var studentsWithoutTeams: Bool = false
                
                for (teamName, sectionID) in teams {
                    if teamName == "" {
                        studentsWithoutTeams = true
                        self.peopleArray[sectionID].append(personEdited)
                        break
                    }
                }
                
                if studentsWithoutTeams == false {
                    self.teams[""] = self.teams.count + 2
                    self.peopleArray.append([])
                    self.peopleArray[self.teams[""]!].append(personEdited)
                }
            }
        }
        
        savePeopleData()
        saveTeamsData()
        self.tableView.reloadData()
    }
    
    
}

//MARK: Search Bar Methods

extension TableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        stride(from: self.peopleArray.count-1, through: 0, by: -1).forEach { (i) in
            stride(from: self.peopleArray[i].count-1, through: 0, by: -1).forEach({ (j) in
                if peopleArray[i][j].fullName.range(of: searchBar.text!, options: .caseInsensitive) == nil
                && peopleArray[i][j].degree.uppercased() != searchBar.text!.uppercased()
                && peopleArray[i][j].team.range(of: searchBar.text!, options: .caseInsensitive) == nil {
                    peopleArray[i].remove(at: j)
                }
            })
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadInitialData()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

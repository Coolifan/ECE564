//
//  ClassTableViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 9/20/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class ClassTableViewController: UITableViewController {
    
    var people = [DukePerson]()
    var peopleArray: [[DukePerson]] = [[],[],[]] //for easier alignment with tableViewCell indices
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.peopleArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peopleArray[section].count + 1 // row 0 will be separator cells, so add 1
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { // display a separatorCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorCell", for: indexPath) as! SeparatorTableViewCell
            switch indexPath.section {
            case 0:
                cell.roleTextField.text = "Professor"
            case 1:
                cell.roleTextField.text = "TA"
            default:
                cell.roleTextField.text = "Student"
            }
            return cell
        } else { // display a personCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonTableViewCell
            let nextPerson: DukePerson = peopleArray[indexPath.section][indexPath.row-1]
            cell.thisPerson = nextPerson
            return cell
        }
    }
    
    
    var selectedPerson: DukePerson?
    // Whenever a personCell is clicked, redirect to informationView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPerson = peopleArray[indexPath.section][indexPath.row-1]
        performSegue(withIdentifier: "showInformation", sender: nil)
    }
    
    
    // Set the data on the destination VCs when + sign or a tableViewCell is tapped
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInformation" {
            let informationVC = segue.destination as! InformationViewController
            informationVC.person = selectedPerson!
        } else if segue.identifier == "addNewPerson" {
            let navVC = segue.destination as! UINavigationController
            let newPersonVC = navVC.viewControllers.first as! NewPersonViewController
            newPersonVC.people = self.people
        }
    }
    
    // Pre-populate the table with hardcoded data
    func loadInitialData() {
        let myself: DukePerson = DukePerson(firstName: "Yifan", lastName: "Li", whereFrom: "Hebei, China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["C", "C++", "Python"], hobbies: ["Playing soccer", "Playing online games", "Cardio workout"], role: .Student, team: "MoveIt")
        let professor: DukePerson = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC", gender: .Male, degree: "NA", bestProgrammingLanguage: ["Swift", "C", "C++"], hobbies: ["Golf", "Swimming", "Biking"], role: .Professor, team: "")
        let ta1: DukePerson = DukePerson(firstName: "Walker", lastName: "Eacho", whereFrom: "Chevy Chase, MD", gender: .Male, degree: "BS", bestProgrammingLanguage: ["Swift", "Objective-C", "C"], hobbies: ["Sailing", "Climbing", "Baking"], role: .TA, team: "")
        let ta2: DukePerson = DukePerson(firstName: "Niral", lastName: "Shah", whereFrom: "Central New Jersey", gender: .Male, degree: "MENG", bestProgrammingLanguage: ["Swift", "Python", "C"], hobbies: ["Computer Vision projects", "Tennis", "Traveling"], role: .TA, team: "")
        let teammate1: DukePerson = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["C", "C++", "Java"], hobbies: ["Running", "Swimming"], role: .Student, team: "MoveIt")
        
        self.people.append(professor)
        self.people.append(ta1)
        self.people.append(ta2)
        self.people.append(myself)
        self.people.append(teammate1)
        
        for person in self.people {
            if person.role == .Professor {
                peopleArray[0].append(person)
            } else if person.role == .TA {
                peopleArray[1].append(person)
            } else {
                peopleArray[2].append(person)
            }
        }
    }
    
    
    // Add a new person to the class if all information is valid
    @IBAction func returnFromNewPerson(segue: UIStoryboardSegue) {
        let source: NewPersonViewController = segue.source as! NewPersonViewController
        let who: DukePerson = source.newFace
        let errorOccurred: Bool = source.errorOccurred
        if errorOccurred == false {
            self.people.append(who)
            if who.role == .Professor {
                peopleArray[0].append(who)
            } else if who.role == .TA {
                peopleArray[1].append(who)
            } else {
                peopleArray[2].append(who)
            }
        }
        self.tableView.reloadData()
    }
    
    
    // Update tableView after someone's information has been edited
    @IBAction func returnFromInformationView(segue: UIStoryboardSegue) {
        // up until this point, the corresponding element in people and peopleArray has been updated
        peopleArray[0].removeAll()
        peopleArray[1].removeAll()
        peopleArray[2].removeAll()
        for person in self.people {
            if person.role == .Professor {
                peopleArray[0].append(person)
            } else if person.role == .TA {
                peopleArray[1].append(person)
            } else {
                peopleArray[2].append(person)
            }
        }
        self.tableView.reloadData()
    }

    
}

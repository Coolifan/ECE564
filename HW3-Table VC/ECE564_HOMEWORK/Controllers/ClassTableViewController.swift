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
    var peopleArray: [[DukePerson]] = [[],[],[]]
    
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
        return self.peopleArray[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let personCell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonTableViewCell
        let nextPerson: DukePerson = peopleArray[indexPath.section][indexPath.row]//self.people[indexPath.row]
        personCell.thisPerson = nextPerson
        return personCell
    }
    
    var selectedPerson: DukePerson?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPerson = peopleArray[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "showInformation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInformation" {
        let targetVC = segue.destination as! InformationViewController
        targetVC.person = selectedPerson!
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadInitialData() {
        let myself: DukePerson = DukePerson(firstName: "Yifan", lastName: "Li", whereFrom: "Hebei, China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["C", "C++", "Python"], hobbies: ["Traveling", "Playing online games", "Cardio workout"], role: .Student)
        let professor: DukePerson = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC", gender: .Male, degree: "BS", bestProgrammingLanguage: ["Swift", "C", "C++"], hobbies: ["Golf", "Swimming", "Biking"], role: .Professor)
        let ta1: DukePerson = DukePerson(firstName: "Walker", lastName: "Eacho", whereFrom: "Chevy Chase, MD", gender: .Male, degree: "BS", bestProgrammingLanguage: ["Swift", "Objective-C", "C"], hobbies: ["Sailing", "Climbing", "Baking"], role: .TA)
        let ta2: DukePerson = DukePerson(firstName: "Niral", lastName: "Shah", whereFrom: "Central New Jersey", gender: .Male, degree: "MENG", bestProgrammingLanguage: ["Swift", "Python", "C"], hobbies: ["Computer Vision projects", "Tennis", "Traveling"], role: .TA)
        let teammate1: DukePerson = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: .Male, degree: "MS", bestProgrammingLanguage: ["C", "C++", "Java"], hobbies: ["Running", "Swimming"], role: .Student)
        self.people.append(myself)
        self.people.append(professor)
        self.people.append(ta1)
        self.people.append(ta2)
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
    
    @IBAction func returnFromNewPerson(segue: UIStoryboardSegue) {
        let source: NewPersonViewController = segue.source as! NewPersonViewController
        let who: DukePerson = source.newFace
        for i in 0..<people.count {
            if people[i].lastName == who.lastName && people[i].firstName == who.firstName {
                // duplicate person!
                return
            } else {
                self.people.append(who)
                if who.role == .Professor {
                    peopleArray[0].append(who)
                } else if who.role == .TA {
                    peopleArray[1].append(who)
                } else {
                    peopleArray[2].append(who)
                }
                break
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func returnFromInformationView(segue: UIStoryboardSegue) {
        
    }

}

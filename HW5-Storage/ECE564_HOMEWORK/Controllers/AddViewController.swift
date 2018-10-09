//
//  AddViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/3/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var languagesTextField: UITextField!
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var teamTextField: UITextField!
    
    @IBOutlet weak var genderSC: UISegmentedControl!
    @IBOutlet weak var roleSC: UISegmentedControl!
    @IBOutlet weak var degreeSC: UISegmentedControl!
    
    @IBOutlet weak var addButton: UIButton!
    var errorOccurred: Bool = false
    var cancelPressed: Bool = false
    var newPerson = DukePerson()
    var people = [DukePerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newPerson.gender = .Male
        self.newPerson.role = .Student
        self.newPerson.degree = "MS"
        
        // Dismiss the keyboard when tapped outside text fields or return key
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
        self.view.addGestureRecognizer(tapGesture)
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        fromTextField.delegate = self
        hobbiesTextField.delegate = self
        languagesTextField.delegate = self
        teamTextField.delegate = self
    }
    
    @IBAction func genderSCTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.newPerson.gender = .Female
        default:
            self.newPerson.gender = .Male
        }
    }
    
    @IBAction func roleSCTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.newPerson.role = .Professor
            self.teamTextField.isEnabled = false
        case 2:
            self.newPerson.role = .TA
            self.teamTextField.isEnabled = false
        default:
            self.newPerson.role = .Student
            self.teamTextField.isEnabled = true
        }
    }
    
    
    @IBAction func degreeSCTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.newPerson.degree = "BS"
        case 2:
            self.newPerson.degree = "MENG"
        case 3:
            self.newPerson.degree = "PhD"
        case 4:
            self.newPerson.degree = "NA"
        case 5:
            self.newPerson.degree = "other"
        default:
            self.newPerson.degree = "MS"
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        errorOccurred = getPersonalInformation()
        if errorOccurred == true {
            return
        }
    }
    
    
    // If all input fields are valid, go on and trigger the segue. Stay on the view otherwise
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if sender as? UIButton == self.addButton {
            return errorOccurred ? false : true
        } else { // clicked cancel button
            self.cancelPressed = true
        }
        return true
    }

    // Get and check all inputs. Return true if there is an error
    func getPersonalInformation() -> Bool {
        for person in self.people {
            if (person.lastName.uppercased() == self.lastNameTextField.text?.uppercased().trimmingCharacters(in: .whitespaces)) && (person.firstName.uppercased() == self.firstNameTextField.text?.uppercased().trimmingCharacters(in: .whitespaces)) {
                // Check if duplicate
                displayAlertMessage(title: "ERROR!", message: "\(person.firstName) \(person.lastName) is already in the class!")
                return true
            }
        }
        
        if (self.firstNameTextField.text?.isEmpty)! || (self.lastNameTextField.text?.isEmpty)! ||  (self.fromTextField.text?.isEmpty)! ||   (self.hobbiesTextField.text?.isEmpty)! || (self.languagesTextField.text?.isEmpty)! {
            displayAlertMessage(title: "ERROR!", message: "All fields are required!")
            return true
        }
    
        self.newPerson.firstName = (self.firstNameTextField.text!).trimmingCharacters(in: .whitespaces)
        self.newPerson.lastName = (self.lastNameTextField.text!).trimmingCharacters(in: .whitespaces)
        self.newPerson.whereFrom = (self.fromTextField.text!).trimmingCharacters(in: .whitespaces)
        self.newPerson.fullName = self.newPerson.firstName + " " + self.newPerson.lastName
        self.newPerson.team = (self.teamTextField.text!).trimmingCharacters(in: .whitespaces)
        
        var hobbies: [String] = (hobbiesTextField.text!).trimmingCharacters(in: .whitespaces).components(separatedBy: ",").filter({$0 != ""})
        if hobbies.count > 1 {
            for i in 1..<hobbies.count {
                hobbies[i] = " " + hobbies[i]
            }
        }
        if hobbies.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 hobbies!")
            return true
        }
        self.newPerson.hobbies = hobbies
        
        var languages: [String] = (languagesTextField.text!).trimmingCharacters(in: .whitespaces).components(separatedBy: ",").filter({$0 != ""})
        if languages.count > 1 {
            for i in 1..<languages.count {
                languages[i] = " " + languages[i]
            }
        }
        if languages.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 languages!")
            return true
        }
        self.newPerson.bestProgrammingLanguage = languages
        
        // until this point, all inputs are valid, no error occurred.
        return false
    }
    
    
    // Pop-up alert to display the error message
    func displayAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // End editing when tapped outside the text fields
    @objc func tappedOutside() {
        firstNameTextField.endEditing(true)
        lastNameTextField.endEditing(true)
        fromTextField.endEditing(true)
        hobbiesTextField.endEditing(true)
        languagesTextField.endEditing(true)
        teamTextField.endEditing(true)
    }
    
}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

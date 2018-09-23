//
//  NewPersonViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 9/20/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class NewPersonViewController: UIViewController, UITextFieldDelegate {
    
    var newFace = DukePerson()
    var people = [DukePerson]()
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var languagesTextField: UITextField!
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var teamTextField: UITextField!
    
    var errorOccurred: Bool = false
    // 2 functionalities for the addButton: 1. Check input validity 2. Redirect to another VC
    @IBOutlet weak var addButton: UIButton!
    // Get and check all inputs when Add button is clicked. If something goes wrong, stay on the view
    @IBAction func addNewPerson(_ sender: Any) {
        errorOccurred = getPersonalInformation()
        if errorOccurred == true {
            return
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dismiss the keyboard when tap anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        // dismiss the keyboard when press return key
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        genderTextField.delegate = self
        roleTextField.delegate = self
        fromTextField.delegate = self
        degreeTextField.delegate = self
        hobbiesTextField.delegate = self
        languagesTextField.delegate = self
        teamTextField.delegate = self
    }
    
    
    // dismiss current keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        roleTextField.resignFirstResponder()
        fromTextField.resignFirstResponder()
        degreeTextField.resignFirstResponder()
        hobbiesTextField.resignFirstResponder()
        languagesTextField.resignFirstResponder()
        teamTextField.resignFirstResponder()
        return true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // If all input fields are valid, go on and trigger the segue. Stay on the view otherwise
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if sender as? UIButton == self.addButton {
            return errorOccurred ? false : true
        }
        return true
    }
    
    
    // Get and check all inputs. Return true if there is an error
    func getPersonalInformation() -> Bool {
        for person in self.people {
            if person.lastName == self.lastNameTextField.text && person.firstName == self.firstNameTextField.text {
                // Check if duplicate
                displayAlertMessage(title: "ERROR!", message: "\(person.firstName) \(person.lastName) is already in the class!")
                return true
            }
        }
        
        
        if (self.firstNameTextField.text?.isEmpty)! || (self.lastNameTextField.text?.isEmpty)! || (self.genderTextField.text?.isEmpty)! || (self.fromTextField.text?.isEmpty)! || (self.degreeTextField.text?.isEmpty)! || (self.roleTextField.text?.isEmpty)! || (self.hobbiesTextField.text?.isEmpty)! || (self.languagesTextField.text?.isEmpty)! || ((self.roleTextField.text! == "Student") && (self.teamTextField.text?.isEmpty)!) {
            displayAlertMessage(title: "ERROR!", message: "All fields are required!")
            return true
        }
        
        self.newFace.firstName = self.firstNameTextField.text!
        self.newFace.lastName = self.lastNameTextField.text!
        self.newFace.whereFrom = self.fromTextField.text!
        self.newFace.fullName = self.newFace.firstName + " " + self.newFace.lastName
        
        if self.genderTextField.text == "Male" {
            self.newFace.gender = .Male
        } else if self.genderTextField.text == "Female" {
            self.newFace.gender = .Female
        } else {
            displayAlertMessage(title: "ERROR!", message: "Invalid gender!")
            return true
        }
        
        if self.roleTextField.text == "Student" {
            self.newFace.role = .Student
            self.newFace.team = self.teamTextField.text!
        } else if self.roleTextField.text == "TA" {
            self.newFace.role = .TA
            self.newFace.team = ""
        } else if self.roleTextField.text == "Professor" {
            self.newFace.role = .Professor
            self.newFace.team = ""
        } else {
            displayAlertMessage(title: "ERROR!", message: "Invalid role!")
            return true
        }
        
        switch self.degreeTextField.text {
        case "MS":
            self.newFace.degree = "MS"
        case "BS":
            self.newFace.degree = "BS"
        case "PhD":
            self.newFace.degree = "PhD"
        case "MENG":
            self.newFace.degree = "MENG"
        case "NA":
            self.newFace.degree = "NA"
        default:
            self.newFace.degree = "other"
        }
        
        let hobbies: [String] = hobbiesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
        if hobbies.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 hobbies!")
            return true
        }
        self.newFace.hobbies = hobbies
        
        let languages: [String] = languagesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
        if languages.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 languages!")
            return true
        }
        self.newFace.bestProgrammingLanguage = languages
        
        return false // all inputs are valid
    }
    
    
    // Pop-up alert to display the error message
    func displayAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}

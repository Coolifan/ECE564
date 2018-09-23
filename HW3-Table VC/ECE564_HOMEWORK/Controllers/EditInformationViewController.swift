//
//  EditInformationViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 9/21/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class EditInformationViewController: UIViewController {

    var personBeingEdited = DukePerson()
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var languagesTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var errorOccurred : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPersonalInformation()
        // create the rightBarButtonItem and add a action for future use
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveChanges))
        self.navigationItem.rightBarButtonItem = saveButton
        
        // dismiss the keyboard when tap anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Get and check all inputs when save button is clicked
    @objc func saveChanges() {
        errorOccurred = updatePersonalInformation()
        if errorOccurred == true { // if there is an error, stay on the view
            return
        } else { // if all inputs are valid, proceed to update
            performSegue(withIdentifier: "backToInformationView", sender: self)
        }
    }

    
    // Pass the updated information back
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToInformationView" {
            let informationVC = segue.destination as! InformationViewController
            informationVC.person = self.personBeingEdited
        }
    }
    
    
    // Display all the old information
    func loadPersonalInformation() {
        self.firstNameTextField.text = personBeingEdited.firstName
        self.lastNameTextField.text = personBeingEdited.lastName
        self.genderTextField.text = personBeingEdited.gender == .Male ? "Male" : "Female"
        switch personBeingEdited.role {
        case .Professor:
            self.roleTextField.text = "Professor"
        case .TA:
            self.roleTextField.text = "TA"
        case .Student:
            self.roleTextField.text = "Student"
        }
        self.fromTextField.text = personBeingEdited.whereFrom
        self.degreeTextField.text = personBeingEdited.degree
        self.hobbiesTextField.text = personBeingEdited.hobbies.joined(separator: ", ")
        self.languagesTextField.text = personBeingEdited.bestProgrammingLanguage.joined(separator: ", ")
        self.avatarImageView.image = personBeingEdited.gender == .Male ? UIImage(named: "male.png") : UIImage(named: "female.png")
    }
    
    
    // Get and check all inputs
    func updatePersonalInformation() -> Bool {
        if  (self.genderTextField.text?.isEmpty)! || (self.firstNameTextField.text?.isEmpty)! || (self.degreeTextField.text?.isEmpty)! || (self.roleTextField.text?.isEmpty)! || (self.hobbiesTextField.text?.isEmpty)! || (self.languagesTextField.text?.isEmpty)! {
            displayAlertMessage(title: "ERROR!", message: "All fields are required!")
            return true
        }
        
        self.personBeingEdited.whereFrom = self.fromTextField.text!
        self.personBeingEdited.fullName = self.personBeingEdited.firstName + " " + self.personBeingEdited.lastName
        
        if self.genderTextField.text == "Male" {
            self.personBeingEdited.gender = .Male
        } else if self.genderTextField.text == "Female" {
            self.personBeingEdited.gender = .Female
        } else {
            displayAlertMessage(title: "ERROR!", message: "Invalid gender!")
            return true
        }
        
        if self.roleTextField.text == "Student" {
            self.personBeingEdited.role = .Student
        } else if self.roleTextField.text == "TA" {
            self.personBeingEdited.role = .TA
        } else if self.roleTextField.text == "Professor" {
            self.personBeingEdited.role = .Professor
        } else {
            displayAlertMessage(title: "ERROR!", message: "Invalid role!")
            return true
        }
        
        switch self.degreeTextField.text {
        case "MS":
            self.personBeingEdited.degree = "MS"
        case "BS":
            self.personBeingEdited.degree = "BS"
        case "PhD":
            self.personBeingEdited.degree = "PhD"
        case "MENG":
            self.personBeingEdited.degree = "MENG"
        case "NA":
            self.personBeingEdited.degree = "NA"
        default:
            self.personBeingEdited.degree = "Other"
        }
        
        let hobbies: [String] = hobbiesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
        if hobbies.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 hobbies!")
            return true
        }
        self.personBeingEdited.hobbies = hobbies
        
        let languages: [String] = languagesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
        if languages.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 languages!")
            return true
        }
        self.personBeingEdited.bestProgrammingLanguage = languages
        
        return false // all inputs are valid
    }
    
    
    // Pop-up alert to display error messages
    func displayAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

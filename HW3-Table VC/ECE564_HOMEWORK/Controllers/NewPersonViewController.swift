//
//  NewPersonViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 9/20/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class NewPersonViewController: UIViewController {
    
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
    
    var errorOccurred: Bool = false
    
    @IBOutlet weak var addButton: UIButton!
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if sender as? UIButton == self.addButton {
            return errorOccurred ? false : true
        }
        return true
    }
    
    func getPersonalInformation() -> Bool {
        
        if (self.firstNameTextField.text?.isEmpty)! || (self.lastNameTextField.text?.isEmpty)! || (self.genderTextField.text?.isEmpty)! || (self.fromTextField.text?.isEmpty)! || (self.degreeTextField.text?.isEmpty)! || (self.roleTextField.text?.isEmpty)! || (self.hobbiesTextField.text?.isEmpty)! || (self.languagesTextField.text?.isEmpty)! {
            
            // alert!
            displayAlertMessage(title: "ERROR!", message: "All fields are required!")
            return true
        }
        
        for person in self.people {
            if person.lastName == self.lastNameTextField.text && person.firstName == self.firstNameTextField.text {
                // alert!
                displayAlertMessage(title: "ERROR!", message: "\(person.firstName) \(person.lastName) is already in the class!")
                return true
            }
        }
        

        // all the text fields have input
        self.newFace.firstName = self.firstNameTextField.text!
        self.newFace.lastName = self.lastNameTextField.text!
        self.newFace.whereFrom = self.fromTextField.text!
        self.newFace.fullName = self.newFace.firstName + " " + self.newFace.lastName
        
        if self.genderTextField.text == "Male" {
            self.newFace.gender = .Male
        } else if self.genderTextField.text == "Female" {
            self.newFace.gender = .Female
        } else {
            // alert!
            displayAlertMessage(title: "ERROR!", message: "Invalid gender!")
            return true
        }
        
        if self.roleTextField.text == "Student" {
            self.newFace.role = .Student
        } else if self.roleTextField.text == "TA" {
            self.newFace.role = .TA
        } else if self.roleTextField.text == "Professor" {
            self.newFace.role = .Professor
        } else {
            // alert!
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
            self.newFace.degree = "Other"
        }
        
        let hobbies: [String] = hobbiesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
        if hobbies.count > 3 {
            // alert!
            displayAlertMessage(title: "ERROR!", message: "Up to 3 hobbies!")
            return true
        }
        self.newFace.hobbies = hobbies
        
        let languages: [String] = languagesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
        if languages.count > 3 {
            //alert!
            displayAlertMessage(title: "ERROR!", message: "Up to 3 languages!")
            return true
            
        }
        self.newFace.bestProgrammingLanguage = languages
        
        return false
    }
    
    func displayAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    

}

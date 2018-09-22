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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPersonalInformation()
        // dismiss the keyboard when tap anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as! UIBarButtonItem) == self.saveButton {
            let informationVC = segue.destination as! InformationViewController
            updatePersonalInformation()
            informationVC.person = self.personBeingEdited
        }
    }
    
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
    
    func updatePersonalInformation() {
        if  self.genderTextField.text == nil || self.firstNameTextField.text == nil || self.degreeTextField.text == nil || self.roleTextField.text == nil || self.hobbiesTextField.text == nil || self.languagesTextField.text == nil {
            return
            // alert!
        } else {
            self.personBeingEdited.firstName = self.firstNameTextField.text!
            self.personBeingEdited.lastName = self.lastNameTextField.text!
            self.personBeingEdited.whereFrom = self.fromTextField.text!
            self.personBeingEdited.fullName = self.personBeingEdited.firstName + " " + self.personBeingEdited.lastName
            
            if self.genderTextField.text == "Male" {
                self.personBeingEdited.gender = .Male
            } else if self.genderTextField.text == "Female" {
                self.personBeingEdited.gender = .Female
            } else {
                // invalid gender
            }
            
            if self.roleTextField.text == "Student" {
                self.personBeingEdited.role = .Student
            } else if self.roleTextField.text == "TA" {
                self.personBeingEdited.role = .TA
            } else if self.roleTextField.text == "Professor" {
                self.personBeingEdited.role = .Professor
            } else {
                // invalid role
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
            case "":
                return
            // error
            default:
                self.personBeingEdited.degree = "Other"
            }
            
            let hobbies: [String] = hobbiesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
            if hobbies.count > 3 {
                // error handling
                return
            }
            self.personBeingEdited.hobbies = hobbies
            
            let languages: [String] = languagesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
            if languages.count > 3 {
                //error handling
                return
            }
            self.personBeingEdited.bestProgrammingLanguage = languages
            
            
        }
    }



}

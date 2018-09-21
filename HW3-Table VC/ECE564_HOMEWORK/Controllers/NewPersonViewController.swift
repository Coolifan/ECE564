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
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var languagesTextField: UITextField!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (sender as! UIBarButtonItem) != self.addButton {
            return
        }
        if self.firstNameTextField.text == nil || self.lastNameTextField.text == nil || self.genderTextField.text == nil || self.firstNameTextField.text == nil || self.degreeTextField.text == nil || self.roleTextField.text == nil || self.hobbiesTextField.text == nil || self.languagesTextField.text == nil {
            return
            // alert!
        } else { // all the text fields have input
            self.newFace.firstName = self.firstNameTextField.text!
            self.newFace.lastName = self.lastNameTextField.text!
            self.newFace.whereFrom = self.fromTextField.text!
            self.newFace.fullName = self.newFace.firstName + " " + self.newFace.lastName
            
            if self.genderTextField.text == "Male" {
                self.newFace.gender = .Male
            } else if self.genderTextField.text == "Female" {
                self.newFace.gender = .Female
            } else {
                // invalid gender
            }
            
            if self.roleTextField.text == "Student" {
                self.newFace.role = .Student
            } else if self.roleTextField.text == "TA" {
                self.newFace.role = .TA
            } else if self.roleTextField.text == "Professor" {
                self.newFace.role = .Professor
            } else {
                // invalid role
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
            case "":
                return
                // error
            default:
                self.newFace.degree = "Other"
            }
            
            let hobbies: [String] = hobbiesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
            if hobbies.count > 3 {
                // error handling
                return
            }
            self.newFace.hobbies = hobbies
            
            let languages: [String] = languagesTextField.text!.components(separatedBy: ", ").filter({$0 != ""})
            if languages.count > 3 {
                //error handling
                return
            }
            self.newFace.bestProgrammingLanguage = languages
        }
        
    }
    

}

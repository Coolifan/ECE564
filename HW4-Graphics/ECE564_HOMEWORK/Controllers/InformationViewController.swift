//
//  InformationViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 9/21/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    var person = DukePerson()
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var languagesTextField: UITextField!
    
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var teamLabel: UILabel!

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var flipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPersonalInformation()
        
        if firstNameTextField.text != "Yifan" && lastNameTextField.text != "Li" {
            flipButton.isHidden = true
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Display a person's detailed information
    func loadPersonalInformation() {
        self.firstNameTextField.text = person.firstName
        self.lastNameTextField.text = person.lastName
        self.genderTextField.text = person.gender == .Male ? "Male" : "Female"
        switch person.role {
        case .Professor:
            self.roleTextField.text = "Professor"
            self.teamLabel.isHidden = true
            self.teamTextField.isHidden = true
        case .TA:
            self.roleTextField.text = "TA"
            self.teamLabel.isHidden = true
            self.teamTextField.isHidden = true
        case .Student:
            self.roleTextField.text = "Student"
            self.teamLabel.isHidden = false
            self.teamTextField.isHidden = false
            self.teamTextField.text = person.team
        }
        self.fromTextField.text = person.whereFrom
        self.degreeTextField.text = person.degree
        self.hobbiesTextField.text = person.hobbies.joined(separator: ", ")
        self.languagesTextField.text = person.bestProgrammingLanguage.joined(separator: ", ")
        self.avatarImageView.image = person.gender == .Male ? UIImage(named: "male.png") : UIImage(named: "female.png")
    
        // Remember to uncheck "User Interaction Enabled" for UITextFields in storyboard to be in "View Only" mode
    }
    
    
    // Pass the data to editInformationVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "flipSide" {
            return
        } else if (sender as! UIBarButtonItem) == self.editButton {
            let targetVC = segue.destination as! EditInformationViewController
            targetVC.personBeingEdited = person
        }  else { // if clicked Cancel
            return
        }
    }
    
    
    // Update a person's information if all inputs are valid
    var personEditted = DukePerson()
    @IBAction func returnFromEditInformationView(segue:UIStoryboardSegue) {
        let source: EditInformationViewController = segue.source as! EditInformationViewController
        personEditted = source.personBeingEdited
        let errorOccurred: Bool = source.errorOccurred
        if errorOccurred == false {
            self.person = source.personBeingEdited
        }
        loadPersonalInformation()
    }
    
    @IBAction func returnFromDrawingView(segue: UIStoryboardSegue) {
    
    }
    

}

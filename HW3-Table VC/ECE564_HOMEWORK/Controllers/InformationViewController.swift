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
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.firstNameTextField.text = person.firstName
        self.lastNameTextField.text = person.lastName
        self.genderTextField.text = person.gender == .Male ? "Male" : "Female"
        switch person.role {
        case .Professor:
            self.roleTextField.text = "Professor"
        case .TA:
            self.roleTextField.text = "TA"
        case .Student:
            self.roleTextField.text = "Student"
        }
        self.fromTextField.text = person.whereFrom
        self.degreeTextField.text = person.degree
        self.hobbiesTextField.text = person.hobbies.joined(separator: ", ")
        self.languagesTextField.text = person.bestProgrammingLanguage.joined(separator: ", ")
        self.avatarImageView.image = person.gender == .Male ? UIImage(named: "male.png") : UIImage(named: "female.png")
        
        // Remember to uncheck "User Interaction Enabled" for UITextFields in storyboard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

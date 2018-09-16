//
//  ViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 9/9/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var Information: UIView!
    
    var firstNameTextView: UITextField!
    var lastNameTextView: UITextField!
    var genderTextView: UITextField!
    var roleTextView: UITextField!
    var fromTextView: UITextField!
    var degreeTextView: UITextField!
    var hobbiesTextView: UITextField!
    var languagesTextView: UITextField!
    var descriptionView: UILabel!
    var addButtonView: UIButton!
    var findButtonView: UIButton!
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Information = self.view
        // Add all the subviews
        addLabelView(text: "First: ", x: 10, y: 30, width: 100, height: 30)
        addLabelView(text: "Last: ", x: 10, y: 65, width: 100, height: 30)
        addLabelView(text: "Gender: ", x: 10, y: 100, width: 100, height: 30)
        addLabelView(text: "Role: ", x: 10, y: 135, width: 100, height: 30)
        addLabelView(text: "From: ", x: 10, y: 170, width: 100, height: 30)
        addLabelView(text: "Degree: ", x: 10, y: 205, width: 100, height: 30)
        addLabelView(text: "Hobbies: ", x: 10, y: 240, width: 100, height: 30)
        addLabelView(text: "Languages: ", x: 10, y: 275, width: 100, height: 30)
        
        firstNameTextView = addTextView(placeholder: " First name", x: 130, y: 30, width: 235, height: 30)
        lastNameTextView = addTextView(placeholder: " Last name", x: 130, y: 65, width: 235, height: 30)
        genderTextView = addTextView(placeholder: " Male or female", x: 130, y: 100, width: 235, height: 30)
        roleTextView = addTextView(placeholder: " Student, TA, or Professor", x: 130, y: 135, width: 235, height: 30)
        fromTextView = addTextView(placeholder: " Any string of location info", x: 130, y: 170, width: 235, height: 30)
        degreeTextView = addTextView(placeholder: " MS, BS, MENG, PhD, NA, other", x: 130, y: 205, width: 235, height: 30)
        hobbiesTextView = addTextView(placeholder: " Up to 3 hobbies, comma delimited", x: 130, y: 240, width: 235, height: 30)
        languagesTextView = addTextView(placeholder: " Up to 3 programming lang, comma delimited", x: 130, y: 275, width: 235, height: 30)
        
        addButtonView = addButtonView(title: "Add/Update", x: 50, y: 350, width: 100)
        findButtonView = addButtonView(title: "Find", x: 225, y: 350, width: 100)
        addButtonView.addTarget(self, action: #selector(ViewController.pressedAdd(_:)), for: .touchUpInside)
        findButtonView.addTarget(self, action: #selector(ViewController.pressedFind(_:)), for: .touchUpInside)
        
        // the label used to display the information
        descriptionView = UILabel(frame: CGRect(x: 50, y: 375, width: 275, height: 250))
        descriptionView.lineBreakMode = .byWordWrapping
        descriptionView.numberOfLines = 0
        descriptionView.font = UIFont(name: "IowanOldStyle-Roman", size: 15)
        descriptionView.textColor = UIColor.blue
        Information.addSubview(descriptionView)
        
        // the image displayed at the bottom left corner
        imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: self.view.bounds.height - 50, width: 200, height: 30)
        imageView.image = UIImage(named: "ECE_Logo.png")
        Information.addSubview(imageView)
        
        // dismiss the keyboard when tap anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // a function used to quickly add a new UILabel
    func addLabelView(text: String, x: Int, y: Int, width: Int, height: Int) {
        let labelView = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        labelView.text = text
        labelView.font = UIFont(name: "HoeflerText-Regular", size: 20)
        Information.addSubview(labelView)
    }
    
    // a function used to quickly add a new UITextField
    func addTextView(placeholder: String, x: Int, y: Int, width: Int, height: Int) -> UITextField {
        let textView = UITextField(frame: CGRect(x: x, y: y, width: width, height: height))
        textView.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.italicSystemFont(ofSize: 10)
            ])
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.blue.cgColor
        Information.addSubview(textView)
        return textView
    }
    
    // a function used to quickly add a new UIButton
    func addButtonView(title: String, x: Int, y: Int, width: Int) -> UIButton {
        let buttonView = UIButton()
        buttonView.backgroundColor = UIColor.gray
        buttonView.setTitleColor(UIColor.blue, for: .normal)
        buttonView.frame = CGRect(x: x, y: y, width: width, height: 30)
        buttonView.setTitle(title, for: .normal)
        buttonView.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        Information.addSubview(buttonView)
        return buttonView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // the actions when add/update button is clicked
    @objc func pressedAdd(_ sender: UIButton!) {
        let firstName: String = firstNameTextView.text!
        let lastName: String = lastNameTextView.text!
        let from: String = fromTextView.text!
        if (firstName == "" || lastName == "" || from == "") {
            descriptionView.text = "Please fill out all the blanks!"
            descriptionView.textColor = UIColor.red
            return
        }
        
        var gender: Gender = .Male
        if genderTextView.text == "Male" {
            gender = .Male
        } else if genderTextView.text == "Female" {
            gender = .Female
        } else {
            // error handling
            descriptionView.text = "Invalid gender entered."
            descriptionView.textColor = UIColor.red
            return
        }
        
        var role: DukeRole = .Student
        if roleTextView.text == "Student" {
            role = .Student
        } else if roleTextView.text == "TA" {
            role = .TA
        } else if roleTextView.text == "Professor" {
            role = .Professor
        } else {
            // error handling
            descriptionView.text = "Invalid role entered."
            descriptionView.textColor = UIColor.red
            return
        }
        
        var degree: String
        switch degreeTextView.text {
        case "MS":
            degree = "MS"
        case "PhD":
            degree = "PhD"
        case "MENG":
            degree = "MENG"
        case "NA":
            degree = "NA"
        case "":
            descriptionView.text = "No degree info entered."
            descriptionView.textColor = UIColor.red
            return
        default:
            degree = "other"
        }
        
        if hobbiesTextView.text! == "" {
            descriptionView.text = "No hobbies entered."
            descriptionView.textColor = UIColor.red
            return
        }
        let hobbies: [String] = hobbiesTextView.text!.components(separatedBy: ", ").filter({$0 != ""})
        if hobbies.count > 3 {
            // error handling
            descriptionView.text = "Up to 3 hobbies!"
            descriptionView.textColor = UIColor.red
            return
        }
        
        if languagesTextView.text! == "" {
            descriptionView.text = "No languages entered."
            descriptionView.textColor = UIColor.red
            return
        }
        let languages: [String] = languagesTextView.text!.components(separatedBy: ", ").filter({$0 != ""})
        if languages.count > 3 {
            //error handling
            descriptionView.text = "Up to 3 languages!"
            descriptionView.textColor = UIColor.red
            return
        }
        
        
        let newPerson: DukePerson = DukePerson(firstName: firstName, lastName: lastName, whereFrom: from, gender: gender, degree: degree, bestProgrammingLanguage: languages, hobbies: hobbies, role: role)
        
        let fullName = "\(firstName) \(lastName)"
        for i in 0..<roster.count {
            if roster[i].fullName == fullName {
                roster[i] = newPerson
                descriptionView.textColor = UIColor.blue
                descriptionView.text = "\(fullName)'s information has been updated successfully"
                firstNameTextView.text = ""
                lastNameTextView.text = ""
                genderTextView.text = ""
                roleTextView.text = ""
                degreeTextView.text = ""
                fromTextView.text = ""
                hobbiesTextView.text = ""
                languagesTextView.text = ""
                return
            }
        }
        
        roster.append(newPerson)
        descriptionView.textColor = UIColor.blue
        descriptionView.text = "\(fullName) has been added to the class successfully."
        
        firstNameTextView.text = ""
        lastNameTextView.text = ""
        genderTextView.text = ""
        roleTextView.text = ""
        degreeTextView.text = ""
        fromTextView.text = ""
        hobbiesTextView.text = ""
        languagesTextView.text = ""
    }
    
    // the actions when find button is clicked
    @objc func pressedFind(_ sender: UIButton!) {
        if firstNameTextView.text == nil || lastNameTextView.text == nil {
            // error handling
        } else {
            let fullName: String = firstNameTextView.text! + " " + lastNameTextView.text!
            descriptionView.textColor = UIColor.blue
            descriptionView.text = whoIs(fullName)
            firstNameTextView.text = ""
            lastNameTextView.text = ""
            genderTextView.text = ""
            roleTextView.text = ""
            degreeTextView.text = ""
            fromTextView.text = ""
            hobbiesTextView.text = ""
            languagesTextView.text = ""
        }
    }

}



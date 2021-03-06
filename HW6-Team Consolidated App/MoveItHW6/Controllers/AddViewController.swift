//
//  AddViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/3/18.
//  Modified by Zi Xiong, Yifan Li, and Wenchao Zhu on 10/27/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    var browseButton: UIButton!
    
    var errorOccurred: Bool = false
    var cancelPressed: Bool = false
    var hasNewAvatar: Bool = false
    var newPerson = DukePerson()
    var people = [DukePerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newPerson.gender = .Male
        self.newPerson.role = .Student
        self.newPerson.degree = "MS"
        
        // Camera
        avatarImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.takePic))
        avatarImageView.addGestureRecognizer(tapRecognizer)
        
        // button for browsinng local Photo Library
        browseButton = UIButton(frame: CGRect(x: (self.view.bounds.width - 60) / 2, y: self.view.bounds.height - 65, width: 60, height: 20))
        browseButton.backgroundColor = UIColor(red: 48/255, green: 123/255, blue:246/255, alpha: 0.9)
        browseButton.layer.cornerRadius = 9
        browseButton.setTitle("Browse", for: .normal)
        browseButton.setTitleColor(UIColor.white, for: .normal)
        browseButton.titleLabel!.font = UIFont(name: "Helvetica Light", size: 12.0)
        browseButton.addTarget(self, action: #selector(InformationViewController.browsePhotos(_:)), for: .touchUpInside)
        self.view.addSubview(browseButton)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        fromTextField.delegate = self
        hobbiesTextField.delegate = self
        languagesTextField.delegate = self
        teamTextField.delegate = self
    }
    
    // MARK: imagePicker delegate calls
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let im = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        self.dismiss(animated: true) {
            let type = info[UIImagePickerController.InfoKey.mediaType] as? String
            if type != nil {
                switch type! {
                case kUTTypeImage as NSString as String:
                    if im != nil {
                        self.avatarImageView.image = im
                        self.avatarImageView.contentMode = .scaleAspectFit
                    }
                default:break
                }
            }
        }
    }

    // browse local photos library
    @objc func browsePhotos(_ sender: UIButton!) {
        print("Select Picture")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        self.present(picker, animated: true, completion: nil)
    }
    
    //  MARK:  takePic
    @objc func takePic(_ sender: AnyObject) {
        hasNewAvatar = true
        print("Add Picture")
        let cam = UIImagePickerController.SourceType.camera
        let ok = UIImagePickerController.isSourceTypeAvailable(cam)
        if (!ok) {
            print("no camera")
            return
        }
        let desiredType = kUTTypeImage as NSString as String
        let arr = UIImagePickerController.availableMediaTypes(for: cam)
        print(arr!)
        if arr?.index(of: desiredType) == nil {
            print("no capture")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.mediaTypes = [desiredType]
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate

        self.present(picker, animated: true, completion: nil)
    }
    
    //MARK: Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // an error in the save process
            displayAlertMessage(title: "Save error", message: error.localizedDescription)
        } else if hasNewAvatar {
            displayAlertMessage(title: "Saved!", message: "Your image has been saved.")
        }
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
        else {
            if hasNewAvatar {
                UIImageWriteToSavedPhotosAlbum(self.avatarImageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
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
        self.newPerson.team = (self.teamTextField.text!).trimmingCharacters(in: .whitespaces)
        
        let hobbies: [String] = (hobbiesTextField.text!).trimmingCharacters(in: .whitespaces).components(separatedBy: ",").filter({$0 != ""})

        if hobbies.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 hobbies!")
            return true
        }
        self.newPerson.hobbies = hobbies
        
        let languages: [String] = (languagesTextField.text!).trimmingCharacters(in: .whitespaces).components(separatedBy: ",").filter({$0 != ""})

        if languages.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 languages!")
            return true
        }
        self.newPerson.bestProgrammingLanguage = languages
        
        // save avatar as base64 string
        if hasNewAvatar {
            let imgData: Data = self.avatarImageView.image!.jpegData(compressionQuality: 1.0)!
            self.newPerson.pic = imgData.base64EncodedString(options: .endLineWithLineFeed)
        }

        // until this point, all inputs are valid, no error occurred.
        return false
    }
    
    
    // Pop-up alert to display the error message
    func displayAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
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


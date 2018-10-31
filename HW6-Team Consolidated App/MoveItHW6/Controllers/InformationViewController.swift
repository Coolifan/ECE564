//
//  InformationViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/3/18.
//  Modified by Haohong Zhao, Zi Xiong, Wenchao Zhu, and Yifan Li on 10/28/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit
import MobileCoreServices

// protocol used to pass data back to tableViewController
protocol PassDataBack {
    func dataReceived(personEdited: DukePerson)
}

class InformationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var person = DukePerson()
    var delegate: PassDataBack? // will be assigned to the tableVC, who will also receive data from here
    var peopleWithDrawingAnimations = [String]()
    
    var errorOccurred: Bool = false
    var hasNewAvatar: Bool = false
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var languagesTextField: UITextField!
    @IBOutlet weak var teamTextField: UITextField!
    
    @IBOutlet weak var genderSC: UISegmentedControl!
    @IBOutlet weak var roleSC: UISegmentedControl!
    @IBOutlet weak var degreeSC: UISegmentedControl!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    var browseButton: UIButton!
    
    @IBOutlet weak var flipButton: UIButton!
    @IBAction func flipButtonPressed(_ sender: Any) {
            performSegue(withIdentifier: person.firstName, sender: self.flipButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPersonalInformation()
        self.isEditing = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Camera
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
        browseButton.isEnabled = false
        browseButton.isHidden = true
        
        // Flip button is only available to peopleWithDrawingAnimations
        let peopleWithDrawingAnimations = Set<String>(self.peopleWithDrawingAnimations)
        if !peopleWithDrawingAnimations.contains(self.person.fullName) {
            flipButton.isHidden = true
            flipButton.isEnabled = false
        }
        
        // change the navigation bar button item color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Dismiss the keyboard when tapped outside the text fields or return key
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
        self.view.addGestureRecognizer(tapGesture)
        fromTextField.delegate = self
        hobbiesTextField.delegate = self
        languagesTextField.delegate = self
        teamTextField.delegate = self
    }
    
    // MARK: imagePicker delegate calls
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let im = info[.originalImage] as? UIImage
        
        self.dismiss(animated: true) {
            let type = info[.mediaType] as? String
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
            displayAlertMessage(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Toggles the edit button state
        super.setEditing(editing, animated: animated)
        
        if editing {
            // edit mode
            toggleUserInteraction(ifEnabled: true)
            self.browseButton.isEnabled = true
            browseButton.isHidden = false
            self.firstNameTextField.textColor = UIColor.gray
            self.lastNameTextField.textColor = UIColor.gray
            let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.saveButtonPressed(sender:)))
            self.navigationItem.rightBarButtonItem = saveButton
        } else {
            // preview mode
            toggleUserInteraction(ifEnabled: false)
        }
    }
    
    
    @objc func saveButtonPressed(sender: UIBarButtonItem) {
        errorOccurred = getPersonalInformation()
        if errorOccurred == false {
            if hasNewAvatar {
                UIImageWriteToSavedPhotosAlbum(self.avatarImageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            delegate?.dataReceived(personEdited: self.person)
            navigationController?.popViewController(animated: true)
        } else {
            return
        }
    }
    
    
    // Display a person's detailed information
    func loadPersonalInformation() {
        self.firstNameTextField.text = person.firstName
        self.lastNameTextField.text = person.lastName
        self.fromTextField.text = person.whereFrom
        self.person.hobbies = self.person.hobbies.count > 3 ? Array(self.person.hobbies[0..<3]) : self.person.hobbies
        self.hobbiesTextField.text = person.hobbies.joined(separator: ", ")
        self.person.bestProgrammingLanguage = self.person.bestProgrammingLanguage.count > 3 ? Array(self.person.bestProgrammingLanguage[0..<3]) : self.person.bestProgrammingLanguage
        self.languagesTextField.text = person.bestProgrammingLanguage.joined(separator: ", ")
        self.genderSC.selectedSegmentIndex = (person.gender == .Male) ? 0 : 1
        
        if person.pic != "", let imgData = Data(base64Encoded: person.pic, options: .ignoreUnknownCharacters) {
            self.avatarImageView.image = UIImage(data: imgData)
        }
        else {
            self.avatarImageView.image = (person.gender == .Male) ? UIImage(named: "male.png") : UIImage(named: "female.png")
        }

        
        switch person.role {
        case .Professor:
            self.roleSC.selectedSegmentIndex = 1
            self.teamTextField.isEnabled = false
        case .TA:
            self.roleSC.selectedSegmentIndex = 2
            self.teamTextField.isEnabled = false
        case .Student:
            self.roleSC.selectedSegmentIndex = 0
            self.teamTextField.isEnabled = true
            self.teamTextField.text = person.team
        }
        

        switch person.degree {
        case "MS":
            self.degreeSC.selectedSegmentIndex = 0
        case "BS":
            self.degreeSC.selectedSegmentIndex = 1
        case "MENG":
            self.degreeSC.selectedSegmentIndex = 2
        case "PhD":
            self.degreeSC.selectedSegmentIndex = 3
        case "NA":
            self.degreeSC.selectedSegmentIndex = 4
        default:
            self.degreeSC.selectedSegmentIndex = 5
        }
        
    }
    
    
    func toggleUserInteraction(ifEnabled: Bool) {
        self.firstNameTextField.isUserInteractionEnabled = false
        self.lastNameTextField.isUserInteractionEnabled = false
        self.fromTextField.isUserInteractionEnabled = ifEnabled
        self.hobbiesTextField.isUserInteractionEnabled = ifEnabled
        self.languagesTextField.isUserInteractionEnabled = ifEnabled
        self.teamTextField.isUserInteractionEnabled = ifEnabled
        self.genderSC.isUserInteractionEnabled = ifEnabled
        self.roleSC.isUserInteractionEnabled = ifEnabled
        self.degreeSC.isUserInteractionEnabled = ifEnabled
        self.avatarImageView.isUserInteractionEnabled = ifEnabled
    }
    
    
    // Get and check all inputs. Return true if there is an error
    func getPersonalInformation() -> Bool {
        if  (self.fromTextField.text?.isEmpty)! ||   (self.hobbiesTextField.text?.isEmpty)! || (self.languagesTextField.text?.isEmpty)! {
            displayAlertMessage(title: "ERROR!", message: "All fields are required!")
            return true
        }
    
        self.person.whereFrom = (self.fromTextField.text!).trimmingCharacters(in: .whitespaces)
        self.person.gender = (self.genderSC.selectedSegmentIndex == 0) ? .Male : .Female
        
        switch self.roleSC.selectedSegmentIndex {
        case 1:
            self.person.role = .Professor
        case 2:
            self.person.role = .TA
        default:
            self.person.role = .Student
        }

        self.person.team = (self.person.role == .Student) ? (self.teamTextField.text!).trimmingCharacters(in: .whitespaces) : ""
        
        switch self.degreeSC.selectedSegmentIndex {
        case 0:
            self.person.degree = "MS"
        case 1:
            self.person.degree = "BS"
        case 2:
            self.person.degree = "MENG"
        case 3:
            self.person.degree = "PhD"
        case 4:
            self.person.degree = "NA"
        default:
            self.person.degree = "other"
        }
        
        let hobbies: [String] = (hobbiesTextField.text!).trimmingCharacters(in: .whitespaces).components(separatedBy: ",").filter({$0 != ""})
        if hobbies.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 hobbies!")
            return true
        }
        self.person.hobbies = hobbies
        
        let languages: [String] = (languagesTextField.text!).trimmingCharacters(in: .whitespaces).components(separatedBy: ",").filter({$0 != ""})
        if languages.count > 3 {
            displayAlertMessage(title: "ERROR!", message: "Up to 3 languages!")
            return true
        }
        self.person.bestProgrammingLanguage = languages
        
        // save avatar as base64 string
        let imgData: Data = self.avatarImageView.image!.jpegData(compressionQuality: 1.0)!
        self.person.pic = imgData.base64EncodedString(options: .endLineWithLineFeed)
        
        // until this point, all inputs are valid, no error occurred.
        return false
    }
    
    
    // Enable the team info input field
    @IBAction func roleSCTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.teamTextField.isEnabled = true
            self.teamTextField.isUserInteractionEnabled = true
        } else  {
            self.teamTextField.isEnabled = false
            self.teamTextField.isUserInteractionEnabled = false
        }
    }
    
    // End editing when tapped outside the text fields
    @objc func tappedOutside() {
        fromTextField.endEditing(true)
        languagesTextField.endEditing(true)
        hobbiesTextField.endEditing(true)
    }
    
    
    // Pop-up alert to display the error message
    func displayAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Segue to/from Drawing View
    @IBAction func returnFromDrawingView(segue: UIStoryboardSegue) {}
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let segue = UnwindFlipSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    
}

extension InformationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

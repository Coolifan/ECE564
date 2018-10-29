//
//  PersonCell.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/3/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var thisPerson: DukePerson? {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI() {
        avatarImageView.image = thisPerson?.gender == .Male ? UIImage(named: "male.png") : UIImage(named: "female.png")
        nameLabel.text = (thisPerson?.firstName.uppercased())! + " " + (thisPerson?.lastName.uppercased())!
        descriptionLabel.text = thisPerson?.description
    }
    
}

//
//  PersonTableViewCell.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 9/20/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    // Each personCell consists of 3 parts: An image/avatar, a text label for name, and a text label for description

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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

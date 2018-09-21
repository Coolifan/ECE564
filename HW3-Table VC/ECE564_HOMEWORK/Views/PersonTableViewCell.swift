//
//  PersonTableViewCell.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 9/20/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

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
        nameLabel.text = (thisPerson?.firstName)! + " " + (thisPerson?.lastName)!
        descriptionLabel.text = thisPerson?.description
    }
    
    
}

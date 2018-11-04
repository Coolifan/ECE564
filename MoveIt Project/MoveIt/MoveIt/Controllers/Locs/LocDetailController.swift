//
//  LocDetailController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/3/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit

class LocDetailController: UIViewController {
    
    var loc: Location = Location(name: "null")

    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading LocDetailView...")
        print("Location is \(loc.name)")
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 20, right: 5))
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}

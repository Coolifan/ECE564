//
//  GoMapAppButton.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/14/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit

class GoMapAppButton: UIButton {
    let decorationImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "circle-arrow-black").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalTo: iv.heightAnchor)
        return iv
    }()
    
    let arrowIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalTo: iv.heightAnchor)
        return iv
    }()
    
    let textLabel: UILabel = {
       let label = UILabel()
        label.text = "Get Directions"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
//    MARK: - init, setupUI
    fileprivate func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [decorationImage, textLabel, UIView(), arrowIcon])
//        let tap gesture propogate to the button
        stackView.isUserInteractionEnabled = false
        addSubview(stackView)
        stackView.fillSuperView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

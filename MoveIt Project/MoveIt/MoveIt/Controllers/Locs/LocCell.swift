//
//  LocCell.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/3/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit

class LocCell: UITableViewCell {
    let sceneImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .steelGray
        let highLayoutProperty: Float = 900.0
        iv.setContentHuggingPriority(UILayoutPriority(rawValue: highLayoutProperty), for: .vertical)
        iv.setContentCompressionResistancePriority(UILayoutPriority(rawValue: highLayoutProperty), for: .vertical)
        return iv
    }()
    
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .emeraldGreen
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        let lowLayoutProperty: Float = 100.0
        label.setContentHuggingPriority(UILayoutPriority(rawValue: lowLayoutProperty), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: lowLayoutProperty), for: .horizontal)
        return label
    }()
    
    let arrowIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .carrotOrange
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Loading LocCell...")
        setupUI()
    }
    
    fileprivate func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [sceneImageStackView(), descriptionLabel, arrowIconStackView()])
        stackView.layoutMargins = .init(top: 3, left: 3, bottom: 3, right: 3)
        stackView.alignment = .top
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 3
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        NSLayoutConstraint.activate([
            sceneImage.widthAnchor.constraint(equalToConstant: 100),
            sceneImage.heightAnchor.constraint(equalToConstant: 100 * (9.0 / 16.0) ),
            arrowIcon.widthAnchor.constraint(equalToConstant: 25),
            arrowIcon.heightAnchor.constraint(equalToConstant: 25),
            arrowIcon.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
            ])
    }
    
    fileprivate func sceneImageStackView() -> UIStackView {
        let spaceView = UIView()
        let stackView = UIStackView(arrangedSubviews: [sceneImage, spaceView])
        stackView.axis = .vertical
        return stackView
    }
    
    fileprivate func arrowIconStackView() -> UIStackView {
        let spaceViewTop = UIView()
        spaceViewTop.backgroundColor = .blue
        let stackView = UIStackView(arrangedSubviews: [spaceViewTop, arrowIcon])
        stackView.axis = .vertical
        return stackView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

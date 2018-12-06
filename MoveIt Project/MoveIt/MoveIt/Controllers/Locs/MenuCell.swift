//
//  menuCell.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/3/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import Alamofire

class MenuCell: UITableViewCell {
    //    MARK: - data source
    var menu: menuItem? {
        didSet {
            nameLabel.text = menu?.name
            if let url = menu?.imageUrl {
                downloadPhoto(using: url)
            }
            guard let carb = menu?.nutrition["carbohydrates"],
                  let fats = menu?.nutrition["fats"],
                  let sugars = menu?.nutrition["sugars"],
                let cal = menu?.nutrition["calories"] else { return }
            self.cal.text = "\(cal) kcal"
            self.fats.text = "\(fats) g"
            self.sugars.text = "\(sugars) g"
            self.carb.text = "\(carb) g"
        }
    }
    
    //    MARK: - photo download
    fileprivate func downloadPhoto(using imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to download location image<##>", err)
                return
            }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.sceneImage.image = image
            }
            }.resume()
    }
    
    //    MARK: - UI component
    let sceneImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .steelGray
        let highLayoutProperty: Float = 900.0
        iv.setContentHuggingPriority(UILayoutPriority(rawValue: highLayoutProperty), for: .vertical)
        iv.setContentCompressionResistancePriority(UILayoutPriority(rawValue: highLayoutProperty), for: .vertical)
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        let lowLayoutProperty: Float = 100.0
        label.setContentHuggingPriority(UILayoutPriority(rawValue: lowLayoutProperty), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: lowLayoutProperty), for: .horizontal)
        return label
    }()
    
    let calTag: UILabel = {
       let label = UILabel()
        label.text = "Calories:    "
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    }()
    
    let cal: UILabel = {
        let label = UILabel()
        label.text = "Calories:"
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    }()
    
    let fatsTag: UILabel = {
        let label = UILabel()
        label.text = "Fats:"
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    }()
    
    let fats: UILabel = {
        let label = UILabel()
        label.text = "Fats:"
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    }()
    
    let sugarsTag: UILabel = {
        let label = UILabel()
        label.text = "Sugars:"
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    }()
    
    let sugars: UILabel = {
        let label = UILabel()
        label.text = "Sugars:"
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    }()
    
    let carbTag: UILabel = {
        let label = UILabel()
        label.text = "Carbohydrates:"
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    }()
    
    let carb: UILabel = {
        let label = UILabel()
        label.text = "Carbohydrates:"
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    }()
    
    let nutritionStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    
    let arrowIcon: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    //    MARK: - init, setupUI
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    fileprivate func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [sceneImageStackView(), textsStackView(), arrowIconStackView()])
        stackView.layoutMargins = .init(top: 3, left: 3, bottom: 3, right: 3)
        stackView.alignment = .top
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 3
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 4, bottom: 8, right: 4))
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
        let stackView = UIStackView(arrangedSubviews: [spaceViewTop, arrowIcon])
        stackView.axis = .vertical
        return stackView
    }
    
    fileprivate func textsStackView() -> UIStackView {
        setupNutritionStackView()
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nutritionStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }
    
    fileprivate func nutritionStackLineOne() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [calTag, cal, fatsTag, fats])
        stackView.distribution = .equalSpacing
        return stackView
    }
    
    fileprivate func nutritionStackLineTwo() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [carbTag, carb, sugarsTag, sugars])
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }
    
    fileprivate func setupNutritionStackView() {
        nutritionStackView.addArrangedSubview(nutritionStackLineOne())
        nutritionStackView.addArrangedSubview(nutritionStackLineTwo())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

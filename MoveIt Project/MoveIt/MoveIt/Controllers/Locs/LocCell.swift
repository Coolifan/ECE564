//
//  LocCell.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/3/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import Alamofire

class LocCell: UITableViewCell {
//    MARK: - data source
    var location: LocationInfo? {
        didSet {
            nameLabel.text = location?.name
            if let imageURLParameters = location?.imageURLParameters {
                downloadPhoto(using: imageURLParameters)
            }
        }
    }
//    MARK: - photo download
    fileprivate func downloadPhoto(using urlParameters: [String: String]) {
        guard let urlString = generateImageURLString(using: urlParameters) else { return }
        guard let url = URL(string: urlString) else { return }
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
    
    private func generateImageURLString(using parameters: [String: String]) -> String? {
        guard let maxWidth = parameters["maxwidth"] else { return nil }
        guard let photoReference = parameters["photoreference"] else { return nil }
        return "\(GoogleAPI.image)?maxwidth=\(maxWidth)&photoreference=\(photoReference)&key=\(GoogleAPI.key)"
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
        label.backgroundColor = .emeraldGreen
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        let lowLayoutProperty: Float = 100.0
        label.setContentHuggingPriority(UILayoutPriority(rawValue: lowLayoutProperty), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: lowLayoutProperty), for: .horizontal)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "some description..."
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = .carrotOrange
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        let lowLayoutProperty: Float = 100.0
        label.setContentHuggingPriority(UILayoutPriority(rawValue: lowLayoutProperty), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: lowLayoutProperty), for: .horizontal)
        return label
    }()
    
    let arrowIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .carrotOrange
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
        spaceViewTop.backgroundColor = .blue
        let stackView = UIStackView(arrangedSubviews: [spaceViewTop, arrowIcon])
        stackView.axis = .vertical
        return stackView
    }
    
    fileprivate func textsStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

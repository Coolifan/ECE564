//
//  HomeViewController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/2/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    let goalBtn = BannerButton()
    let streakBtn = BannerButton()
    
    @IBOutlet weak var bannersContainer: UIView!
    @IBOutlet weak var rBtn: UIButton!
    @IBOutlet weak var gBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupGRButtons() {
        rBtn.layer.cornerRadius = 16
        rBtn.backgroundColor = .carrotOrange
        rBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        gBtn.layer.cornerRadius = 16
        gBtn.backgroundColor = .emeraldGreen
        gBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        
        rBtn.addTarget(self, action: #selector(openRLocsView), for: .touchUpInside)
        gBtn.addTarget(self, action: #selector(openGLocsView), for: .touchUpInside)
    }
    
    @objc fileprivate func openRLocsView() {
        performSegue(withIdentifier: "toLocs", sender: rBtn)
    }
    
    @objc fileprivate func openGLocsView() {
        performSegue(withIdentifier: "toLocs", sender: gBtn)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let btn = sender as? UIButton else { return }
        guard let locsVC = segue.destination as? LocsController else { return }
        locsVC.locationType = (btn === rBtn) ? "restaurant" : "garden"
    }
    
    fileprivate func setupUI() {
        setupGRButtons()
        setupBannerButtons()
    }
    
    fileprivate func setupBannerButtons() {
        setupBannerButtonsUI()
        arrangeBannerButtons()
    }
    
    fileprivate func setupBannerButtonsUI() {
        goalBtn.bannerLabel.font = UIFont.italicSystemFont(ofSize: 16)
        goalBtn.addTarget(self, action: #selector(openGoalView), for: .touchUpInside)
        streakBtn.bannerLabel.font = UIFont.italicSystemFont(ofSize: 16)
        streakBtn.addTarget(self, action: #selector(openGoalView), for: .touchUpInside)
        goalBtn.text = "Only 2% from your final goal"
        goalBtn.icon = #imageLiteral(resourceName: "arrow")
        streakBtn.text = "On a 5 day streak of meeting daily goal! Good Job!"
        streakBtn.icon = #imageLiteral(resourceName: "arrow")
    }
    
    fileprivate func arrangeBannerButtons() {
        let stackView = UIStackView(arrangedSubviews: [goalBtn, streakBtn])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: bannersContainer.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: bannersContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: bannersContainer.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bannersContainer.bottomAnchor)
            ])
    }
    
    @objc fileprivate func openGoalView() {
        let goalController = GoalController()
        navigationController?.pushViewController(goalController, animated: true)
    }
}

class BannerButton: UIButton {
    var text: String? {
        didSet {
            bannerLabel.text = text
        }
    }
    
    var icon: UIImage? {
        didSet {
            arrowIcon.image = icon?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    let bannerLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let arrowIcon: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .steelGray
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bannerLabel)
        addSubview(arrowIcon)
        
        NSLayoutConstraint.activate([
            bannerLabel.topAnchor.constraint(equalTo: topAnchor),
            bannerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            bannerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70)
            ])
        
        NSLayoutConstraint.activate([
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
            arrowIcon.widthAnchor.constraint(equalToConstant: 30),
            arrowIcon.heightAnchor.constraint(equalToConstant: 30),
            arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

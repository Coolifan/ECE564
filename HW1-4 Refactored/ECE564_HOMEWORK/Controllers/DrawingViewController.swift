//
//  DrawingViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/4/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit
import AVFoundation

class DrawingViewController: UIViewController {

    @IBOutlet weak var minionImage: UIImageView!
    @IBOutlet weak var soccerImage: UIImageView!
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "goal", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print(error)
        }
        self.view.bringSubview(toFront: soccerImage)
        setGraphicContext()
        animate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func animate() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        UIView.animate(withDuration: 3, animations: {
            self.soccerImage.frame.origin.y -= 100
            self.soccerImage.frame.origin.x += 100
            let tr = CGAffineTransform.identity.rotated(by: .pi/2)
            self.soccerImage.transform = tr
            self.soccerImage.frame.size = CGSize(width: screenSize.width * 0.2, height: screenSize.height * 0.2)
            
            self.minionImage.frame.origin.y -= 100
            self.minionImage.frame.origin.x += 100
        }) {_ in
            UIView.animateKeyframes(withDuration: 1, delay: 0.25, animations: {
                self.soccerImage.frame.origin.x -= 100
                self.soccerImage.frame.origin.y -= 200
                let tr = CGAffineTransform.identity.rotated(by: .pi/4)
                self.soccerImage.transform = tr
                self.soccerImage.frame.size = CGSize(width: screenSize.width * 0.1, height: screenSize.height * 0.1)
                self.minionImage.frame.origin.y -= 100
                self.minionImage.frame.origin.x -= 70
                self.minionImage.transform = CGAffineTransform.identity.rotated(by: -.pi/8)
            })
        }
        
    }
    
    func setGraphicContext() {
        let rectPath = UIBezierPath()
        rectPath.move(to: CGPoint(x: 100, y: 150))
        rectPath.addLine(to: CGPoint(x: 300, y: 150))
        rectPath.addLine(to: CGPoint(x: 300, y: 250))
        rectPath.addLine(to: CGPoint(x: 100, y: 250))
        rectPath.close()
        
        let rect = CAShapeLayer()
        rect.path = rectPath.cgPath
        rect.fillColor = UIColor.white.cgColor
        rect.strokeColor = UIColor.blue.cgColor
        rect.opacity = 0.5
        self.view.layer.addSublayer(rect)
        
        let circle = CAShapeLayer()
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: CGPoint(x: 30, y:30), radius: 100, startAngle: 0, endAngle: 360, clockwise: true)
        circle.path = circlePath.cgPath
        circle.fillColor = UIColor.yellow.cgColor
        self.view.layer.addSublayer(circle)
    }


}

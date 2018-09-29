//
//  DrawingViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 9/29/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit
import AVFoundation

class DrawingViewController: UIViewController {

    @IBOutlet weak var soccerImage: UIImageView!
    @IBOutlet weak var minionImage: UIImageView!
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

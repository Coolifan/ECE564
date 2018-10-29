//
//  HobbyViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Zi Xiong on 10/2/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class XiongAnimationController: UIViewController {
    var mainView: UIView!
    let earth = UIImageView()
    let sun = DrawingSunView()
    var runningMan = UIImageView()
    
    var words: UILabel!
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = self.view
        mainView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        let superFrame = self.view.frame
        
        earth.frame = CGRect(x: -(800 - superFrame.width) / 2, y: superFrame.height - 300, width: 800, height: 800)
        earth.image = UIImage(named: "earth_model.jpg")
        mainView.addSubview(self.earth)
        
        sun.frame = CGRect(x: 400, y: 100, width: 200, height: 200)
        sun.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        mainView.addSubview(self.sun)
        
        self.drawTitle("I love jogging!")
        self.runningAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.playMusic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.rotateEarth()
        self.sunMove()
        self.rotateSun()
        self.earth.rotate360Degrees()
    }
    
    func runningAnimation() {
        runningMan.frame = CGRect(x: mainView.bounds.width / 2 - 75, y: 400, width: 150, height: 150)
        
        let r1 = UIImage(named: "run1.png")!
        let r2 = UIImage(named: "run2.png")!
        let r3 = UIImage(named: "run3.png")!
        let r4 = UIImage(named: "run4.png")!
        let r5 = UIImage(named: "run5.png")!
        let r6 = UIImage(named: "run6.png")!
        runningMan.animationImages = [r1, r2, r3, r4, r5, r6]
        runningMan.animationDuration = 1.2
        runningMan.startAnimating()
        self.mainView.addSubview(runningMan)
    }
    
    func sunMove() {
        UIImageView.animate(withDuration: 10, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.sun.center.x = -50
        }, completion: nil)
    }
    
    func rotateSun() {
        UIImageView.animate(withDuration: 4, delay: 0, options: [.repeat, .curveLinear, .autoreverse], animations: {
            self.sun.transform = CGAffineTransform(rotationAngle: -.pi).scaledBy(x: 0.85, y: 0.85)
        }, completion: nil)
    }
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "Xiong_bgm", withExtension: "mp3") else { return }
 
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let aPlayer = audioPlayer else { return }
            aPlayer.play()
            print("Great music!")
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func drawTitle(_ content: String) {
        words = UILabel(frame: CGRect(x: mainView.bounds.width / 2 - 100, y: 50, width: 200, height: 35))
        let myFont = UIFont(name: "American Typewriter", size: 22.0)
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 5
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        let titleAttributes = [
            NSAttributedString.Key.shadow: myShadow,
            NSAttributedString.Key.font: myFont,
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.backgroundColor: UIColor.cyan,
            ]
        let titleString = NSAttributedString(string: content, attributes: (titleAttributes as Any as! [NSAttributedString.Key : Any]))
        words.attributedText = titleString
        mainView.addSubview(words)
    }

}

extension UIImageView {
    func rotate360Degrees(duration: CFTimeInterval = 8) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(-Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

class DrawingSunView: UIView {
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let p = UIBezierPath(ovalIn: CGRect(x: 60, y: 60, width: 80, height: 80))
        UIColor(red: 252/255, green: 212/255, blue: 64/255, alpha: 1.0).setFill()
        p.fill()
        self.drawLight(start: CGPoint(x: 55, y: 100), end: CGPoint(x: 25, y: 100))
        self.drawLight(start: CGPoint(x: 145, y: 100), end: CGPoint(x: 175, y: 100))
        self.drawLight(start: CGPoint(x: 100, y: 55), end: CGPoint(x: 100, y: 25))
        self.drawLight(start: CGPoint(x: 100, y: 145), end: CGPoint(x: 100, y: 175))
        self.drawLight(start: CGPoint(x: 70, y: 70), end: CGPoint(x: 50, y: 50))
        self.drawLight(start: CGPoint(x: 130, y: 70), end: CGPoint(x: 150, y: 50))
        self.drawLight(start: CGPoint(x: 70, y: 130), end: CGPoint(x: 50, y: 150))
        self.drawLight(start: CGPoint(x: 130, y: 130), end: CGPoint(x: 150, y: 150))
    }
    
    func drawLight(start: CGPoint, end: CGPoint) {
        let l = UIBezierPath()
        let color:UIColor = UIColor(red: 230/255, green: 212/255, blue: 64/255, alpha: 0.8)
        color.set()
        l.lineWidth = 10
        
        l.move(to: start)
        l.addLine(to: end)
        
        l.stroke()
    }
}

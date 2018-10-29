//
//  TransformViewController.swift
//  ECE564_HOMEWORK
//
//  Created by luke_zhu on 10/3/18.
//  Copyright © 2018 ece564. All rights reserved.
//
import UIKit
import AVFoundation

class WenchaoAnimationController: UIViewController {

    var Transformbutton: UIButton!
    var tempname: String!
    let iv = UIImageView()
    var imageViewBackground = UIImageView()
    var SwimmingBoyImageView = UIImageView()
    var bombSoundEffect: AVAudioPlayer?
    
    @IBOutlet weak var SwimmingManImageView: UIImageView!
    @IBOutlet weak var MovingDogImageView: UIImageView!
    @IBOutlet weak var SunImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // background picture
        let imageViewBackground = UIImageView(image: UIImage(named: "swimming pool.png"))
        imageViewBackground.frame = CGRect(x: 0, y: 230, width: 280, height: 200)
        view.addSubview(imageViewBackground)
        
        SwimmingManImageView.image = UIImage(named: "ball.png")
        SunImageView.image = UIImage(named: "sun.jpeg")
        MovingDogImageView.image = UIImage(named: "swimming_dog.jpeg")
        
        let SwimmingBoyImageView = UIImageView(image: UIImage(named: "SwimmingBoyImageView_1.png"))
        SwimmingBoyImageView.frame = CGRect(x: 245, y: 430, width: 70, height: 70 )
        view.addSubview(SwimmingBoyImageView)
        self.rotate1(imageView: SwimmingBoyImageView, aCircleTime: 7.0)
        
        // Attributed Text
        let label = UILabel()
        label.frame = CGRect(x: 90, y: 130, width: 200, height: 100)
        label.textAlignment = .center
        label.font = label.font.withSize(20)
        view.addSubview(label)
        
        let myString = "I Like Swimming"
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.shadow: myShadow ]
        
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        // set attributed text on a UILabel
        label.attributedText = myAttrString
        
        // TransformButton
        Transformbutton = UIButton()
        Transformbutton.frame = CGRect(x: 320, y: 620, width: 50, height: 50)
        Transformbutton.setImage(UIImage(named:"return.png"), for: .normal)
        Transformbutton.setTitle("Transform", for: UIControl.State())
        Transformbutton.setTitleColor(UIColor.blue, for: .highlighted)
        Transformbutton.addTarget(self, action: #selector(return_button(_:)), for: .touchUpInside)
        self.view.addSubview(Transformbutton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.rotate1(imageView: SwimmingManImageView, aCircleTime: 5)
        self.rotate2(imageView: SunImageView, aCircleTime: 9)
        self.moving1(imageView: MovingDogImageView, aCircleTime: 7)
        view.bringSubviewToFront(MovingDogImageView)
        view.bringSubviewToFront(SwimmingBoyImageView)
        view.bringSubviewToFront(SwimmingManImageView)
    }
    
    //closewise rotation
    func rotate1(imageView: UIImageView, aCircleTime: Double) { //CABasicAnimation
        print("rotate1")
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = aCircleTime
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: nil)
    }
    
    func rotate2(imageView: UIImageView, aCircleTime: Double) { //UIView
        
        UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { finished in
            UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
            }, completion: { finished in
                self.rotate2(imageView: imageView, aCircleTime: aCircleTime)
            })
        })
    }
    
    // moving animation
    func moving1(imageView: UIImageView, aCircleTime: Double) { //UIView
        
        UIView.animate(withDuration: aCircleTime, delay: 0.0, options: .curveLinear, animations: {
            imageView.center.x = 300
        }, completion: { finished in
            UIView.animate(withDuration: aCircleTime, delay: 0.0, options: .curveLinear, animations: {
            imageView.center.x = 100
            }, completion: { finished in
                self.moving1(imageView: imageView, aCircleTime: aCircleTime)
            })
        })
    }

    //counter-clockwise rotation
    @IBAction func return_button (_ sender: Any){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PersonEditNaviController") as! PersonEditNavigationViewController
//        let destination = newViewController.topViewController as? PersonEditViewController
//        destination?.tempname = self.tempname
//        self.present(newViewController, animated: true, completion: nil)
    }
}

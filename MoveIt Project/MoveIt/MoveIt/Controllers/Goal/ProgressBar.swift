//
//  ProgressBar.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/7/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit

class ProgressBar: UIView {
    var barColor: UIColor? {
        didSet {
            shapeLayer.strokeColor = barColor?.cgColor
            shadowLayer.fillColor = barColor?.cgColor
        }
    }
    var defaultBarColor = UIColor.green
    let path: UIBezierPath = {
        let path = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: -0.5 * CGFloat.pi, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        return path
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.lineWidth = 10
        layer.strokeColor = defaultBarColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeEnd = 0
        return layer
    }()
    
    let trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.lineWidth = 10
        layer.strokeColor = UIColor.cloudyGray.cgColor
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()
    
    lazy var shadowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = defaultBarColor.cgColor
        return layer
    }()
    
    var startAnimationTo: Double = 0 {
        didSet {
            startProgressAnimation()
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            trackLayer.fillColor = backgroundColor?.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shapeLayer.path = path.cgPath
        trackLayer.path = path.cgPath
        shadowLayer.path = path.cgPath
        layer.addSublayer(shadowLayer)
        layer.addSublayer(trackLayer)
        layer.addSublayer(shapeLayer)
        addPulsingAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        shadowLayer.position = center
        trackLayer.position = center
        shapeLayer.position = center
    }
    
    private func addPulsingAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.2
        animation.duration = 0.9
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        shadowLayer.add(animation, forKey: "pulsing")
    }
    
    fileprivate func startProgressAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = startAnimationTo
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "circular")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

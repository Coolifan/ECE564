//
//  CountingLabel.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/7/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//
import UIKit

class CountingLabel: UILabel {
    let startValue: Double = 0
    var endValue: Double = 0 {
        didSet {
            endValue *= 100
            endValue = round(endValue)
            displayLink = CADisplayLink(target: self, selector: #selector(handleCounting))
            displayLink?.add(to: .main, forMode: .default)
        }
    }
    let duration: Double = 2
    private let startTime = Date()
    private var displayLink: CADisplayLink?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func handleCounting() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(startTime)
        let percentage = elapsedTime / duration
        var currentValue = startValue + percentage * (endValue - startValue)
        currentValue = min(currentValue, endValue)
        text = "\(Int(currentValue))%"
        if currentValue >= endValue {
            displayLink?.remove(from: .main, forMode: .default)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

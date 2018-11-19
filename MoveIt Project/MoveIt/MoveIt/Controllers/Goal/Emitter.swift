//
//  Emitter.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/7/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit

class Emitter {
    static func get(with image: UIImage) -> CAEmitterLayer {
        let layer = CAEmitterLayer()
        layer.emitterCells = generateCells(with: image)
        layer.emitterShape = .line
        layer.drawsAsynchronously = true
        return layer
    }
    
    fileprivate static func generateCells(with image: UIImage) -> [CAEmitterCell] {
        let cell = CAEmitterCell()
        cell.contents = image.withRenderingMode(.alwaysTemplate).cgImage
        cell.color = UIColor.limeGreen.cgColor
        cell.redRange = 3.0
        cell.blueRange = 3.0
        cell.greenRange = 3.0
        cell.redSpeed = 0.05
        cell.blueSpeed = 0.05
        cell.greenSpeed = 0.05
        cell.velocity = 35
        cell.velocityRange = 10
        cell.scale = 0.4
        cell.scaleRange = 0.15
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = 0.25 * CGFloat.pi
        cell.birthRate = 3
        cell.lifetime = 50
        
        return [cell]
    }
}

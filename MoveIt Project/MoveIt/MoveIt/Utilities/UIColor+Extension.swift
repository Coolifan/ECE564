//
//  UIColor+Extension.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/2/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit

extension UIColor {
    static let steelGray = rgb(127, 140, 141)
    static let cloudWhite = rgb(236, 240, 241)
    static let midnightBlue = rgb(44, 62, 80)
    static let midnightBlack = rgb(34, 47, 62)
    static let silver = rgb(189, 195, 199)
    static let carrotOrange = rgb(230, 126, 34)
    static let emeraldGreen = rgb(85, 239, 196)
    
    static func rgb(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> UIColor {
        return UIColor(displayP3Red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

//
//  AnnotationView.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/17/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import MapKit

class AnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let location = newValue as? LocationAnnotation else { return }
            canShowCallout = true
            calloutOffset = .init(x: -5, y: 5)
            let mapButton = UIButton(frame: CGRect(origin: .zero, size: .init(width: 30, height: 30)))
            mapButton.setImage(#imageLiteral(resourceName: "map"), for: UIControl.State())
            rightCalloutAccessoryView = mapButton
            let icon: UIImage
            if location.locationType == .restuarant {
                icon = #imageLiteral(resourceName: "apple")
            } else {
                icon = #imageLiteral(resourceName: "rose")
            }
            image = resizeIcon(icon: icon, size: .init(width: 25, height: 25))
        }
    }
    
    fileprivate func resizeIcon(icon: UIImage, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        icon.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

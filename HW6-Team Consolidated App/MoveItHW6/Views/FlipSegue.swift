//
//  FlipSegue.swift
//  ECE564_HOMEWORK
//
//  Created by Yifan Li on 10/4/18.
//  Copyright © 2018 ece564. All rights reserved.
//

import UIKit

class FlipSegue: UIStoryboardSegue {

    override func perform() {
        scale()
    }
    
    func scale() {
        let toVC = self.destination
        let fromVC = self.source
        
        let containerView = fromVC.view.superview
        let originalCenter = fromVC.view.center
        
        toVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toVC.view.center = originalCenter
        
        containerView?.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            toVC.view.transform = CGAffineTransform.identity
        }, completion: { success in
            fromVC.present(toVC, animated: false, completion: nil)
        })
    }
}

class UnwindFlipSegue: UIStoryboardSegue {
    override func perform() {
        scale()
    }
    
    func scale() {
        let toVC = self.destination
        let fromVC = self.source
        
        fromVC.view.superview?.insertSubview(toVC.view, at: 0)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            fromVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }, completion: { success in
            fromVC.dismiss(animated: false, completion: nil)
        })
    }
}

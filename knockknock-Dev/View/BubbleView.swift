//
//  Bubble.swift
//  knockknock
//
//  Created by Nicole Hinckley on 11/4/18.
//  Copyright © 2018 Nicole Hinckley. All rights reserved.
//

import UIKit
import SDWebImage

@IBDesignable

class BubbleView : UIButton , CAAnimationDelegate {
 
    private let bubbleSize : CGFloat = 75
    var circleLayer: CAShapeLayer!
    var collection : Collection!
    var isShrinking : Bool = false
    
    convenience init (position: CGPoint, collection : Collection) {
        self.init()
        self.isShrinking = false
        self.collection = collection
        self.frame = CGRect(x: position.x, y: position.y, width: bubbleSize, height: bubbleSize)
        self.layer.cornerRadius = bubbleSize / 2
        self.clipsToBounds = true
        let imageView = UIImageView(frame: self.frame)
        let url = URL(string: collection.thumbnailURL)
        self.alpha = 0
        
        imageView.sd_setImage(with: url) { (image, error, cache, url) in // TODO: - error handle no load
            self.setImage(imageView.image, for: .normal)
            self.alpha = 1
        }
       
        self.imageView?.contentMode = .scaleAspectFill
        self.showsTouchWhenHighlighted = false
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width)/2, startAngle: CGFloat(-(Double.pi) / 2), endAngle: CGFloat(3 * (Double.pi) / 2), clockwise: true)
      
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 5.0;
        //circleLayer.lineCap = CAShapeLayerLineCap.round
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    func animateCircle(duration: TimeInterval, fromValue : Double ) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = fromValue
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.setValue("123", forKey: "animationID")
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
        
        
    }
    
}

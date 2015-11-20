//
//  NTGlossyButton.swift
//  NTGlossyButton
//
//  Created by Pham Nguyen Nhat Trung on 11/20/15.
//  Copyright © 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import UIKit

@IBDesignable
public class NTGlossyButton: UIButton {
    // MARK: Attributes
    // Public Attributes
    public var gradientColors: [AnyObject] = [UIColor.whiteColor().colorWithAlphaComponent(0).CGColor,
        UIColor.whiteColor().colorWithAlphaComponent(0.8).CGColor,
        UIColor.whiteColor().colorWithAlphaComponent(0).CGColor] {
        didSet {
            playAnimation()
        }
    }
    
    @IBInspectable var repeatAnimation: Bool = true
    @IBInspectable var animationDuration: Double = 3
    
    
    // Private Attributes
    private let gradientView = UIView()
    private lazy var gradientLayer: CAGradientLayer = {
        return self.createGradientLayer()
        }()
    
    // MARK: Initilization
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: Layouts
    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientView.frame = bounds
        gradientLayer.frame = gradientView.bounds
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        playAnimation()
    }
    
    private func setup() {
        setupGradientView()
        setupGradientLayer()
    }
    
    private func setupGradientView() {
        gradientView.frame = bounds
        gradientView.backgroundColor = UIColor.clearColor()
        imageView?.clipsToBounds = true
        insertSubview(gradientView, atIndex: 0)
        bringSubviewToFront(gradientView)
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    private func createOuterCircleMaskShape() -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = createOuterCirclePath()
        shape.backgroundColor = UIColor.redColor().CGColor
        return shape
    }
    
    private func createOuterCirclePath() -> CGPathRef {
        let frame = gradientView.frame
        let x = frame.midX
        let y = frame.midY
        
        let radius = sqrt(pow(x, 2) + pow(y, 2))
        return UIBezierPath(ovalInRect: CGRectMake(CGRectGetMidX(frame) - radius, CGRectGetMidY(frame) - radius, radius * 2, radius * 2)).CGPath
    }
    
    private func setupGradientLayer() {
        imageView?.contentMode = UIViewContentMode.ScaleToFill
        backgroundColor = UIColor.clearColor()
        // Rotate Gradient Layer
    }
    
    private func createGradientLayer() -> CAGradientLayer {
        let graLayer = CAGradientLayer()
        graLayer.frame = CGRectMake(0, 0, 400, 400)
        graLayer.colors = gradientColors
        graLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        graLayer.endPoint = CGPoint(x: 0.2, y: 0.5)
        graLayer.mask = createOuterCircleMaskShape()
        return graLayer
    }
    
    // MARK: Effects
    func playAnimation() {
        // Remove existed animations
        stopAnimation()
        // Create new animation
        let startPointAnimation = CABasicAnimation(keyPath: "startPoint")
        startPointAnimation.toValue = NSValue(CGPoint: CGPointMake(0.8, 0.5))
        startPointAnimation.duration = animationDuration
        startPointAnimation.removedOnCompletion = false
        startPointAnimation.fillMode = kCAFillModeForwards
        
        let endPointAnimation = CABasicAnimation(keyPath: "endPoint")
        endPointAnimation.toValue = NSValue(CGPoint: CGPointMake(1.0, 0.5))
        
        endPointAnimation.duration = animationDuration
        endPointAnimation.removedOnCompletion = false
        endPointAnimation.fillMode = kCAFillModeForwards
        
        let gradientGroupAnimation = CAAnimationGroup()
        gradientGroupAnimation.animations = [startPointAnimation, endPointAnimation]
        gradientGroupAnimation.duration = startPointAnimation.duration
        gradientGroupAnimation.repeatCount = repeatAnimation == true ? .infinity : 1
        gradientGroupAnimation.removedOnCompletion = false
        gradientGroupAnimation.autoreverses = true
        gradientGroupAnimation.fillMode = kCAFillModeForwards
        gradientGroupAnimation.delegate = self
        gradientGroupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        // Add new animation
        gradientLayer.addAnimation(gradientGroupAnimation, forKey: "gradientAnimation")
    }
    
    public func pauseAnimation() {
        gradientLayer.pauseAnimation()
    }
    
    public func resumeAnimation() {
        gradientLayer.resumeAnimation()
    }
    
    func stopAnimation() {
        gradientView.layer.removeAllAnimations()
    }
    
    // CAAnimationDelegate
    override public func animationDidStart(anim: CAAnimation) {
        
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
    }
}

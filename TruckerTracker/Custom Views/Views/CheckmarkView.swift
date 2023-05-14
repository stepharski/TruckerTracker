//
//  CheckmarkView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/10/23.
//

import UIKit

class CheckmarkView: UIView {
    
    var checkmarkColor: UIColor = .systemGreen
    var animationDuration = 0.5
    var animationType: CAMediaTimingFunctionName = .easeInEaseOut
    
    // changes background layer to CAShapeLayer
    @objc override class var layerClass: AnyClass {
        get { return CAShapeLayer.self }
    }
    
    // Life cycle
    override required init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // Init
    func commonInit() {
        guard let layer = layer as? CAShapeLayer else { return }
        
        layer.lineWidth = 6
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = checkmarkColor.cgColor
        layer.path = checkmarkPath()
    }

    // Path
    private func checkmarkPath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5, y: bounds.midY))
        path.addLine(to: CGPoint(x: 25, y: bounds.midY + 20))
        path.addLine(to: CGPoint(x: 45, y: bounds.midY - 20))
        return path.cgPath
    }
    
    // Checkmark
    func showCheckmark() {
        guard let layer = layer as? CAShapeLayer else { return }
        
        let strokeEnd: CGFloat = 1.0
        let strokeStart: CGFloat = 0.0
        
        alpha = 1.0
        layer.strokeEnd = strokeEnd
        
        let keypath = "strokeEnd"
        let animation = CABasicAnimation(keyPath: keypath)
        
        animation.fromValue = strokeStart
        animation.toValue = strokeEnd
        animation.duration = animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: animationType)
        
        layer.add(animation, forKey: nil)
    }
}

//
//  BarView.swift
//  CHICharts
//
//  Created by Артём Кваснецкий on 20.05.2020.
//  Copyright © 2020 Artem Kvasnetskyi. All rights reserved.
//

import UIKit.UIView

class BarView: UIView {
    
    // MARK: - Public Variables
    var color: UIColor?
    var animation: Bool?
    
    // MARK: - Draw Method
    override func draw(_ rect: CGRect) {
        subviews.forEach { $0.removeFromSuperview() }
        
        let barLayer = getLayer(with: bounds, color: color ?? .red, animation: animation ?? false)
        self.layer.addSublayer(barLayer)
    }
    
    private func getLayer(with rect: CGRect, color: UIColor, animation: Bool) -> CAShapeLayer {
        
        let endPath = UIBezierPath(roundedRect: rect,
                                   byRoundingCorners: [.topLeft, .topRight],
                                   cornerRadii: CGSize(width: rect.height * 0.5, height: 0))
        
        let layer = CAShapeLayer()
        layer.fillColor = color.cgColor
        
        if animation {
            let startRect = CGRect(x: rect.origin.x, y: rect.maxY, width: rect.width, height: 0)
            
            let startPath = UIBezierPath(roundedRect: startRect,
                                         byRoundingCorners: [.topLeft, .topRight],
                                         cornerRadii: CGSize(width: rect.height * 0.5, height: 0))
            
            layer.path = startPath.cgPath
            
            let basicAnimation = CABasicAnimation(keyPath: "path")
            basicAnimation.toValue = endPath.cgPath
            basicAnimation.duration = Constants.Charts.BarView.animationDuration
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.fillMode = .forwards
            layer.add(basicAnimation, forKey: "basicAnimation")
            
        } else {
            layer.path = endPath.cgPath
        }
        
        return layer
    }
}

//
//  BarChartBottomView.swift
//  CHICharts
//
//  Created by Артём Кваснецкий on 21.05.2020.
//  Copyright © 2020 Artem Kvasnetskyi. All rights reserved.
//

import UIKit.UIView

class BarChartBottomView: UIView {
    
    // MARK: - Public Variables
    var bars: [UIView]?
    var titles: [String]?
    
    var indent: CGFloat?
    
    var strokeColor: UIColor?
    var pointsColorSet: [UIColor]?
    var labelColor: UIColor?
    var labelFont: UIFont?
    
    // MARK: - Draw Method
    override func draw(_ rect: CGRect) {
        subviews.forEach { $0.removeFromSuperview() }
        
        if let bars = bars, let titles = titles {
            setBottomLine(bars: bars)
            setBottomPoints(bars: bars)
            setBottomLabels(bars: bars, titles: titles)
        }
    }
    
    // MARK: - Draw Bottom Line
    private func setBottomLine(bars: [UIView]) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bars.first!.center.x, y: indent ?? Constants.Charts.BarChartBottomView.insted))
        path.addLine(to: CGPoint(x: bars.last!.center.x, y: indent ?? Constants.Charts.BarChartBottomView.insted))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = (strokeColor ?? UIColor.red).cgColor
        shapeLayer.lineDashPattern = [NSNumber(value: Double(bounds.height) * Constants.Charts.BarChartBottomView.lineDashPatternWhidthKoef * 2),
                                      NSNumber(value: Double(bounds.height) * Constants.Charts.BarChartBottomView.lineDashPatternWhidthKoef)]
        shapeLayer.lineWidth = bounds.height * Constants.Charts.BarChartBottomView.lineWidthKoef

        layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Draw Bottom Points
    private func setBottomPoints(bars: [UIView]) {
        let colorObject = UIColor()
        let colorSet = pointsColorSet ?? colorObject.getColorSet()
        
        for i in 0..<bars.count {
            let center = CGPoint(x: bars[i].center.x, y: indent ?? Constants.Charts.BarChartBottomView.insted)
            let radius = bounds.height * Constants.Charts.BarChartBottomView.pointRadiusKoef
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            
            let pointLayer = CAShapeLayer()
            pointLayer.path = path.cgPath
            
            if i >= colorSet.count {
                let koef = i/colorSet.count
                pointLayer.fillColor = colorSet[i - colorSet.count * koef].cgColor
            } else {
                pointLayer.fillColor = colorSet[i].cgColor
            }
            
            layer.addSublayer(pointLayer)
        }
    }
    
    // MARK: - Set Bottom Labels
    private func setBottomLabels(bars: [UIView], titles: [String]) {
        let size = CGSize(width: bars.first!.bounds.width, height: bars.first!.bounds.width)
        
        for i in 0..<titles.count {
            let origin = CGPoint(x: bars[i].frame.origin.x, y: indent ?? Constants.Charts.BarChartBottomView.insted)
            let label = UILabel(frame: CGRect(origin: origin, size: size))
            label.text = titles[i]
            label.textColor = labelColor ?? .black
            label.textAlignment = .center
            label.font = labelFont ?? UIFont.systemFont(ofSize: Constants.Charts.BarChartBottomView.titleSize)
            
            addSubview(label)
        }
    }
}

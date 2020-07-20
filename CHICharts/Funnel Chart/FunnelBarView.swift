//
//  FunnelBarView.swift
//  CHICharts
//
//  Created by Артём Кваснецкий on 21.05.2020.
//  Copyright © 2020 Artem Kvasnetskyi. All rights reserved.
//

import UIKit.UIView

class FunnelBarView: UIView {
    
    // MARK: - Public Variables
    var data: FunnelChartData?
    var maxValue: CGFloat?
    var valuesSum: CGFloat?
    var bgBarColor: UIColor?
    var valueBarColor: UIColor?
    var cornerTitlesColor: UIColor?
    var cornerTitlesFont: UIFont?
    var cornetTitlesInset: CGFloat?
    var valueLabelColor: UIColor?
    var valueLabelFont: UIFont?
    
    // MARK: - Private Variables
    private var bgBarRect: CGRect!
    private var percentFromMaxValue = CGFloat()
    private var percentFromValueSum = CGFloat()
    
    // MARK: - Draw Method
    override func draw(_ rect: CGRect) {
        subviews.forEach { $0.removeFromSuperview() }
        
        guard let data = data, let maxValue = maxValue, let valuesSum = valuesSum else { return }
        setBGBar()
        setValueBar(maxValue: maxValue, data: data)
        setLabels(valuesSum: valuesSum, data: data)
    }
    
    // MARK: - Set BG Bar
    func setBGBar() {
        let size = CGSize(width: bounds.width * Constants.Charts.FunelBarView.bgBarWidthKoef, height: bounds.height)
        let origin = CGPoint(x: center.x - size.width * 0.5, y: 0)
        bgBarRect = CGRect(origin: origin, size: size)
        
        let path = UIBezierPath(roundedRect: bgBarRect, cornerRadius: size.height * 0.5)
        
        let layer = CAShapeLayer()
        layer.fillColor = (bgBarColor ?? #colorLiteral(red: 0.3469743729, green: 0.3920212984, blue: 0.4631944299, alpha: 1)).cgColor
        layer.path = path.cgPath
        
        self.layer.addSublayer(layer)
    }
    
    // MARK: - Set Value Bar
    func setValueBar(maxValue: CGFloat, data: FunnelChartData) {
        percentFromMaxValue = (data.value / (maxValue * 0.01)) * 0.01
        
        var width = bgBarRect.width * percentFromMaxValue
        
        if width < bounds.width * Constants.Charts.FunelBarView.valueLabelWidthKoef && width > 0 {
            width = bounds.width * Constants.Charts.FunelBarView.valueLabelWidthKoef
        }
        
        let size = CGSize(width: width, height: bounds.height)
        let origin = CGPoint(x: bgBarRect.midX - (width * 0.5), y: 0)
        
        let endRect = CGRect(origin: origin, size: size)
        let startRect = CGRect(origin: CGPoint(x: bgBarRect.midX, y: 0),
                               size: CGSize(width: 0, height: size.height))
        
        let endPath = UIBezierPath(roundedRect: endRect, cornerRadius: size.height * 0.5)
        let startPath = UIBezierPath(roundedRect: startRect, cornerRadius: size.height * 0.5)
        
        let layer = CAShapeLayer()
        layer.fillColor = (bgBarColor ?? #colorLiteral(red: 0.9501563907, green: 0.8080067039, blue: 0.2787514329, alpha: 1)).cgColor
        layer.path = startPath.cgPath
        
        let basicAnimation = CABasicAnimation(keyPath: "path")
        basicAnimation.toValue = endPath.cgPath
        basicAnimation.duration = Constants.Charts.FunelBarView.animationDuration
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fillMode = .forwards
        layer.add(basicAnimation, forKey: "basicAnimation")
        
        self.layer.addSublayer(layer)
    }
    
    // MARK: - Set Labels
    func setLabels(valuesSum: CGFloat, data: FunnelChartData) {
        percentFromValueSum = (data.value / (valuesSum * 0.01)) * 0.01
        
        var labelWidth = bounds.width * ((1 - Constants.Charts.FunelBarView.bgBarWidthKoef) * 0.5)
        
        let inset = cornetTitlesInset ?? labelWidth * Constants.Charts.FunelBarView.cornerTitlesInsetKoef
        labelWidth -= inset * 2
        
        let labelSize = CGSize(width: labelWidth, height: bounds.height)
        let leftLabelOrigin = CGPoint.zero
        let rightLabelOrigin = CGPoint(x: bounds.maxX - labelSize.width - inset, y: 0)
        percentFromValueSum *= 100
        
        setLabel(with: CGRect(origin: leftLabelOrigin, size: labelSize),
                 color: cornerTitlesColor ?? .black,
                 font: cornerTitlesFont ?? UIFont.boldSystemFont(ofSize: Constants.Charts.FunelBarView.cornerTitlesFontSize),
                 title: data.title,
                 textAlignment: .right)
        
        setLabel(with: CGRect(origin: rightLabelOrigin, size: labelSize),
                 color: cornerTitlesColor ?? .black,
                 font: cornerTitlesFont ?? UIFont.boldSystemFont(ofSize: Constants.Charts.FunelBarView.cornerTitlesFontSize),
                 title: String(format: "%.2f", percentFromValueSum) + "%",
                 textAlignment: .right)
        
        let valueLabelSize = CGSize(width: bounds.width * Constants.Charts.FunelBarView.valueLabelWidthKoef,
                                    height: bounds.height)
        let valueLabelOrigin = CGPoint(x: center.x - valueLabelSize.width * 0.5, y: 0)
        
        setLabel(with: CGRect(origin: valueLabelOrigin, size: valueLabelSize),
                 color: valueLabelColor ?? .white,
                 font: valueLabelFont ?? UIFont.boldSystemFont(ofSize: Constants.Charts.FunelBarView.cornerTitlesFontSize),
                 title: "\(Int(data.value))",
                 textAlignment: .center)
    }
    
    func setLabel(with frame: CGRect, color: UIColor, font: UIFont?, title: String?, textAlignment: NSTextAlignment) {
        guard let title = title else { return }
        
        let label = UILabel(frame: frame)
        let text = title
        label.text = text
        label.textColor = color
        label.font = font
        label.textAlignment = textAlignment
        addSubview(label)
    }
}

//
//  FunnelChartView.swift
//  CHICharts
//
//  Created by Артём Кваснецкий on 21.05.2020.
//  Copyright © 2020 Artem Kvasnetskyi. All rights reserved.
//

import UIKit.UIView

// MARK: - Typealias
typealias FunnelChartData = (title: String, value: CGFloat)

class FunnelChartView: UIView {
    // MARK: - Public Variables
    var data: [FunnelChartData]?
    var indent: CGFloat?
    
    var bgBarColor: UIColor?
    var valueBarColor: UIColor?
    var cornerTitlesColor: UIColor?
    var cornerTitlesFont: UIFont?
    var cornetTitlesInset: CGFloat?
    var valueLabelColor: UIColor?
    var valueLabelFont: UIFont?
    
    // MARK: - Private Variables
    private var maxValue = CGFloat()
    private var valuesSum = CGFloat()
    
    
    // MARK: - Draw Method
    override func draw(_ rect: CGRect) {
        reloadSelf()
        
        guard let data = data else {
            showEmptyDataView(in: rect)
            return
        }
        
        guard zeroDataValidation(data: data) else {
            showEmptyDataView(in: rect)
            return
        }
        
        findeMaxValue(data: data)
        findeValueSum(data: data)
        setBarViews(with: data)
    }
    
    // MARK: - Reload Self
    private func reloadSelf() {
        maxValue = CGFloat()
        valuesSum = CGFloat()
        
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.removeAll()
    }
    
    // MARK: - Zero Value in Data Validation
    private func zeroDataValidation(data: [PieChartData]) -> Bool {
        var flag = false
        
        for obj in data {
            guard obj.value != 0 else { continue }
            flag = true
            break
        }
        
        return flag
    }
    
    // MARK: - Show Empty View
    private func showEmptyDataView(in rect: CGRect) {
        let emptyDataView = EmptyChartDataView(frame: rect)
        addSubview(emptyDataView)
    }
    
    // MARK: - Finde Max Value in Data
    private func findeMaxValue(data: [FunnelChartData]?) {
        guard let data = data else { return }
        
        for object in data {
            guard object.value > maxValue else { continue }
            maxValue = object.value
        }
    }
    
    // MARK: - Finde Values Sum
    private func findeValueSum(data: [FunnelChartData]?) {
        guard let data = data else { return }
        
        for object in data {
            valuesSum += object.value
        }
    }
    
    // MARK: - Set Bars in View
    func setBarViews(with data: [FunnelChartData]) {
        let barIndent = indent ?? bounds.height/CGFloat(data.count) * Constants.Charts.FunelChartView.barIndentKoef
        let height = bounds.height/CGFloat(data.count) - barIndent
        let size = CGSize(width: bounds.width, height: height)
        
        var pointY: CGFloat = barIndent * 0.5
        
        for i in 0..<data.count {
            let origin = CGPoint(x: 0, y: pointY)
            let frame = CGRect(origin: origin, size: size)
            
            let barView = FunnelBarView(frame: frame)
            barView.data = data[i]
            barView.maxValue = maxValue
            barView.valuesSum = valuesSum
            barView.bgBarColor = bgBarColor
            barView.valueBarColor = valueBarColor
            barView.cornerTitlesFont = cornerTitlesFont
            barView.cornetTitlesInset = cornetTitlesInset
            barView.valueLabelColor = valueLabelColor
            barView.valueLabelFont = valueLabelFont

            addSubview(barView)
            
            pointY += i < data.count - 1 ? (height + barIndent) : (height + barIndent * 0.5)
        }
    }
}

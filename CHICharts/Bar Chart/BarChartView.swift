//
//  BarChartView.swift
//  CHICharts
//
//  Created by Артём Кваснецкий on 20.05.2020.
//  Copyright © 2020 Artem Kvasnetskyi. All rights reserved.
//

import UIKit.UIView

// MARK: - Typealias
typealias BarChartData = (title: String, value: CGFloat)

class BarChartView: UIView {
    
    // MARK: - Public Variables
    var data: [BarChartData]?
    
    var barColorSet: [UIColor]?
    var bgBarColor: UIColor?
    var labelColor: UIColor?
    var labelFont: UIFont?
    
    var bottomIndent: CGFloat?
    var bottomLineColor: UIColor?
    var bottomLabelColor: UIColor?
    var bottomLabelFont: UIFont?
    var bottomPointsColorSet: [UIColor]?
    
    // MARK: - Private Variables
    private var barWidth: CGFloat!
    private var barHeight: CGFloat!
    private var barIndent: CGFloat!
    private var maxValue: CGFloat!
    
    private var scrollView: UIScrollView!
    private var bgBars: [UIView]!
    
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
        
        setInitialStates()
        findeMaxValue(in: data)
        setScrollView(data: data)
        setBars(data: data)
        setBottomView(data: data)
    }
    
    // MARK: - Reload Self
    private func reloadSelf() {
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
    
    // MARK: - Set Initial States
    private func setInitialStates() {
        barIndent = (bounds.width / CGFloat(Constants.Charts.BarChartView.barsInScreen)) / CGFloat(Constants.Charts.BarChartView.barsInScreen)
        barWidth = (bounds.width - barIndent)/CGFloat(Constants.Charts.BarChartView.barsInScreen + 1) - barIndent / CGFloat(Constants.Charts.BarChartView.barsInScreen + 1)
        barHeight = bounds.height * Constants.Charts.BarChartView.barHeightKoef
    }
    
    // MARK: - Finde Max Value in Data
    private func findeMaxValue(in data: [BarChartData]) {
        var valueData = [CGFloat]()
        
        for object in data {
            valueData.append(object.value)
        }
        
        maxValue = valueData.max()
    }
    
    // MARK: - Set Scroll View
    private func setScrollView(data: [BarChartData]) {
        let width = CGFloat(data.count) * (barWidth + barIndent)
        let contentWidth = bounds.width < width ? width : bounds.width
        
        scrollView = UIScrollView(frame: bounds)
        scrollView.contentSize = CGSize(width: contentWidth, height: bounds.height)
        scrollView.showsHorizontalScrollIndicator = false
        
        addSubview(scrollView)
    }
    
    // MARK: - Set Bars
    private func setBars(data: [BarChartData]) {
        var pointX = barIndent!
        let iterator = data.count > Constants.Charts.BarChartView.barsInScreen ? data.count : Constants.Charts.BarChartView.barsInScreen
        bgBars = [UIView]()
        
        for i in 0..<iterator {
            let value: CGFloat?
            let barFrame = CGRect(x: pointX, y: 0, width: barWidth, height: barHeight)
            
            if i < data.count {
                let object = data[i]
                value = object.value
            } else {
                value = nil
            }
            
            setBar(value: value, frame: barFrame, iteration: i)
            
            pointX += barWidth + barIndent
        }
    }
    
    private func setBar(value: CGFloat?, frame: CGRect, iteration: Int) {
        // Add Background Bar
        let bar = BarView(frame: frame)
        
        bar.color = bgBarColor ?? UIColor(displayP3Red: Constants.Charts.BarChartView.bgBarColorComponent,
                                          green: Constants.Charts.BarChartView.bgBarColorComponent,
                                          blue: Constants.Charts.BarChartView.bgBarColorComponent, alpha: 1)
        scrollView.addSubview(bar)
        bgBars.append(bar)
        
        guard let value = value else { return }
        
        // Add Value Bar
        let colorObject = UIColor()
        let colorSet = barColorSet ?? colorObject.getColorSet()
        
        let valueBarPercentConverter = (1.0 - Constants.Charts.BarChartView.labelHightKoef)
        var valueBarHeight = barHeight * ((value / (maxValue * 0.01)) * 0.01) * valueBarPercentConverter
        valueBarHeight += valueBarHeight > 0 ? (frame.size.height * Constants.Charts.BarChartView.labelHightKoef) : 0
        
        let valueBarRect = CGRect(x: frame.origin.x,
                                  y: bar.bounds.maxY - valueBarHeight,
                                  width: barWidth, height: valueBarHeight)
        let valueBar = BarView(frame: valueBarRect)
        valueBar.animation = true
        
        if iteration >= colorSet.count {
            let koef = iteration/colorSet.count
            valueBar.color = colorSet[iteration - colorSet.count * koef]
        } else {
            valueBar.color = colorSet[iteration]
        }
        
        scrollView.addSubview(valueBar)
        
        // Add Value Label
        let labelSize = CGSize(width: frame.size.width, height: frame.size.height * Constants.Charts.BarChartView.labelHightKoef)
        let labelOrigin = valueBarHeight >= labelSize.height ? valueBarRect.origin : CGPoint(x: frame.origin.x, y: valueBarRect.origin.y - labelSize.height)
        let labelFrame = CGRect(origin: labelOrigin, size: labelSize)
        setLabel(frame: labelFrame, value: value)
    }
        
    func setLabel(frame: CGRect, value: CGFloat) {
        let label = UILabel(frame: frame)
        label.text = "\(Int(value))"
        label.textColor = labelColor ?? .white
        label.font = labelFont ?? UIFont.boldSystemFont(ofSize: Constants.Charts.BarChartView.valueSize)
        label.textAlignment = .center
        scrollView.addSubview(label)
    }
    
    // MARK: - Set Bottom View
    private func setBottomView(data: [BarChartData]) {
        let bottomView = BarChartBottomView(frame: CGRect(x: scrollView.bounds.origin.x,
                                                          y: scrollView.bounds.origin.y + bgBars.first!.bounds.height,
                                                          width: scrollView.contentSize.width,
                                                          height: scrollView.bounds.size.height - bgBars.first!.bounds.height))
        
        var titlesArray = [String]()
        
        for object in data {
            titlesArray.append(object.title)
        }
        
        bottomView.bars = bgBars
        bottomView.titles = titlesArray
        bottomView.indent = bottomIndent
        bottomView.strokeColor = bottomLineColor
        bottomView.pointsColorSet = bottomPointsColorSet
        bottomView.labelColor = bottomLabelColor
        bottomView.labelFont = bottomLabelFont
        
        scrollView.addSubview(bottomView)
    }
}

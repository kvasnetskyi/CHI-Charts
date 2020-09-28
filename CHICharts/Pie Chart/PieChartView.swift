//
//  PieChartView.swift
//  CHICharts
//
//  Created by Артём Кваснецкий on 16.05.2020.
//  Copyright © 2020 Artem Kvasnetskyi. All rights reserved.
//

import UIKit.UIView

// MARK: - Typealias
typealias PieChartData = (title: String, value: CGFloat)

class PieChartView: UIView {
    // MARK: - Public Variables
    /// Main Variables
    var data: [PieChartData]?
    var animationDuration: CGFloat?
    
    /// Pie Chart Variables
    var highlightedColor: UIColor?
    var valueSegmentsMainRGBComponent: CGFloat?
    var valueSegmentWidthKoef: CGFloat?
    
    var infoLabelColor: UIColor?
    var infoValueColor: UIColor?
    var infoLabelFont: UIFont?
    var infoValueFont: UIFont?
    
    // MARK: - Private Variables
    private var valuesSum = CGFloat()
    private var startPercent = CGFloat()
    private var chartHeight = CGFloat()
    private var colorRange: [UIColor]!
    
    private var scrollView: UIScrollView!
    private var valueLayers = [CAShapeLayer]()
    private var highlightedLayer: CAShapeLayer!
    private var pageControl: UIPageControl!
    
    private var scrollClockwise = Bool()
    private var currentPage = Int()
    private var nextPage = Int()
    private var scrollPercent = CGFloat()
    private var previousScrollPercent = CGFloat()
    
    // MARK: - Draw Method
    override func draw(_ rect: CGRect) {
        reloadSelf()
        
        guard var _ = data else {
            showEmptyDataView(in: rect)
            return
        }
        
        guard zeroDataValidation(data: data!) else {
            showEmptyDataView(in: rect)
            return
        }
        
        findeValueSum(data: data!)
        createСolourRange(data: data!)
        drawSegments(rect, data: data!)
        setScrollView(data: data!)
        drawInfoView(chartHeight: chartHeight, data: data!)
    }
    
    private func reloadSelf() {
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.removeAll()
        
        valuesSum = 0
        startPercent = 0
        chartHeight = 0
        valueLayers = [CAShapeLayer]()
        highlightedLayer = nil
        scrollClockwise = false
        currentPage = 0
        nextPage = 0
        scrollPercent = 0
        previousScrollPercent = 0
    }
    
    // MARK: - Zero Value in Data Validation
    private func zeroDataValidation(data: [PieChartData]) -> Bool {
        self.data = data.filter { $0.value != 0.0 }
        
        return !data.isEmpty
    }
    
    // MARK: - Show Empty View
    private func showEmptyDataView(in rect: CGRect) {
        let emptyDataView = EmptyChartDataView(frame: rect)
        addSubview(emptyDataView)
    }
    
    // MARK: - Sum of All Data Values
    private func findeValueSum(data: [PieChartData]) {
        for object in data {
            valuesSum += object.value
        }
    }
    
    // MARK: - Create Color Range
    private func createСolourRange(data: [PieChartData]) {
        var component = valueSegmentsMainRGBComponent ?? Constants.Charts.PieChart.standartMainRGBComponent
        let koef = (component)/CGFloat(data.count)
        colorRange = [UIColor]()
        
        for _ in 0..<data.count {
            component = component - koef
            let color = UIColor(displayP3Red: component,
                                green: component,
                                blue: component,
                                alpha: 1)
            colorRange.append(color)
        }
    }
    
    // MARK: - Draw Segments Methods
    private func drawSegments(_ rect: CGRect, data: [PieChartData]) {
        /// Searching for a Smaller Rect Side
        let supportingSize = rect.width > rect.height ? rect.height : rect.width
        
        /// Set Initial States
        let valueSegmentWidth = supportingSize * (valueSegmentWidthKoef ?? Constants.Charts.PieChart.valueSegmentsStrokeWidthKoef)
        let radius = supportingSize / Constants.Charts.PieChart.radiusKoef
        chartHeight = 2 * (radius + valueSegmentWidth)
        let animationDuration = self.animationDuration ?? Constants.Charts.PieChart.animationDuration
        let center = CGPoint(x: rect.midX, y: radius + valueSegmentWidth)
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: -CGFloat.pi * 0.5,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: true)
        
        /// Draw Value Segments
        for i in 0..<data.count {
            let percent = data[i].value / (valuesSum * 0.01)
            
            drawValueSegment(path: path,
                             width: valueSegmentWidth,
                             percent: percent,
                             animationDuration: animationDuration,
                             and: colorRange[i])
        }
        
        /// Draw Highlighted Segment
        drawHighlightedSegment(animationDuration: animationDuration)
    }
    
    // MARK: Value Segments
    private func drawValueSegment(path: UIBezierPath, width: CGFloat, percent: CGFloat, animationDuration: CGFloat, and color: UIColor) {
        
        let strokeEnd = startPercent + percent * (0.8 * 0.01)
        let valueLayer = getLayer(with: path.cgPath,
                                  width: width,
                                  start: startPercent,
                                  end: strokeEnd,
                                  animationDuration: animationDuration,
                                  and: color)
        
        startPercent = strokeEnd
        
        valueLayers.append(valueLayer)
        layer.addSublayer(valueLayer)
    }
    
    // MARK: Highlighted Segment
    private func drawHighlightedSegment(animationDuration: CGFloat) {
        
        weak var segment = valueLayers[0]
        guard let firstSegment = segment else { return }
        
        highlightedLayer = getLayer(with: firstSegment.path,
                                    width: firstSegment.lineWidth * Constants.Charts.PieChart.highlightedLineWidthKoef,
                                    start: firstSegment.strokeStart,
                                    end: firstSegment.strokeEnd,
                                    animationDuration: animationDuration,
                                    and: highlightedColor ?? .red)
        
        layer.addSublayer(highlightedLayer)
    }
    
    // MARK: Get Layer
    private func getLayer(with path: CGPath?, width: CGFloat, start: CGFloat, end: CGFloat, animationDuration: CGFloat, and color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        layer.path = path
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = width
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .butt
        layer.strokeStart = start
        layer.strokeEnd = end
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeColor")
        basicAnimation.toValue = color.cgColor
        basicAnimation.duration = CFTimeInterval(animationDuration)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        layer.add(basicAnimation, forKey: "basicAnimation")
        
        return layer
    }
    
    // MARK: - Set Scroll View
    func setScrollView(data: [PieChartData]) {
        scrollView = UIScrollView(frame: bounds)
        scrollView.contentSize = CGSize(width: bounds.width * CGFloat(data.count), height: bounds.height - chartHeight)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
    }
    
    // MARK: - Draw Info View
    func drawInfoView(chartHeight: CGFloat, data: [PieChartData]) {
        let pageControlHeight: CGFloat = bounds.height * 0.02
        let infoViewHeight: CGFloat = scrollView.bounds.height - chartHeight - pageControlHeight
        
        for i in 0..<data.count {
            let percent = data[i].value / (valuesSum * 0.01)
            let infoView = PieChartInfoView(title: data[i].title,
                                            value: round(data[i].value * 100) * 0.01,
                                            percent: round(percent * 100) * 0.01)
            
            infoView.frame.size = CGSize(width: scrollView.bounds.width, height: infoViewHeight)
            infoView.center.x = scrollView.center.x + scrollView.center.x * CGFloat(i) * 2
            infoView.center.y = scrollView.bounds.height - (infoViewHeight) * 0.5
            infoView.labelColor = infoLabelColor
            infoView.valueColor = infoValueColor
            infoView.titleFont = infoLabelFont
            infoView.valueFont = infoValueFont
            
            scrollView.addSubview(infoView)
        }
        
        setPageControl(height: pageControlHeight, infoViewHeight: infoViewHeight)
    }
    
    func setPageControl(height: CGFloat, infoViewHeight: CGFloat) {
        guard data!.count > 1 else { return }
        
        let colorComponent: CGFloat = valueSegmentsMainRGBComponent ?? Constants.Charts.PieChart.standartMainRGBComponent
        let frame = CGRect(x: 0, y: chartHeight + infoViewHeight, width: bounds.width, height: bounds.height - (chartHeight + infoViewHeight))
        pageControl = UIPageControl(frame: frame)
        pageControl.numberOfPages = data!.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(displayP3Red: colorComponent, green: colorComponent, blue: colorComponent, alpha: 1)
        pageControl.currentPageIndicatorTintColor = highlightedColor ?? .red
        
        addSubview(pageControl)
    }
    
    // MARK: - Set Scroll Direction
    func setScrollClockwise() {
        scrollClockwise = previousScrollPercent < scrollPercent ? true : false

        switch scrollClockwise {
        case false:
            guard currentPage != 0 else {
                nextPage = 0
                return
            }
            nextPage = currentPage - 1
            
        case true:
            guard currentPage != data!.count - 1 else {
                nextPage = data!.count - 1
                return
            }
            nextPage = currentPage + 1
        }
    }
    
    // MARK: - Change Highlighted Segment Position
    func changeStrokePosition() {
        weak var optionalLayer = valueLayers[currentPage]
        weak var optionalAdditionalLayer = valueLayers[nextPage]
        
        guard let layer = optionalLayer, let additionalLayer = optionalAdditionalLayer else { return }
        let currentPercent = (scrollPercent - CGFloat(currentPage))
        
        switch scrollClockwise {
        case false:
            highlightedLayer.strokeStart = layer.strokeStart - (additionalLayer.strokeStart - layer.strokeStart) * currentPercent
            highlightedLayer.strokeEnd = layer.strokeEnd - (additionalLayer.strokeEnd - layer.strokeEnd) * currentPercent

        case true:
            highlightedLayer.strokeStart = layer.strokeStart + (additionalLayer.strokeStart - layer.strokeStart) * currentPercent
            highlightedLayer.strokeEnd = layer.strokeEnd + (additionalLayer.strokeEnd - layer.strokeEnd) * currentPercent
        }
    }
}

// MARK: - UIScrollViewDelegate
extension PieChartView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard   scrollView.contentOffset.x > 0,
                scrollView.contentOffset.x < scrollView.contentSize.width - scrollView.bounds.width else { return }
        
        scrollPercent = (scrollView.contentOffset.x / (scrollView.bounds.width * 0.01)) * 0.01
        setScrollClockwise()
        changeStrokePosition()
        previousScrollPercent = scrollPercent
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let oldPage = currentPage
        currentPage = Int(round(scrollView.contentOffset.x / scrollView.bounds.size.width))
        pageControl.currentPage = currentPage
        
        if oldPage == currentPage {
            changeStrokePosition()
        }
    }
}

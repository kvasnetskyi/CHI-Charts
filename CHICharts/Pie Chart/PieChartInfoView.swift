//
//  PieChartInfoView.swift
//  CHICharts
//
//  Created by Артём Кваснецкий on 19.05.2020.
//  Copyright © 2020 Artem Kvasnetskyi. All rights reserved.
//

import UIKit.UIView

class PieChartInfoView: UIView {
    
    // MARK: - Public Variables
    var labelColor: UIColor?
    var valueColor: UIColor?
    var titleFont: UIFont?
    var valueFont: UIFont?
    
    // MARK: - Private Variables
    private let title: String
    private let value: CGFloat
    private let percent: CGFloat
    
    // MARK: - Init
    init(title: String, value: CGFloat, percent: CGFloat) {
        self.title = title
        self.value = value
        self.percent = percent
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Draw Method
    override func draw(_ rect: CGRect) {
        setLabels()
    }
    
    // MARK: - Set Labels
    private func setLabels() {
        subviews.forEach { $0.removeFromSuperview() }
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = "\(value) / \(percent)%"
        valueLabel.textColor = valueColor ?? .red
        valueLabel.font = valueFont ?? UIFont.systemFont(ofSize: Constants.Charts.InfoView.valueSize)
        valueLabel.textAlignment = .center
        
        addSubview(valueLabel)
        valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = labelColor ?? .black
        titleLabel.font = titleFont ?? UIFont.boldSystemFont(ofSize: Constants.Charts.InfoView.titleSize)
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: valueLabel.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}

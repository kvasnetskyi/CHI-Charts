//
//  EmptyChartDataView.swift
//  CHICharts
//
//  Created by Артём Кваснецкий on 19.06.2020.
//  Copyright © 2020 Artem Kvasnetskyi. All rights reserved.
//

import UIKit.UIView

class EmptyChartDataView: UIView {
    // MARK: - Draw Method
    override func draw(_ rect: CGRect) {
        setUILabel(in: rect)
    }
    
    // MARK: - Private Methods
    private func setUILabel(in rect: CGRect) {        
        let label = UILabel(frame: rect)
        label.text = Constants.Charts.EmptyChartDataView.labelText
        label.numberOfLines = Constants.Charts.EmptyChartDataView.numberOfLines
        label.textColor = .black
        label.textAlignment = .center
        addSubview(label)
    }
}

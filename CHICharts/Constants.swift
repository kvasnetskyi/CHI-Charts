//
//  Constants.swift
//  CHICharts
//
//  Created by Артём Кваснецкий on 19.05.2020.
//  Copyright © 2020 Artem Kvasnetskyi. All rights reserved.
//

import UIKit

struct Constants {
    // MARK: - Charts
    struct Charts {
        // MARK: - PrieChart
        struct PieChart {
            static let standartMainRGBComponent: CGFloat = 0.3
            static let valueSegmentsStrokeWidthKoef: CGFloat = 0.1
            static let animationDuration: CGFloat = 1.0
            static let radiusKoef: CGFloat = 3.5
            static let highlightedLineWidthKoef: CGFloat = 1.5
        }
        
        // MARK: InfoView
        struct InfoView {
            static let titleSize: CGFloat = 16.0
            static let valueSize: CGFloat = 12.0
        }
        
        // MARK: - BarView
        struct BarView {
            static let animationDuration: CFTimeInterval = 0.7
        }
        
        // MARK: BarChartView
        struct BarChartView {
            static let barsInScreen = 10
            static let barHeightKoef: CGFloat = 0.7
            static let labelHightKoef: CGFloat = 0.3
            static let valueSize: CGFloat = 16.0
            static let bgBarColorComponent: CGFloat = 0.8
        }
        
        // MARK: BarChartBottomView
        struct BarChartBottomView {
            static let insted: CGFloat = 25.0
            static let lineWidthKoef: CGFloat = 0.01
            static let lineDashPatternWhidthKoef = 0.01
            static let pointRadiusKoef: CGFloat = 0.05
            static let titleSize: CGFloat = 12.0
        }
        
        // MARK: - FunelChartView
        struct FunelChartView {
            static let barIndentKoef: CGFloat = 0.5
        }
        
        // MARK: FunelBarView
        struct FunelBarView {
            static let bgBarWidthKoef: CGFloat = 0.6
            static let cornerTitlesFontSize: CGFloat = 12.0
            static let valueLabelWidthKoef: CGFloat = 0.10
            static let cornerTitlesInsetKoef: CGFloat = 0.15
            static let animationDuration: CFTimeInterval = 0.7
        }
        
        // MARK: - EmptyChartDataView
        struct EmptyChartDataView {
            static let labelText = "There's a lack of data"
            static let numberOfLines = 0
        }
    }
}

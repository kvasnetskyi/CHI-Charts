# CHI-Charts

'CHI-Charts' is a set of UIView's heirs, charts written in Swift, which includes:
* [Pie Chart](#piechartview)
* [Bar Char](#barcharview)
* [Funnel Char](#funnelcharview)

To use the graphics, add the CHICharts folder to your project and enjoy.

# PieCharView
![PieChartView](https://user-images.githubusercontent.com/67891065/87921849-ce5dc600-ca83-11ea-85b1-d3647445f9e0.gif)

**Public Properties:**
```Ruby
data: [PieChartData]? // array from (title: String, value: CGFloat)
animationDuration: CGFloat? // duration of the starting animation 
highlightedColor: UIColor? // dynamic segment color
valueSegmentsMainRGBComponent: CGFloat? // main RGB component in color of first segment in circle
valueSegmentWidthKoef: CGFloat? // circle segments width
infoLabelColor: UIColor? // title text color
infoValueColor: UIColor? // value text color
infoLabelFont: UIFont? // title font
infoValueFont: UIFont? // value font
```

# BarCharView
![BarChartView](https://user-images.githubusercontent.com/67891065/87921835-c9007b80-ca83-11ea-8822-0853ee374b37.gif)

**Public Properties:**
```Ruby
data: [BarChartData]? // array from (title: String, value: CGFloat)
barColorSet: [UIColor]? // color set for displayed bars
bgBarColor: UIColor? // the color of the back of the bar
labelColor: UIColor? // data text color
labelFont: UIFont? // data text font
bottomIndent: CGFloat? // indentation between graphics and lines with title
bottomLineColor: UIColor? // line with title color
bottomLabelColor: UIColor? // title text color
bottomLabelFont: UIFont? // title text font
bottomPointsColorSet: [UIColor]? // color set for points on a line with tiles
```

# FunnelCharView
![FunnelChartView](https://user-images.githubusercontent.com/67891065/87921853-cef65c80-ca83-11ea-9be0-a0000efb2545.gif)

**Public Properties:**
```Ruby
data: [FunnelChartData]? // array from (title: String, value: CGFloat)
indent: CGFloat? //
bgBarColor: UIColor? // the color of the back of the bar
valueBarColor: UIColor? // the color of the value bar
cornerTitlesColor: UIColor? // titles and percent text color
cornerTitlesFont: UIFont? // titles and percent font
cornetTitlesInset: CGFloat? // titles and percent inset
valueLabelColor: UIColor? // values text color
valueLabelFont: UIFont? // values font
```

Developed By
------------

* Kvasnetskyi Artem, Kosyi Vlad, Vintonovich Nikita, CHI Software

License
--------

Copyright 2020 CHI Software.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

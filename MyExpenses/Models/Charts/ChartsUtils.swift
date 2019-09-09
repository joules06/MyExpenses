//
//  ChartsUtils.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import Charts
import Foundation

class Barchart: UIView {
    let chartView = LineChartView()
    var dataEntry: [ChartDataEntry] = []
    
    var xDataForChart = [String]()
    var yDataForChart = [String]()
    
    var delegate: GetChartData! {
        didSet {
            populteData()
            barChartSetup()
        }
    }
    
    func populteData() {
        xDataForChart = delegate.xData
        yDataForChart = delegate.yData
    }
    
    func barChartSetup() {
        self.backgroundColor = UIColor.white
        self.addSubview(chartView)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        setBarChart(dataPoints: xDataForChart, values: yDataForChart)
    }
    
    func setBarChart(dataPoints: [String], values: [String]) {
        chartView.noDataTextColor = UIColor.white
        chartView.noDataText = "No data for the chart"
        chartView.backgroundColor = UIColor.white
        
        for i in 0..<dataPoints.count {
            let dataPoint = ChartDataEntry(x: Double(i), y: Double(values[i])!)
            dataEntry.append(dataPoint)
        }
        
        
        let chartDataSet = LineChartDataSet(entries: dataEntry, label: delegate.labelForData)
        
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false)
        chartDataSet.colors = [UIColor(hexString: GlobalVariables.hexForPrimaryColor)]
        chartDataSet.circleColors = [UIColor(hexString: GlobalVariables.hexForSecondColor)]
        chartDataSet.circleRadius = 2
        chartDataSet.circleHoleColor = UIColor(hexString: GlobalVariables.hexForSecondColor)
        chartDataSet.drawValuesEnabled = true
        
        
        let firstColor = UIColor(hexString: GlobalVariables.hexForThirdColor)
        let secondColor = UIColor(hexString: GlobalVariables.hexForFourthColor)
        
        let gradientColors = [firstColor.cgColor, secondColor.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        chartDataSet.drawFilledEnabled = true // Draw the Gradient
        
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        
        let xAxis = XAxis()
        xAxis.valueFormatter = formatter
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.valueFormatter = xAxis.valueFormatter
        
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = true
        chartView.rightAxis.enabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawLabelsEnabled = true
        
        
        chartView.data = chartData
    }
}

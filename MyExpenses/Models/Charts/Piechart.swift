//
//  Piechart.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//
import Charts
import Foundation

class Piechart: UIView {
    let chartView = PieChartView()
    var dataEntry: [ChartDataEntry] = []
    
    var labelsForChart = [String]()
    var amountSpent = [String]()
    
    var delegate: GetChartDataForPie! {
        didSet {
            populteData()
            pieChartSetup()
        }
    }
    
    func populteData() {
        labelsForChart = delegate.xDataPie
        amountSpent = delegate.yDataPie
    }
    
    func pieChartSetup() {
        self.backgroundColor = UIColor.white
        self.addSubview(chartView)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        setPieChart(labelPoints: labelsForChart, values: amountSpent)
    }
    
    func setPieChart(labelPoints: [String], values: [String]) {
        chartView.noDataTextColor = UIColor.white
        chartView.noDataText = "No data for the chart"
        chartView.backgroundColor = UIColor.white
        
        for i in 0..<labelPoints.count {
            if let doubleValue  = Double(values[i]) {
                let dataPoint = PieChartDataEntry(value: doubleValue, label: labelPoints[i])
                
                dataEntry.append(dataPoint)
            }
            
        }
        
        let chartDataSet = PieChartDataSet(entries: dataEntry, label: "Categories")
        chartDataSet.entryLabelFont = NSUIFont(name: "verdana", size: 8)!
        chartDataSet.entryLabelColor = UIColor.black
        
        let chartData = PieChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false)
        chartDataSet.colors = [UIColor(hexString: GlobalVariables.hexForPrimaryColor), UIColor(hexString: GlobalVariables.hexForSecondColor), UIColor(hexString: GlobalVariables.hexForThirdColor) , UIColor(hexString: GlobalVariables.hexForFourthColor)]
        
        chartDataSet.sliceSpace = 2
        chartDataSet.selectionShift = 5
        
        chartDataSet.drawValuesEnabled = true
        chartDataSet.xValuePosition = .outsideSlice
        
        
        
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: labelPoints)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 0
        
        chartData.setValueFormatter(DefaultValueFormatter(formatter: numberFormatter))
        
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = true
        chartView.drawHoleEnabled = false
        
        
        
        chartView.data = chartData
    }
}

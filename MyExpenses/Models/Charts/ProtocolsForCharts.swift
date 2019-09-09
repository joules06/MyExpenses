//
//  File.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
protocol GetChartData {
    func getChartData(with dataPoints: [String], values: [String])
    var xData: [String]{ get set }
    var yData: [String]{ get set }
    var labelForData: String { get set }
}


protocol GetChartDataForPie {
    func getChartDataForPieChart(with dataPoints: [String], values: [String])
    var xDataPie: [String]{ get set }
    var yDataPie: [String]{ get set }
    var labelForData: String { get set }
}

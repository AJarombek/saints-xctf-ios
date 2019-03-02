//
//  BarChartFormatter.swift
//  SaintsXCTF
//
//  Created by Andy Jarombek on 10/7/17.
//  Copyright © 2017 Andy Jarombek. All rights reserved.
//

import UIKit
import Charts

extension BarChartView {
    
    // Create a private class that implements IAxisValueFormatter, which allows us
    // to manipulate the X-axis of the bar graph
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        // Through this custom init() function, we can pass in the x-axis labels
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    // Set up the bar chart with the appropriate data passed in
    func setBarChartData(xValues: [String], yValues: [Double], feelValues: [Int], label: String) {
        
        // Get all the colors to be used on the bar chart
        var chartColors = [UIColor]()
        for i in 0...9 {
            // Get the feel.  If equal to zero, default to 6
            var feel = feelValues[i]
            feel = feel == 0 ? 6 : feel
            
            chartColors.append(UIColor(Constants.getFeelColor(feel - 1)))
        }
        
        // Build up all the data entries for the chart
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<xValues.count {
            let chartEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(chartEntry)
        }
        
        // Set the dataset values and colors
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        chartDataSet.colors = chartColors
        
        // Set the values on the x-axis
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        // Set the values drawn on the chart to always have one decmial place
        // and at least one integer place
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.minimumIntegerDigits = 1
        let formatter = DefaultValueFormatter(formatter: numberFormatter)
        chartData.setValueFormatter(formatter)
        
        // Add the chart data to the chart for viewing
        self.data = chartData
    }
    
    // Initial setup that doesn't have to happen every time the data reloads
    func initialSetup() {
        // Set up some default chart values
        self.backgroundColor = UIColor(0xFFFFFF)
        self.chartDescription?.text = ""
        
        // Setup the axis
        self.xAxis.labelPosition = .bottom
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.granularity = 1
        self.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 8.0)!
        
        self.leftAxis.axisMinimum = 0
        self.rightAxis.axisMinimum = 0
        self.rightAxis.enabled = false
        
        self.legend.enabled = false
    }
}

//
//  StepChartView.swift
//  Pedometer
//
//  Created by PSG on 23/06/24.
//

import Foundation
import SwiftUI
import Charts

struct DailyStepChartView: View {
    let samples: [StepSample]
    
    private var hourlySamples: [StepSample] {
        var hourlyCounts = Array(repeating: 0, count: 24)
        
        for sample in samples {
            let hour = Calendar.current.component(.hour, from: sample.date)
            hourlyCounts[hour] += sample.count
        }
        
        let today = Date()
        var hourlyStepSamples = [StepSample]()
        
        for hour in 0..<24 {
            if let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: today) {
                hourlyStepSamples.append(StepSample(count: hourlyCounts[hour], date: date))
            }
        }
        
        return hourlyStepSamples
    }
    
    private var yAxisMaxValue: Int {
        let maxCount = hourlySamples.map { $0.count }.max() ?? 0
        let step = 2000 // Define the step size you want for the y-axis
        let buffer = step - (maxCount % step)
        return maxCount + buffer
    }
    
    var body: some View {
        Chart {
            ForEach(hourlySamples) { sample in
                BarMark(
                    x: .value("Hour", sample.date),
                    y: .value("Steps", sample.count)
                )
                .foregroundStyle(by: .value("Steps", sample.count))
            }
        }
        .chartForegroundStyleScale(range: Gradient(colors: [.red, .orange, .yellow, .green]))
        .padding()
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 1)) { value in
                if let date = value.as(Date.self) {
                    let hour = Calendar.current.component(.hour, from: date)
                    if [0, 6, 12, 18].contains(hour) {
                        AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .abbreviated)))
                    }
                }
            }
        }
        .chartYScale(domain: [0, yAxisMaxValue])
    }
}

struct Chart_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContainerView()
    }
}

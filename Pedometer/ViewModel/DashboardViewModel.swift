//
//  DashboardViewModel.swift
//  Pedometer
//
//  Created by PSG on 22/06/24.
//

import Foundation
import HealthKit

@MainActor
class DashboardViewModel: ObservableObject {
    @Published private var stepCount: Int = 0
    @Published var stepSamples: [StepSample] = []
    @Published var dailySteps: [DayStep] = []

    private var healthStore = HKHealthStore()

    func requestAuthorization() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        healthStore.requestAuthorization(toShare: nil, read: [stepType]) { success, error in
            if success {
                self.fetchStepsWithTimestamps()
                self.fetchWeeklySteps()
            } else {
                // Handle the error here.
            }
        }
    }
    
    func fetchStepsWithTimestamps() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKSampleQuery(sampleType: stepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKQuantitySample] else {
                // Handle the error here.
                return
            }

            let stepSamples = samples.map { sample in
                StepSample(count: Int(sample.quantity.doubleValue(for: HKUnit.count())), date: sample.startDate)
            }

            self.stepSamples = stepSamples
        }

        healthStore.execute(query)
    }
    
    func fetchWeeklySteps() {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        var dailySteps: [DayStep] = []
        let weekdaySymbols = DateFormatter().weekdaySymbols
        
        let group = DispatchGroup()
        
        for dayOffset in 0..<7 {
            group.enter()
            let day = calendar.date(byAdding: .day, value: -dayOffset, to: startOfDay)!
            let predicate = HKQuery.predicateForSamples(withStart: day, end: calendar.date(byAdding: .day, value: 1, to: day))
            
            let query = HKStatisticsQuery(quantityType: HKQuantityType.quantityType(forIdentifier: .stepCount)!, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
                
                var stepCount = 0
                if let quantity = result?.sumQuantity() {
                    stepCount = Int(quantity.doubleValue(for: HKUnit.count()))
                }
                
                let dayName = weekdaySymbols?[calendar.component(.weekday, from: day) - 1] ?? ""
                let step = DayStep(day: dayName, count: stepCount)
                dailySteps.append(step)
                
                group.leave()
            }
            
            healthStore.execute(query)
        }
        
        group.notify(queue: .main) {
            // Sort the dailySteps array based on weekday index (1 for Monday, 2 for Tuesday, ..., 7 for Sunday)
            dailySteps.sort { self.weekdayIndex(for: $0.day) < self.weekdayIndex(for: $1.day) }
            
            // Move today's DayStep to the end of the array
            if let todayIndex = dailySteps.firstIndex(where: { $0.day == weekdaySymbols?[calendar.component(.weekday, from: now) - 1] }) {
                let todayStep = dailySteps.remove(at: todayIndex)
                dailySteps.append(todayStep)
            }
            
            // Assign the sorted array to your property
            self.dailySteps = dailySteps
        }
    }

    private func weekdayIndex(for weekdayString: String) -> Int {
        let calendar = Calendar.current
        if let weekdaySymbols = DateFormatter().weekdaySymbols {
            if let index = weekdaySymbols.firstIndex(of: weekdayString) {
                return calendar.firstWeekday == 1 ? index + 1 : index % 7 + 1
            }
        }
        return 0
    }

}

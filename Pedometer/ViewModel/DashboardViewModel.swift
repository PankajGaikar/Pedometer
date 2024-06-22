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

    private var healthStore = HKHealthStore()

    func requestAuthorization() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        healthStore.requestAuthorization(toShare: nil, read: [stepType]) { success, error in
            if success {
                self.fetchStepsWithTimestamps()
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
}

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
    @Published var stepCount: Int = 0

    private var healthStore = HKHealthStore()

    func requestAuthorization() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        healthStore.requestAuthorization(toShare: nil, read: [stepType]) { success, error in
            if success {
                self.fetchStepCount()
            } else {
                // Handle the error here.
            }
        }
    }

    func fetchStepCount() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                // Handle the error here.
                return
            }
            self.stepCount = Int(sum.doubleValue(for: HKUnit.count()))
                // Add additional code here to fetch other statistics like calories, distance, and active minutes
        }

        healthStore.execute(query)
    }
    
    
}

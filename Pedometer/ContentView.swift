//
//  ContentView.swift
//  Pedometer
//
//  Created by Pankaj Gaikar on 21/06/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    private var healthStore = HKHealthStore()
    @State private var stepCount: Int = 0
    @State private var caloriesBurned: Double = 0.0
    @State private var distanceWalked: Double = 0.0
    @State private var activeMinutes: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                
                
                Spacer()
                
                // Main Step Count Display
                Text("\(stepCount)")
                    .font(.system(size: 72, weight: .bold))
                    .padding()
                
                Text("Steps")
                    .font(.title)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .navigationTitle("Pedometer")
        }
        .onAppear(perform: requestAuthorization)
    }

    func requestAuthorization() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        healthStore.requestAuthorization(toShare: nil, read: [stepType]) { success, error in
            if success {
                fetchStepCount()
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
            DispatchQueue.main.async {
                stepCount = Int(sum.doubleValue(for: HKUnit.count()))
                // Add additional code here to fetch other statistics like calories, distance, and active minutes
            }
        }

        healthStore.execute(query)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

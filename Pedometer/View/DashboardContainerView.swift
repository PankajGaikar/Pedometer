//
//  ContentView.swift
//  Pedometer
//
//  Created by Pankaj Gaikar on 21/06/24.
//

import SwiftUI
import HealthKit
import Charts

struct DashboardContainerView: View {
    
    @StateObject var viewModel: DashboardViewModel = DashboardViewModel()
    @State private var showWeeklyGoalSummary = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ThreeQuarterCircleProgressView(progress: Double(viewModel.stepSamples.reduce(0) { $0 + $1.count }), total: 10000)
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
                        .padding(.top)
                    
                    DailyStepChartView(samples: viewModel.stepSamples)
                        .frame(height: UIScreen.main.bounds.width * 0.6)
                        .padding(.horizontal)
                    
                    // Toggle view with animation
                    if showWeeklyGoalSummary {
                        WeeklyGoalSummaryView(dailySteps: viewModel.dailySteps)
                            .padding()
                            .transition(.opacity)
                    } else {
                        WeeklyGoalTrackerView(dailySteps: viewModel.dailySteps)
                            .padding()
                            .transition(.opacity)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Pedometer")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: viewModel.requestAuthorization)
        .onTapGesture {
            withAnimation {
                showWeeklyGoalSummary.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContainerView()
    }
}

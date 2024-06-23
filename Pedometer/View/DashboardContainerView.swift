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
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    DatePickerView(selectedDate: $selectedDate)

                    ThreeQuarterCircleProgressView(progress: Double(viewModel.dailySteps.reduce(0) { $0 + $1.count }), total: 10000)
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
                        .padding(.top)
                    
                    DailyStepChartView(samples: viewModel.dailySteps)
                        .frame(height: UIScreen.main.bounds.width * 0.6)
                        .padding(.horizontal)
                    
                    // Toggle view with animation
                    if showWeeklyGoalSummary {
                        WeeklyGoalSummaryView(dailySteps: viewModel.weeklySteps)
                            .padding()
                            .transition(.opacity)
                            .onTapGesture {
                                withAnimation {
                                    showWeeklyGoalSummary.toggle()
                                }
                            }
                    } else {
                        WeeklyGoalTrackerView(dailySteps: viewModel.weeklySteps)
                            .padding()
                            .transition(.opacity)
                            .onTapGesture {
                                withAnimation {
                                    showWeeklyGoalSummary.toggle()
                                }
                            }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Pedometer")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: viewModel.requestAuthorization)
        .onChange(of: selectedDate) { _ in
            // Add your action here
            print("Selected date changed to: \(selectedDate)")
            viewModel.date = selectedDate
            viewModel.fetchStepsWithTimestamps()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContainerView()
    }
}

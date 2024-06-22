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
    
    var body: some View {
        NavigationStack {
            VStack {
                ThreeQuarterCircleProgressView(progress: Double(viewModel.stepSamples.reduce(0) { $0 + $1.count }), total: 10000)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
                    .padding(.top)
                
                DailyStepChartView(samples: viewModel.stepSamples)
                    .frame(height: UIScreen.main.bounds.width * 0.6)
                    .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("Pedometer")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: viewModel.requestAuthorization)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContainerView()
    }
}

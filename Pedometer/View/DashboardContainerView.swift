//
//  ContentView.swift
//  Pedometer
//
//  Created by Pankaj Gaikar on 21/06/24.
//

import SwiftUI
import HealthKit

struct DashboardContainerView: View {

    @StateObject var viewModel: DashboardViewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ThreeQuarterCircleProgressView(progress: Double(viewModel.stepCount), total: 10000)
                    .padding(.top)
                
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

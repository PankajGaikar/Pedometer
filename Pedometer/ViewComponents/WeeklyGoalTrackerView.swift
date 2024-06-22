//
//  WeeklyGoalTrackerView.swift
//  Pedometer
//
//  Created by PSG on 23/06/24.
//

import Foundation
import SwiftUI

struct WeeklyGoalTrackerView: View {
    let dailySteps: [DayStep]
    let goal: Int = 10000
    
    var body: some View {
        VStack {
            Text("Weekly Goals")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 20) {
                ForEach(dailySteps) { step in
                    DayRing(title: String(step.day.prefix(1)), currentCount: step.count, goalCount: 10000)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .shadow(radius: 5)
            )
        }
    }
}

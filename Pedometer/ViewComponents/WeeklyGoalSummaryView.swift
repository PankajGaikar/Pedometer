//
//  WeeklyGoalSummaryView.swift
//  Pedometer
//
//  Created by PSG on 23/06/24.
//

import Foundation
import SwiftUI

struct WeeklyGoalSummaryView: View {
    let dailySteps: [DayStep]
    let goal: Int = 10000
    
    var body: some View {
        VStack {
            
            Text("Weekly Goals Summary")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                
                
                ForEach(dailySteps) { step in
                    HStack {
                        Text(step.day)
                            .font(.headline)
                        Spacer()
                        Text("\(step.count) steps")
                        if step.count >= goal {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
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

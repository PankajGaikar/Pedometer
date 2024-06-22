//
//  DayRingView.swift
//  Pedometer
//
//  Created by PSG on 23/06/24.
//

import Foundation
import SwiftUI

struct DayRing: View {
    let title: String
    let currentCount: Int
    let goalCount: Int
    
    var emoji: String {
        currentCount >= 10000 ? "✓" : "✗"
    }
    
    var completionPercentage: CGFloat {
        guard goalCount > 0 else { return 0 }
        let percentage = CGFloat(currentCount) / CGFloat(goalCount)
        return min(max(percentage, 0), 1) // Ensure the percentage is between 0 and 1
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                
                Text(emoji)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if completionPercentage >= 1.0 {
                    Circle()
                        .trim(from: 0.0, to: 1.0)
                        .stroke(Color.green, lineWidth: 4)
                        .rotationEffect(.degrees(-90))
                } else {
                    Circle()
                        .trim(from: 0.0, to: completionPercentage)
                        .stroke(Color.red, lineWidth: 4)
                        .rotationEffect(.degrees(-90))
                }
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}


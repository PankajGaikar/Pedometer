//
//  ThreeQuarterCircleProgressView.swift
//  Pedometer
//
//  Created by PSG on 22/06/24.
//

import SwiftUI

struct ThreeQuarterCircleProgressView: View {
    var progress: Double
    var total: Double

    private var progressColor: Color {
        switch progress / total {
        case 0..<0.5:
            return .red
        case 0.5..<1:
            return .orange
        default:
            return .green
        }
    }
    
    private var clampedProgress: Double {
        min(progress, total)
    }
    
    var body: some View {
        ZStack {
            ThreeQuarterCircleShape()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
            
            ThreeQuarterCircleShape(progress: clampedProgress / total)
                .stroke(progressColor, lineWidth: 20)
                .animation(.easeInOut(duration: 1), value: clampedProgress / total)
            
            VStack {
                Text("\(Int(progress))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(progressColor)
                
                Text("Steps")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.7, height:  UIScreen.main.bounds.width * 0.7)
    }
}

struct ThreeQuarterCircleShape: Shape {
    var progress: Double = 1.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: .degrees(135),
                    endAngle: .degrees(135 + 270 * progress),
                    clockwise: false)
        return path
    }
}

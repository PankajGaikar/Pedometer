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
                .stroke(Color.gray.opacity(0.3), lineWidth: 30)
            
            ThreeQuarterCircleShape(progress: clampedProgress / total)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(hex: "ED4D4D"), location: 0.0),
                            .init(color: Color(hex: "E59148"), location: 0.25),
                            .init(color: Color(hex: "EFBF39"), location: 0.5),
                            .init(color: Color(hex: "EEED56"), location: 0.75),
                            .init(color: Color(hex: "32E1A0"), location: 1.0)
                        ]),
                        center: .center,
                        startAngle: .degrees(135),
                        endAngle: .degrees(405)
                    ),
                    lineWidth: 30
                )
                .animation(.easeInOut(duration: 1), value: clampedProgress / total)
            
                ZStack {
                    VStack {
                        Text("\(Int(progress))")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(progressColor)
                        
                        Text("Steps")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    VStack {
                        Spacer()
                        
                        Text("from \(Int(total))")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.bottom)
                    }
            }
        }
        .padding()
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

struct ContentView_1Previews: PreviewProvider {
    static var previews: some View {
        DashboardContainerView()
    }
}

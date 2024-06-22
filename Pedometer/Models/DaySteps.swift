//
//  DaySteps.swift
//  Pedometer
//
//  Created by PSG on 23/06/24.
//

import Foundation

struct DayStep: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

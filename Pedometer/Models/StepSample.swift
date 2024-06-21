//
//  StepSample.swift
//  Pedometer
//
//  Created by PSG on 22/06/24.
//

import Foundation

struct StepSample: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

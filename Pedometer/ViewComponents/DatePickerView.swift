//
//  DatePickerView.swift
//  Picture of the Day
//
//  Created by Pankaj Gaikar on 07/05/24.
//

import Foundation
import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    let startDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 16))!
    let endDate = Date()

    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    //ApodAnalytics().report("history_button_left")
                    self.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate) ?? Date()
                }) {
                    Image(systemName: "chevron.left")
                }
                .padding()
                
                DatePicker("", selection: $selectedDate, in: startDate...endDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)

                Button(action: {
                    //ApodAnalytics().report("history_button_left")
                    self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate) ?? Date()
                }) {
                    Image(systemName: "chevron.right")
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .padding()
    }
}

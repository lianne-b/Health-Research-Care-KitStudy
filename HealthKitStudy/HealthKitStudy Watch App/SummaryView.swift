//
//  SummaryView.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import SwiftUI
import HealthKit

struct SummaryView: View {
    
    // a DateComponentsFormatter that displays hrs, secs, mins separated by colons and pad zeros.
    @State private var durationFormatter:
    DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                SummaryMetricView(
                    title: "Total Time",
                    value: durationFormatter.string(from: 30 * 60 + 15) ?? ""
                )
                .accentColor(.yellow)
                
                SummaryMetricView(
                    title: "Total Distance",
                    value: Measurement(
                        value: 1635,
                        unit: UnitLength.meters
                    )
                    .formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .road)
                    )
                )
                .accentColor(.green)
                
                SummaryMetricView(
                    title: "Total Energy",
                    value: Measurement(
                        value: 96,
                        unit: UnitEnergy.kilocalories
                    )
                    .formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout,
                            numberFormatStyle: .number)
                    )
                )
                .accentColor(.pink)
                
                SummaryMetricView(
                    title: "Avg. Heart Rate",
                    value: 103
                        .formatted(
                            .number.precision(
                                .fractionLength(0))
                        )
                    + " bpm"
                )
                .accentColor(.red)
                
                Text("Activity Rings")
                ActivityRingsView(healthStore: HKHealthStore())
                    .frame(width: 50, height: 50)
            
                Button {
                } label: {
                    Text("Done")
                }

            }
            .scenePadding()
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

struct SummaryMetricView: View {
    var title: String // describes the metric
    var value: String // a value string of the metric
    
    var body: some View {
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                .lowercaseSmallCaps()
            )
            .foregroundColor(.accentColor)
        Divider()
    }
}

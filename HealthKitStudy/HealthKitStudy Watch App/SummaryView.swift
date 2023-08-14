//
//  SummaryView.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import SwiftUI
import HealthKit

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var workoutManager: WorkoutManager
    
    // a DateComponentsFormatter that displays hrs, secs, mins separated by colons and pad zeros.
    @State private var durationFormatter:
    DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        // display the ProgressView until workoutManager has the HKWorkout assigned when the builder finishes saving the workout.
        if workoutManager.workout == nil {
            ProgressView("Saving workout")
                .navigationBarHidden(true)
        } else {
            ScrollView {
                VStack(alignment: .leading) {
                    SummaryMetricView(
                        title: "Total Time",
                        value: durationFormatter.string(
                            from: workoutManager.workout?.duration ?? 0.0
                        ) ?? ""
                    )
                    .accentColor(.yellow)
                    
                    SummaryMetricView(
                        title: "Total Distance",
                        value: Measurement(
                            value: workoutManager.workout?.totalDistance?.doubleValue(
                                for: .meter()
                            ) ?? 0,
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
                            value: workoutManager.workout?.totalEnergyBurned?.doubleValue(
                                for: .kilocalorie()
                            ) ?? 0,
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
                        value: workoutManager.averageHeartRate
                            .formatted(
                                .number.precision(
                                    .fractionLength(0))
                            )
                        + " bpm"
                    )
                    .accentColor(.red)
                    
                    Text("Activity Rings")
                    // only need single HKHealthStore per app.
                    /// HealthStore() -> workoutManager.healthStore
                    ActivityRingsView(healthStore: workoutManager.healthStore)
                        .frame(width: 50, height: 50)
                    
                    Button {
                        dismiss()
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

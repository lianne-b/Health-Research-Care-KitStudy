//
//  MetricsView.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        // The builder’s elapsed time variable isn’t published, so our view currently will not update when builder’s elapsedTime updates, so we wrapped the Vstack in TimelineView.
        TimelineView(
            MetricsTimelineSchedule(
                from: workoutManager.builder?.startDate ?? Date()
            )
        ) { context in
            VStack(alignment: .leading) {
                
                ElapsedTimeView(
                    elapsedTime:  workoutManager.builder?.elapsedTime ?? 0,
                    showSubSeconds: true
                )
                .foregroundColor(.yellow)
               
                // measurement uses the new formatted function which abbreviates the unit of workouts & number to trim fractions.
                Text(
                    Measurement(
                        value: workoutManager.activeEnergy,
                        unit: UnitEnergy.kilocalories
                    )
                    .formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout,
                            numberFormatStyle: .number
                        )
                    )
                )
                
                Text(
                    workoutManager.heartRate
                        .formatted(
                            .number.precision(.fractionLength(0))
                        )
                    + " bpm"
                )
                
                Text(
                    Measurement(
                        value: workoutManager.distance,
                        unit: UnitLength.meters
                    )
                    .formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .road // naturally progressing imperial or metric units based on locale.
                        )
                    )
                )
            }
            .font(.system(.title, design: .rounded)
                .monospacedDigit()
                .lowercaseSmallCaps()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding() // 이건 머징. to align metrics with navigation title

        }
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}


private struct MetricsTimelineSchedule: TimelineSchedule {
    // MetricsTimelineSchedule has a startDate for when the schedule should start.
    var startDate: Date
    // Its initializer takes a startDate.
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    // MetricsTimelineSchedule implements the entries function to produce PeriodicTimelineSchedule entries.
    // The function creates a PeriodicTimelineSchedule using the startDate.
    /// When the TimelineScheduleMode is lowFrequency, the TimelineSchedule interval is one second.
    func entries(from startDate: Date,
                 mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        ///
        PeriodicTimelineSchedule(from: self.startDate,
                                 by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        )
        .entries(from: startDate,
                 mode: mode
        )
        
    }
}

//
//  MetricsView.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import SwiftUI

struct MetricsView: View {
    var body: some View {
        VStack(alignment: .leading) {
         
            ElapsedTimeView(
                elapsedTime:  3 * 60 + 15.24,
                showSubSeconds: true
            )
            .foregroundColor(.yellow)
           
            // measurement uses the new formatted function which abbreviates the unit of workouts & number to trim fractions.
            Text(
                Measurement(
                    value: 47,
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
                153.formatted(
                    .number.precision(.fractionLength(0))
                )
                + " bpm"
            )
            
            Text(
                Measurement(
                    value: 515,
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

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}

//
//  HealthKitIntitialTestingView.swift
//  HealthKitStudy
//
//  Created by Ye Eun Choi on 2023/06/27.
//

import SwiftUI
import HealthKit

struct HealthKitIntitialTestingView: View {
    var body: some View {
        VStack {
            
            // MARK: - isHealthDataAvailable (Method)
            /// Call this method before calling any other HealthKit methods.
            if HKHealthStore.isHealthDataAvailable() {
                Text("Hello")
            }
        }
    }
}

struct HealthKitIntitialTestingView_Previews: PreviewProvider {
    static var previews: some View {
        HealthKitIntitialTestingView()
    }
}

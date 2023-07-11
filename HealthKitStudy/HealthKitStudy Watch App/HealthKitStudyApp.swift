//
//  HealthKitStudyApp.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import SwiftUI

@main
struct HealthKitStudy_Watch_AppApp: App {
    @StateObject var workoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .environmentObject(workoutManager)
        }
    }
}

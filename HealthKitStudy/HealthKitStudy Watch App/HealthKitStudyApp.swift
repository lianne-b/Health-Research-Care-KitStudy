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
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView, content: {
                SummaryView()
            })
            .environmentObject(workoutManager)
        }
        
//        WKNotificationScene(controller: NotificationController.self, category: "MyCategory")
    }
}

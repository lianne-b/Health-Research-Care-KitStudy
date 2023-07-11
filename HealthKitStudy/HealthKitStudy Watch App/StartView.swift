//
//  ContentView.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import SwiftUI
import HealthKit

struct StartView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var workoutTypes: [HKWorkoutActivityType] = [.cycling, .running, .walking]
    
    var body: some View {
        List(workoutTypes) { workoutType in
            NavigationLink(
                workoutType.name,
                destination: SessionPagingView(),
                tag: workoutType,
                selection: $workoutManager.selectedWorkout
            ) // 네비링크가 눌릴 때마다 selectedWorkout가 업데이트됨
            .padding(
                EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5)
            )
        }
        .listStyle(.carousel)
        .navigationBarTitle("Workouts")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}



struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(WorkoutManager())
    }
}



// make HKWorkoutActivityType enum accessiable by conforming to the identifiable protocol and add a name variable.
extension HKWorkoutActivityType: Identifiable {
    
    /// the ID-computed variable will return the rawValue of the enum.
    public var id: UInt {
        rawValue
    }
    
    /// The name variable switch through the cases to return a name like "Cycle."
    var name: String {
        switch self {
        case .cycling:
            return "Cycle"
        case .running:
            return "Run"
        case .walking:
            return "Walk"
        default:
            return ""
        }
    }
}

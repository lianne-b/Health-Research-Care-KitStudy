//
//  WorkoutManager.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    // to track the selected workout.
    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout = selectedWorkout else { return }
            // whenever selectedWorkout changes, call startWorkout.
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    // MARK: - start workout (Method)
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor // location type determines how HKWorkoutSession & HKLiveWorkoutBuilder behaves.
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            /// handle any exceptions.
            return
        }
        
        // HKLiveWorkoutDataSource automatically provides live data from an active workout session.
        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            /// The workout has started.
        }
    }
    
    
    // MARK: - request authorization (method)
    func requestAuthorization() {
        // the quantity type to write to the health store.
        let typeToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // the quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType() // permission to read activityRing summary
        ]
        
        // request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typeToShare, read: typesToRead) { (success, error) in
            /// handle error
        }
    }
}

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
    
    // provides binding for sheet's selection on our app's naivgation view.
    @Published var showingSummaryView: Bool = false {
        didSet {
            // Sheet dismissed.
            if showingSummaryView == false {
                resetWorkout()
            }
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
        
        // Make sure to assign workoutmanager as the HKWorkoutSession delegate.
        session?.delegate = self
        
        // WorkoutManger needs to observe workout samples added to the builder by being an HKLiveWorkoutBuilderDelegate.
        builder?.delegate = self
        
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            /// The workout has started.
        }
    }
    
    
    // MARK: - request authorization (method)
    func requestAuthorization() {
        print(#function, "호출함?")
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
            dump(success)
        }
    }
    
    // MARK: - State Control
    /// session state control logic
    
    // The workout session state.
    @Published var running = false // tracks if the session is running
    
    func pause() {
        session?.pause()
    }
    
    func resume() {
        session?.resume()
    }
    
    // either pause or resume the session.
    func togglePause() {
        if running == true {
            pause()
        } else {
            resume()
        }
    }
    
    func endWorkout() {
        session?.end()
        // in endWorkout, set showingSummary to true.
        showingSummaryView = true
    }
    
    
    // MARK: - Workout Metrics
    /// WorkoutManager will expose published workout metrics that MetricsView and SummaryView can observe.
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout? // HKWorkout to be used in the SummaryView.
    
    // takes an optional HKStatistics object as parameter.
    func updateForStatistics(_ statistics: HKStatistics?) {
        // a guard early returns if statistics is nil.
        guard let statistics = statistics else { return }
        
        // dispatch the metric updates asynchronously to the main queue, switch through each quantity type.
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
    
    // when the SummaryView dismisses, we need to reset our model.
    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        session = nil
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
    
}



// MARK: - HKWorkoutSessionDelegate
/// Linking to the HKWorkoutSessionDelegate to listen for changes in session state.
extension WorkoutManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        // the running variable will update based on if the toState is running and is dispatched to the main queue for UI updates.
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        // Wait for the session to transition states before ending the builder.
        /// when the session transitions to ended, call endCollection on the builder with the end date providted to stop collecting workout samples.
        /// Once endCollection finishes, call finishWorkout to save the HKWorkout to the Health database.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (sucess, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        // When the builder has finished saving the workout, assign the workout to WorkoutManager when builder’s finishWorkout function completes.
                        /// we do this on the main queue for UI updates.
                        self.workout = workout
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print(error)
    }
}


extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    // is called whenver builder collects an event.
    /// leave it empty for our app.
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
    
    // is called whenever the builder collects new samples.
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder,
                        didCollectDataOf collectedTypes: Set<HKSampleType>) {
        // iterate over each type in collectedTypes.
        /// the guard ensures the collected type is an HKQuantityType
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            
            // statistics are read from the builder for that quantity type.
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            // update the published metrics values.
            updateForStatistics(statistics)
        }
    }
}

//
//  HealthKitManager.swift
//  MoveIt
//
//  Created by Yifan Li on 11/17/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import Foundation
import HealthKit

let healthKitStore: HKHealthStore = HKHealthStore()

class HealthKitManager {
    var steps: Int = 0
    func authorizeHealthKit(to homeController: HomeController) {
        let stepCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let height = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weight = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        
        let dataTypesToRead: Set<HKObjectType> = [stepCount]
        let dataTypesToWrite: Set<HKSampleType> = [height, weight]
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Cannot access HealthKit")
            return
        }
        
        healthKitStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead)
        { (success, error) -> Void in
            print("R/W authorized.")
            self.readHealthData(to: homeController)
        }
    }
    
    
    func readHealthData(to homeController: HomeController) {
        guard let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        guard let exactlySixDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -6), to: now) else { return }
        let startOfSixDaysAgo = Calendar.current.startOfDay(for: exactlySixDaysAgo)
        let predicate = HKQuery.predicateForSamples(withStart: startOfSixDaysAgo, end: now, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: stepCount, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startOfSixDaysAgo, intervalComponents: DateComponents(day: 1))
        query.initialResultsHandler = { _, results, error in
            if let error = error {
                print("Failed to query steps from HealthKit<##>", error)
                return
            }
            var weeklySteps = [Int]()
            results?.enumerateStatistics(from: startOfSixDaysAgo, to: now, with: { (statistics, stop) in
                if let quantity = statistics.sumQuantity() {
                    let dailySteps = quantity.doubleValue(for: HKUnit.count())
                    weeklySteps.append(Int(dailySteps))
                }
            })
            DispatchQueue.main.async {
                homeController.weeklySteps = weeklySteps
                let dailyStepRemaining = homeController.dailyStepsGoal - (weeklySteps.last ?? 0)
                homeController.goalBtn.text = (dailyStepRemaining <= 0) ? "Good job! Daily goal achieved!" : "Only \(dailyStepRemaining) steps from your daily goal"
                let streaks = weeklySteps.reversed().prefix(while: { $0 >= homeController.dailyStepsGoal }).count
                homeController.streakBtn.text = "On a \(streaks) day streak of meeting daily goal!"
            }
        }
        healthKitStore.execute(query)
        
    }
    
}

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
    func authorizeHealthKit() {
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
        }
    }
    
    
    func readHealthData() {
        guard let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        guard let exactlySevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: now) else { return }
        let startOfSevenDaysAgo = Calendar.current.startOfDay(for: exactlySevenDaysAgo)
        let predicate = HKQuery.predicateForSamples(withStart: startOfSevenDaysAgo, end: now, options: .strictStartDate)
        //        let query = HKStatisticsQuery(quantityType: stepCount, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, _) in
        //            guard let sum = result?.sumQuantity() else {
        //                return
        //            }
        //            print(sum.doubleValue(for: HKUnit.count()))
        //        }
        
        let query = HKStatisticsCollectionQuery(quantityType: stepCount, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startOfSevenDaysAgo, intervalComponents: DateComponents(day: 1))
        query.initialResultsHandler = { _, results, error in
            if let error = error {
                print("Failed to query steps from HealthKit<##>", error)
                return
            }
            var weeklySteps = [Double]()
            results?.enumerateStatistics(from: startOfSevenDaysAgo, to: now, with: { (statistics, stop) in
                if let quantity = statistics.sumQuantity() {
                    let dailySteps = quantity.doubleValue(for: HKUnit.count())
                    weeklySteps.append(dailySteps)
                }
            })
//            TODO: - do something with weeklySteps
        }
        healthKitStore.execute(query)
        
    }
    
}

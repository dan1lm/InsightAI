//
//  HealthManager.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/18/24.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}


class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var activities: [String : Activity] = [:]
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let sleepType = HKCategoryType(.sleepAnalysis)
        let distanceWalkingRunning = HKQuantityType(.distanceWalkingRunning)
        
        let healthTypes: Set = [steps, calories, sleepType, distanceWalkingRunning]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchSleepData()
                fetchWalkingDistance()
            }
            catch {
                print("error while fetching health data")
            }
        }
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) {_, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays step data")
                return
            }
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: stepCount.formattedString())
            DispatchQueue.main.async{
                self.activities["todaySteps"] = activity
            }
            
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) {_, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays calorie data")
                return
            }
            
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Today calories", subtitle: "Goal: 950", image: "flame", amount: caloriesBurned.formattedString())
            DispatchQueue.main.async{
                self.activities["todayCalories"] = activity
            }
            
        }
        healthStore.execute(query)
        
    }
    
    
    func fetchSleepData() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!

        let calendar = Calendar.current
        let now = Date()

        // Define time range for the previous night (6 PM to 10 AM the next day)
        let startOfPreviousNight = calendar.date(bySettingHour: 22, minute: 0, second: 0, of: now.addingTimeInterval(-86400))!
        let endOfPreviousNight = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: now)!


        let predicate = HKQuery.predicateForSamples(withStart: startOfPreviousNight, end: endOfPreviousNight, options: .strictStartDate)
        
        // Query for sleep data
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("Error fetching sleep data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Filter samples to include only those from Apple Health
            let filteredSamples = samples.filter { sample in
                let source = sample.sourceRevision.source.bundleIdentifier
                return source.starts(with: "com.apple.health") ?? false
            }

            // Initialize variables to track different sleep states
            var remSleepSeconds: TimeInterval = 0
            var deepSleepSeconds: TimeInterval = 0
            var coreSleepSeconds: TimeInterval = 0
            var awakeningsCount = 0
            var totalSleepSeconds: TimeInterval = 0

            // Process the filtered samples and calculate sleep durations
            for sample in filteredSamples {
                let value = sample.value
                let duration = sample.endDate.timeIntervalSince(sample.startDate)

                switch value {
                case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                    remSleepSeconds += duration
                case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                    coreSleepSeconds += duration
                case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                    deepSleepSeconds += duration
                case HKCategoryValueSleepAnalysis.awake.rawValue:
                    awakeningsCount += 1
                default:
                    break
                }
            }

            // Calculate total sleep time
            totalSleepSeconds = deepSleepSeconds + coreSleepSeconds + remSleepSeconds

            // Convert total sleep time to hours
            let sleepHours = totalSleepSeconds / 3600
            
            // Create an Activity object to update UI
            let activity = Activity(id: 2, title: "Total Sleep", subtitle: "Last Night", image: "bed.double.fill", amount: "\(String(format: "%.1f", sleepHours)) hours")
            
            // Update the UI with sleep data
            DispatchQueue.main.async {
                self.activities["sleepTime"] = activity
            }

            // Optionally, print out the detailed sleep info for debugging
            print("REM Sleep: \(remSleepSeconds / 3600) hours")
            print("Deep Sleep: \(deepSleepSeconds / 3600) hours")
            print("Core Sleep: \(coreSleepSeconds / 3600) hours")
            print("Awakenings: \(awakeningsCount)")
            print("Total Sleep: \(sleepHours) hours")
        }

        // Execute the query
        healthStore.execute(query)
    }

    
    
    func fetchWalkingDistance() {
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching walking distance data")
                return
            }
            let distance = quantity.doubleValue(for: .meter()) / 1000 // Convert to kilometers
            let activity = Activity(id: 3, title: "Walking Distance", subtitle: "Today", image: "figure.walk", amount: "\(String(format: "%.2f", distance)) km")
            DispatchQueue.main.async {
                self.activities["walkingDistance"] = activity
            }
        }
        healthStore.execute(query)
    }


    
    
    
}



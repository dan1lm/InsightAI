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
        let heartRate = HKQuantityType(.heartRate)
        let distanceWalkingRunning = HKQuantityType(.distanceWalkingRunning)
        
        let healthTypes: Set = [steps, calories, heartRate, distanceWalkingRunning]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchHeartRate()
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
    
    
    func fetchHeartRate() {
        let heartRate = HKQuantityType(.heartRate)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: heartRate, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.averageQuantity(), error == nil else {
                print("Error fetching heart rate data")
                return
            }
            let avgHeartRate = quantity.doubleValue(for: .count().unitDivided(by: .minute()))
            let activity = Activity(id: 2, title: "Average Heart Rate", subtitle: "Today", image: "heart.fill", amount: "\(Int(avgHeartRate)) BPM")
            DispatchQueue.main.async {
                self.activities["heartRate"] = activity
            }
        }
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



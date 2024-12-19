//
//  HealthManager.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/18/24.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    init() {
        let steps = HKQuantityType(.stepCount)
        
        let healthTypes: Set = [steps]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            }
            catch {
                print("error while fetching health data")
            }
        }
    }
}

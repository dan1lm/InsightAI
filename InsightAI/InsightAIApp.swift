//
//  InsightAIApp.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/18/24.
//

import Spezi
import SwiftUI
import HealthKit

@main
struct InsightAIApp: App {
    @ApplicationDelegateAdaptor(SpeziAppDelegate.self) var appDelegate
    @StateObject var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            InsightAITabView()
                .environmentObject(manager)
                .spezi(appDelegate)
        }
    }
}

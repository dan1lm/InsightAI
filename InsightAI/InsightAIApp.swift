//
//  InsightAIApp.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/18/24.
//

import SwiftUI

@main
struct InsightAIApp: App {
    @StateObject var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            InsightAITabView()
                .environmentObject(manager)
        }
    }
}

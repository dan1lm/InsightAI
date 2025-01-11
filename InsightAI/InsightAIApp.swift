//
//  InsightAIApp.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/18/24.
//

import Spezi
import SwiftUI
import HealthKit
import SpeziLLM
import SpeziLLMLocal

@main
struct InsightAIApp: App {
    //@ApplicationDelegateAdaptor(SpeziAppDelegate.self) var appDelegate
    @ApplicationDelegateAdaptor(LocalLLMAppDelegate.self) var appDelegate
    @StateObject var manager = HealthManager()

    
    var body: some Scene {
        WindowGroup {
            //AskLLMView()
            InsightAITabView()
                .environmentObject(manager)
                .spezi(appDelegate)
            
        }
    }
}

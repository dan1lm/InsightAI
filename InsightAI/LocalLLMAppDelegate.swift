//
//  LocalLLMAppDelegate.swift
//  InsightAI
//
//  Created by Danil Merinov on 1/9/25.
//

import Foundation
import Spezi
import SpeziLLM
import SpeziLLMLocal

class LocalLLMAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration {
            // Configure the runner responsible for executing LLMs.
            LLMRunner {
                // Add your desired platform for LLM execution.
                LLMLocalPlatform() // Use LLMLocalPlatform for local execution.
            }
        }
    }
}

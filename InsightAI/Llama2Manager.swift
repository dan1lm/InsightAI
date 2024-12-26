//
//  Llama2Manager.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/25/24.
//

import Foundation
import LlamaStackClient



class Llama2Manager: ObservableObject {
    @Published var insights: [String] = []

    private var llamaClient: LlamaClient

    init(apiKey: String, modelName: String = "llama-2-7b") {
        llamaClient = LlamaClient(apiKey: apiKey, modelName: modelName)
    }

    func generateInsights(for activities: [Activity]) async {
        do {
            let inputText = activities.map { $0.description }.joined(separator: "\n")
            let response = try await llamaClient.generateResponse(prompt: inputText)

            DispatchQueue.main.async {
                self.insights = response.output.split(separator: "\n").map { String($0) }
            }
        } catch {
            print("Error generating insights: \(error)")
        }
    }
}

//
//  LLMDemoView.swift
//  InsightAI
//
//  Created by Danil Merinov on 1/9/25.
//

import SwiftUI
import Foundation
import Spezi
import SpeziLLM
import SpeziLLMLocal

struct LLMLocalDemoView: View {
    @Environment(LLMRunner.self) var runner
    @State var responseText = ""


    var body: some View {
        Text(responseText)
            .task {
                // Instantiate the `LLMLocalSchema` to an `LLMLocalSession` via the `LLMRunner`.
                let llmSession: LLMLocalSession = runner(
                    with: LLMLocalSchema(
                        modelPath: URL(string: "URL to the local model file")!
                    )
                )


                do {
                    for try await token in try await llmSession.generate() {
                        responseText.append(token)
                    }
                } catch {
                    // Handle errors here. E.g., you can use `ViewState` and `viewStateAlert` from SpeziViews.
                }
            }
    }
}


#Preview {
    LLMLocalDemoView()
}

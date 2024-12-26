//
//  HomeView.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/18/24.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    @StateObject var llama2Manager = Llama2Manager()

    var body: some View {
        VStack {
            Text("Quick Glance")
                .font(.headline)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                VStack {
                    // Display generated insights if available
                    if !llama2Manager.insights.isEmpty {
                        ForEach(llama2Manager.insights, id: \.self) { insight in
                            Text(insight)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.bottom, 10)
                        }
                    } else {
                        ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            ActivityCard(activity: item.value)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            if !manager.activities.isEmpty {
                llama2Manager.generateInsights(for: manager.activities)
            }
        }
    }
}

#Preview {
    HomeView()
}

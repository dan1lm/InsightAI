//
//  ContentView.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/18/24.
//

import SwiftUI
import HealthKit


struct ContentView: View {
    
    @ObservedObject var healthManager = HealthManager()

    var body: some View {
        VStack {
            Text("Quick Glance")
                .font(.headline)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                VStack {
                    ForEach(healthManager.activities.sorted(by: { $0.key < $1.key }), id: \.key) { key, activity in
                        ActivityCard(activity: activity)
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

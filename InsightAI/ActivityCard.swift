//
//  ActivityCard.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/18/24.
//

import SwiftUI

struct Activity {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let amount: String
}

struct ActivityCard: View {
    @State var activity: Activity
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.system(size: 16))
                        
                        Text(activity.subtitle)
                            .font(.system(size: 12))
                    }
                           
                    Spacer()
                           
                    Image(systemName: activity.image)
                        .foregroundColor(.blue)
                }
                
                Text(activity.amount).font(.system(size: 24))
            }
            .padding()
  
        }
    }
}

#Preview {
    ActivityCard(activity: Activity(id: 0, title: "Daily steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: "5,500"))
}

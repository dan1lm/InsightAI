//
//  ActivityCard.swift
//  InsightAI
//
//  Created by Danil Merinov on 12/18/24.
//

import SwiftUI

struct ActivityCard: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Steps")
                            .font(.system(size: 16))
                        
                        Text("Daily Goal: 10,000")
                            .font(.system(size: 12))
                    }
                           
                    Spacer()
                           
                    Image(systemName: "figure.walk")
                        .foregroundColor(.blue)
                }
                
                Text("5,500").font(.system(size: 24))
            }
            .padding()
  
        }
    }
}

#Preview {
    ActivityCard()
}

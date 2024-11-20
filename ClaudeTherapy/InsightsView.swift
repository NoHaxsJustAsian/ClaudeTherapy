//
//  InsightsView.swift
//  ClaudeTherapy
//
//  Created by Win Tongtawee on 11/19/24.
//

import SwiftUI

struct InsightsView: View {
    var body: some View {
        VStack {
            Text("Insights")
                .font(.largeTitle)
                .padding()

            Text("Coming Soon!")
                .font(.headline)
                .foregroundColor(.gray)

            Spacer()
        }
        .navigationTitle("Your Insights")
        .padding()
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView()
    }
}

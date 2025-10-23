//
//  NewsView.swift
//  Sprout
//
//  Created by Student1 on 22/10/2025.
//

import SwiftUI

struct NewsView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Start View")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

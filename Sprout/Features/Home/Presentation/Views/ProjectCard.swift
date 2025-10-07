//
//  ProjectCard.swift
//  Sprout
//
//  Created by Student1 on 07/10/2025.
//

import Foundation
import SwiftUI

struct ProjectCard: View {
    let project: Project
    @State private var animatedProgress: Double = 0.0
    
    var body: some View {
        HStack {
            if let urlString = project.imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading) {
                Text(project.title).font(.headline)
                ProgressView(value: animatedProgress)
                    .progressViewStyle(.linear)
                    .tint(.green)
                Text("\(Int(animatedProgress * 100))%")
                    .font(.subheadline)
            }
        }
        .onAppear {
            let progress = calculateProgress()
            withAnimation(.linear(duration: 1.0)) {
                animatedProgress = progress
            }
        }
    }
    
    private func calculateProgress() -> Double {
        let now = Date()
        if now < project.startDate { return 0.0 }
        if now > project.endDate { return 1.0 }
        let totalDuration = project.endDate.timeIntervalSince(project.startDate)
        if totalDuration <= 0 { return 0.0 }
        let elapsed = now.timeIntervalSince(project.startDate)
        return min(1.0, max(0.0, elapsed / totalDuration))
    }
}

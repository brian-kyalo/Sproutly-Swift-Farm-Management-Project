//
//  ProjectCard.swift
//  Sprout
//
//  Created by Student1 on 07/10/2025.
//

import Foundation
import SwiftUI

struct ProjectCard: View {
    //
    @Environment(\.colorScheme) var colorScheme
    var isDark: Bool { colorScheme == .dark }
    
    //
    let project: Project
    @State private var animatedProgress: Double = 0.0
    
    var body: some View {
        
        //
        VStack(alignment: .leading, spacing: 10) {
            Text(project.title)
                .font(.headline)
                .foregroundStyle(isDark ? .white : .black)
            
            //
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                        path.move(to: CGPoint(x: 0, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                    }
                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [5]))
                    if let urlString = project.imageUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
            .frame(height: 100)
            .cornerRadius(8)
            HStack {
                ProgressView(value: animatedProgress)
                    .progressViewStyle(.linear)
                    .tint(.green)
                    .frame(maxWidth: .infinity)
                Text("\(Int(animatedProgress * 100))%")
                    .font(.subheadline)
                    .foregroundColor(isDark ? .white : .black)
            }
        }
        .padding()
        .background(.ultraThinMaterial) //Custom IOS Blur effect
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
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

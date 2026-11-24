//
//  DashboardComponents.swift
//  Challenge2
//  Created by Miriam Stellato on 24/11/2026.
//

import SwiftUI

struct ProgressRow: View {
    let title: String
    let percentage: Double
    let color: Color
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)

                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(Int(percentage * 100))%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.18))

                    Capsule()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage)
                }
            }
            .frame(height: 10)
        }
    }
}

struct ActivityBar: View {
    let day: String
    let height: CGFloat
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(maxWidth: .infinity)
                .frame(height: height)

            Text(day)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressRow(title: "Words", percentage: 0.85, color: .blue, icon: "book.fill")
        HStack(alignment: .bottom, spacing: 12) {
            ActivityBar(day: "MON", height: 65, color: .blue)
            ActivityBar(day: "TUE", height: 95, color: .green)
            ActivityBar(day: "WED", height: 75, color: .orange)
        }
        .frame(height: 110)
    }
    .padding()
}

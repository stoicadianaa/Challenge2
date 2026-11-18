//
//  CategoryCard.swift
//  Challenge2
//
//  Created by Miriam Stellato on 18/11/2026.
//

import SwiftUI

struct CategoryCard: View {
    let title: String
    var mainSymbolText: String = ""
    var customCenterIcon: String? = nil
    let cardColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Spacer()
                
                if let customIcon = customCenterIcon {
                    Image(systemName: customIcon)
                        .font(.system(size: 45))
                        .foregroundColor(.white)
                } else {
                    Text(mainSymbolText)
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 220)
            .background(cardColor)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.4), lineWidth: 4)
            )
            .shadow(color: cardColor.opacity(0.4), radius: 8, x: 0, y: 6)
        }
            .buttonStyle(ScaleButtonStyle())
    }
}

//
//  HomeView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 18/11/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var waterDropsCount = 0
    
    private let gridColumns = [
        GridItem(.adaptive(minimum: 200), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                Spacer()
                
                VStack(spacing: 4) {
                    Text("Welcome to Wonderwood!")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        
                    Text("Choose a learning adventure:")
                        .font(.system(size: 32, weight: .medium, design: .rounded))
                }
                
                Spacer()
                
                LazyVGrid(columns: gridColumns, spacing: 20) {
                    CategoryCard(
                        title: "Words",
                        mainSymbolText: "Aa",
                        cardColor: Color(red: 0.35, green: 0.6, blue: 0.9)
                    ) {}
                    
                    CategoryCard(
                        title: "Numbers",
                        mainSymbolText: "1 2 3",
                        cardColor: Color(red: 0.45, green: 0.75, blue: 0.3)
                    ) {}
                    
                    CategoryCard(
                        title: "Logic",
                        mainSymbolText: "",
                        customCenterIcon: "lightbulb.fill",
                        cardColor: Color(red: 0.98, green: 0.72, blue: 0.3)
                    ) {}
                    
                    CategoryCard(
                        title: "Creativity",
                        mainSymbolText: "",
                        customCenterIcon: "paintpalette.fill",
                        cardColor: Color(red: 0.95, green: 0.5, blue: 0.45)
                    ) {}
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding()
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )

            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.blue)
                            Text("\(waterDropsCount)")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

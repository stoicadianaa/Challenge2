import SwiftUI

struct HomeView: View {
    @State private var waterDropsCount = 0
    
    private let gridColumns = [
        GridItem(.adaptive(minimum: 200), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // MARK: - Header with water count and settings button
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.blue)
                        Text("\(waterDropsCount)")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.white.opacity(0.9))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Spacer()
                    
                    // Settings button – now correctly placed in the toolbar
                    Button {
                        // TODO: add action
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.brown)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Spacer()
                
                // MARK: - Welcome text
                VStack(spacing: 4) {
                    Text("Welcome to Wonderwood!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                    
                    Text("Choose a learning adventure:")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                // MARK: - Category cards grid
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
                        mainSymbolText: "-->",
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
            // Navigation‑bar modifiers applied to the stack’s content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // The same button we already placed in the header can also live here
                    // (optional – keep one copy you prefer)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

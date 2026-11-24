//
//  ParentDashboardView.swift
//  Challenge2
//
//  Created by Miriam Stellato on 24/11/2026.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @AppStorage("soundEffectsEnabled")
    private var soundEffectsEnabled = true
    
    @State private var selectedChild = "Emma"
    private let children = ["Emma", "Oliver"]
    
    private var isWide: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: isWide ? 24 : 18) {
                    Image("mascot_genderless_neutral")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            maxWidth: isWide ? 180 : 130,
                            maxHeight: isWide ? 180 : 130
                        )
                        .accessibilityHidden(true)
                    
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Parent Dashboard")
                                    .font(
                                        .system(
                                            size: isWide ? 26 : 22,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundStyle(.primary)
                                
                                Text("See how your little explorer is growing!")
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Picker("Child", selection: $selectedChild) {
                                ForEach(children, id: \.self) { child in
                                    Text(child).tag(child)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.green)
                        }
                        
                        Divider()
                        
                        Toggle(isOn: $soundEffectsEnabled) {
                            Label(
                                "Sound Effects",
                                systemImage: "speaker.wave.2.fill"
                            )
                            .font(
                                .system(
                                    size: isWide ? 20 : 17,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                        }
                        .tint(.green)
                    }
                    .padding(isWide ? 28 : 20)
                    .frame(maxWidth: 760)
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 30)
                    )
                    
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Text("Learning Progress")
                                .font(
                                    .system(
                                        size: isWide ? 22 : 19,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Text("This week")
                                .font(
                                    .system(
                                        size: 13,
                                        weight: .semibold,
                                        design: .rounded
                                    )
                                )
                                .foregroundStyle(.green)
                        }
                        
                        VStack(spacing: 16) {
                            ProgressRow(
                                title: "Words",
                                percentage: 0.85,
                                color: .blue,
                                icon: "book.fill"
                            )
                            
                            ProgressRow(
                                title: "Numbers",
                                percentage: 0.70,
                                color: .green,
                                icon: "number"
                            )
                            
                            ProgressRow(
                                title: "Logic",
                                percentage: 0.60,
                                color: .orange,
                                icon: "puzzlepiece.fill"
                            )
                            
                            ProgressRow(
                                title: "Creativity",
                                percentage: 0.90,
                                color: .purple,
                                icon: "paintpalette.fill"
                            )
                        }
                    }
                    .padding(isWide ? 28 : 20)
                    .frame(maxWidth: 760)
                    .background(
                        .regularMaterial,
                        in: RoundedRectangle(cornerRadius: 30)
                    )
                    
                    //                    VStack(alignment: .leading, spacing: 18) {
                    //                        Text("Weekly Activity")
                    //                            .font(
                    //                                .system(
                    //                                    size: isWide ? 22 : 19,
                    //                                    weight: .bold,
                    //                                    design: .rounded
                    //                                )
                    //                            )
                    //                            .foregroundStyle(.primary)
                    //
                    //                        HStack(alignment: .bottom, spacing: 18) {
                    //                            ActivityBar(day: "MON", height: 65, color: .blue)
                    //                            ActivityBar(day: "TUE", height: 95, color: .green)
                    //                            ActivityBar(day: "WED", height: 75, color: .orange)
                    //                            ActivityBar(day: "THU", height: 115, color: .red)
                    //                            ActivityBar(day: "FRI", height: 85, color: .blue)
                    //                            ActivityBar(day: "SAT", height: 45, color: .green)
                    //                            ActivityBar(day: "SUN", height: 25, color: .orange)
                    //                        }
                    //                        .frame(maxWidth: .infinity)
                    //                        .padding(.top, 8)
                    //                    }
                    //                    .padding(isWide ? 28 : 20)
                    //                    .frame(maxWidth: 760)
                    //                    .background(
                    //                        .regularMaterial,
                    //                        in: RoundedRectangle(cornerRadius: 30)
                    //                    )
                    //                }
                    //                .padding(.horizontal, isWide ? 32 : 16)
                    //                .padding(.vertical, 32)
                    //                .frame(maxWidth: .infinity)
                }
                .navigationTitle("Settings")
            }
        }
    }
}

#Preview {
    SettingsView()
}

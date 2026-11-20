//
//  ProfileCreatorView.swift
//  Challenge2
//
//  Created by Gennara Vettoliere on 20/11/2026.
//

import SwiftUI

struct ProfileCreatorView: View {
    
    var onSave: (ChildProfile) -> Void
    var onCancel: () -> Void

    @State private var name = ""
    @State private var avatar = PF.avatars[0]
    @FocusState private var nameFocused: Bool

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var nameBinding: Binding<String> {
        Binding(
            get: { name },
            set: { name = String($0.prefix(12)) }
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Create your player")
                .font(.system(size: 34, weight: .heavy))
                .foregroundColor(PF.brown.opacity(0.8))

            AvatarCircle(emoji: avatar, size: 200, ring: PF.orange)

            Text("Pick your friend:")
                .font(.system(.callout).weight(.semibold))
                .foregroundColor(PF.brown.opacity(0.8))

            HStack(spacing: 10) {
                ForEach(PF.avatars, id: \.self) { emoji in
                    let isSelected = avatar == emoji
                    Text(emoji)
                        .font(.system(size: 32))
                        .frame(width: 54, height: 54)
                        .background(
                            Circle().fill(isSelected ? .orange.opacity(0.35) : Color.white.opacity(0.7))
                        )
                        .overlay(
                            Circle().stroke(isSelected ? .orange : .clear, lineWidth: 3)
                        )
                        .onTapGesture {
                            avatar = emoji
                        }
                }
            }

            TextField("My name is…", text: nameBinding)
                .font(.system(size: 30, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(PF.brown)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .focused($nameFocused)
                .padding(.vertical, 14)
                .padding(.horizontal, 20)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 22))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(nameFocused ? .green : .brown.opacity(0.3), lineWidth: 3)
                )
                .frame(maxWidth: 420)

            HStack(spacing: 18) {
                Button(role: .destructive, action: onCancel){
                    Label("Cancel", systemImage: "x.circle.fill")
                }
                .controlSize(.extraLarge) 
                .buttonStyle(.borderedProminent)

                Button {
                    onSave(ChildProfile(name: trimmedName, avatar: avatar))
                } label: {
                    HStack(spacing: 8) {
                        Text("Let's go!")
                        Image(systemName: "checkmark.fill")
                    }
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.horizontal, 34)
                    .padding(.vertical, 14)
                    .background(.green, in: Capsule())
                }
                .buttonStyle(BouncyStyle())
                .disabled(trimmedName.isEmpty)
                .opacity(trimmedName.isEmpty ? 0.5 : 1)
            }
            .padding(.top, 4)
        }
        .padding(32)
        .frame(maxWidth: 640)
        .background(PF.paper, in: RoundedRectangle(cornerRadius: 36))
        .overlay(
            RoundedRectangle(cornerRadius: 36)
                .stroke(.brown.opacity(0.35), lineWidth: 4)
        )
        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
        .padding(24)
    }
}

#Preview {
    ProfileCreatorView(onSave: { _ in }, onCancel: {})
}

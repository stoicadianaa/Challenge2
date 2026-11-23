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
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(.primary)

            AvatarCircle(emoji: avatar, size: 200, ring: PF.orange)

            HStack(spacing: 10) {
                ForEach(PF.avatars, id: \.self) { emoji in
                let isSelected = avatar == emoji

                Button {
                    avatar = emoji
                } label: {
                        Text(emoji)
                        .font(.system(size: 32))
                        .frame(width: 54, height: 54)
                        .background(Circle().fill(isSelected ? PF.orange.opacity(0.3) : Color.clear)
                                        )
                        .background(.fill.tertiary, in: Circle())
                        .overlay(Circle().stroke(isSelected ? PF.orange : .clear, lineWidth: 3))
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                            }
            }

            TextField("My name is…", text: nameBinding)
                .font(.system(size: 30, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
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
                    Label("Cancel", systemImage: "xmark")
                        .font(.title3.weight(.semibold))
                }
                .tint(.red)
                .controlSize(.extraLarge)
                .buttonStyle(.glassProminent)

                Button {
                    onSave(ChildProfile(name: trimmedName, avatar: avatar))
                                } label: {
                                    Label("Let's go!", systemImage: "checkmark")
                                        .font(.title3.weight(.semibold))
                                }
                                .buttonStyle(.glassProminent)
                                .tint(.green)
                                .controlSize(.extraLarge)
                                .disabled(trimmedName.isEmpty)
            }
            .padding(.top, 4)
        }
        .padding(32)
                .frame(maxWidth: 640)
                .glassEffect(.regular, in: .rect(cornerRadius: 36))
                .padding(24)
    }
}

#Preview {
    ProfileCreatorView(onSave: { _ in }, onCancel: {})
}

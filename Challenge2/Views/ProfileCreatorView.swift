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
    @Environment(\.screenSize) private var screen

    // Eight avatars in one row are wider than a phone, so they wrap onto a second row.
    private let avatarColumns = [GridItem(.adaptive(minimum: 54), spacing: 10)]

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
        // Hugs its content when there's room; scrolls when the keyboard or a small screen takes it.
        ScrollIfNeeded { form }
            .frame(maxWidth: 640)
            .glassEffect(.regular, in: .rect(cornerRadius: 36))
            .padding(screen.isCompact ? 12 : 24)
    }

    private var form: some View {
        VStack(spacing: screen.isCompact ? 12 : 20) {
            Text("Create your player")
                .font(.system(size: screen.isCompact ? 26 : 34, weight: .heavy, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            AvatarCircle(emoji: avatar, size: screen.value(regular: 200, portrait: 130, landscape: 80), ring: PF.orange)

            LazyVGrid(columns: avatarColumns, spacing: 10) {
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
                .font(.system(size: screen.isCompact ? 24 : 30, weight: .bold))
                .minimumScaleFactor(0.6)
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

            // Side by side when they fit; stacked (still full-size) on a narrow phone.
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 18) { buttons }
                VStack(spacing: 12) { buttons }
            }
            .padding(.top, 4)
        }
        .padding(screen.isCompact ? 20 : 32)
    }

    @ViewBuilder
    private var buttons: some View {
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
}

#Preview {
    ProfileCreatorView(onSave: { _ in }, onCancel: {})
}

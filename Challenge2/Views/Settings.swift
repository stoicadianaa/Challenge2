import SwiftUI
struct Settings: View {

    @Environment(\.dismiss) private var dismiss
    @AppStorage("soundEffectsEnabled")
    private var soundEffectsEnabled = true

    @AppStorage("backgroundMusicEnabled")
    private var backgroundMusicEnabled = true

    @AppStorage("childName")
    private var childName = ""

    @FocusState private var isNameFocused: Bool
    var body: some View {
        GeometryReader { geometry in

            let isWide = geometry.size.width > 600
            let cardWidth = min(
                geometry.size.width * (isWide ? 0.76 : 0.92),680
            )
            let textSize: CGFloat = isWide ? 24 : 19
            let mascotSize: CGFloat = isWide ? 200 : 140

            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: isWide ? 28 : 20) {
                        Image("mascot_genderless_neutral")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: mascotSize,
                                height: mascotSize
                            )
                            .accessibilityHidden(true)

                        VStack(spacing: 0) {
                            Toggle(isOn: $soundEffectsEnabled) {
                                Label(
                                    "Sound Effects",
                                    systemImage: "speaker.wave.2.fill"
                                )
                            }
                            .frame(minHeight: 72)

                            Divider()
                            Toggle(isOn: $backgroundMusicEnabled) {

                                Label(
                                    "Background Music",
                                    systemImage: "music.note"
                                )
                            }
                            .frame(minHeight: 72)

                            Divider()
                            HStack(spacing: 16) {
                                Label(
                                    "Child Name",
                                    systemImage: "person.fill"
                                )

                                Spacer(minLength: 8)
                                TextField(
                                    "Enter name",
                                    text: $childName
                                )
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .textContentType(.nickname)
                                .autocorrectionDisabled()
                                .focused($isNameFocused)
                                .frame(
                                    maxWidth: isWide ? 230 : 140
                                )
                                .submitLabel(.done)
                                .onSubmit {
                                    isNameFocused = false
                                }
                                .accessibilityLabel("Child Name")
                            }
                            .frame(minHeight: 72)

                        }
                        .font(
                            .system(
                                size: textSize,
                                weight: .medium,
                                design: .rounded
                            )
                        )
                        .tint(.green)
                        .padding(
                            .horizontal,
                            isWide ? 32 : 20
                        )
                        .padding(.vertical, 12)
                        .frame(width: cardWidth)
                        .background(
                            .regularMaterial,
                            in: RoundedRectangle(
                                cornerRadius: 30
                            )
                        )
                    }
                    .frame(
                        maxWidth: .infinity,
                        minHeight: geometry.size.height
                    )
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)

                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .font(
                                    .system(
                                        size: 22,
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(.primary)
                                .frame(
                                    width: 52,
                                    height: 52
                                )
                                .background(
                                    .regularMaterial,
                                    in: Circle()
                                )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Back")

                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
#Preview {
    NavigationStack {
        Settings()
    }
}


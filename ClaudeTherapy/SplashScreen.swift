import SwiftUI

struct SplashScreen: View {
    @Environment(\.colorScheme) var colorScheme // Detect light or dark mode
    @State private var showMainMenu = false
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.9

    var body: some View {
        NavigationStack {
            if showMainMenu {
                MenuView() // Main Menu Screen
            } else {
                ZStack {
                    // Dynamic Background Color
                    (colorScheme == .dark ? AppColors.darkBackground : AppColors.lightBackground)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        // Logo and Title
                        VStack {
                            Image("Claude Icon Logo") // Replace with your logo asset name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)

                            Text("Claude Therapy")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }

                        // Feature Cards
                        VStack(spacing: 20) {
                            HStack(spacing: 20) {
                                featureCard(
                                    title: "Chat",
                                    description: "Talk to a virtual therapist.",
                                    icon: "message.fill"
                                )
                                featureCard(
                                    title: "Insights",
                                    description: "Track mental health trends.",
                                    icon: "chart.bar.fill"
                                )
                            }

                            HStack(spacing: 20) {
                                featureCard(
                                    title: "Privacy",
                                    description: "Your data stays secure.",
                                    icon: "lock.fill"
                                )
                                featureCard(
                                    title: "24/7 Help",
                                    description: "Always here for you.",
                                    icon: "clock.fill"
                                )
                            }
                        }
                        .padding(.top, 20)

                        Spacer()

                        // "Next" Button
                        Button(action: {
                            withAnimation {
                                self.showMainMenu = true
                            }
                        }) {
                            Text("Next")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(AppColors.accentColor) // Accent color
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                        }
                    }
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0)) {
                            self.opacity = 1.0
                            self.scale = 1.0
                        }
                    }
                }
            }
        }
    }

    // Feature Card Component
    private func featureCard(title: String, description: String, icon: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .padding()
                .background(AppColors.accentColor) // Accent color
                .clipShape(Circle())

            Text(title)
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? .white : .black)

            Text(description)
                .font(.subheadline)
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 120)
        }
        .padding()
        .background(colorScheme == .dark ? AppColors.featureCardBackgroundDark : AppColors.featureCardBackgroundLight)
        .cornerRadius(15)
        .shadow(color: colorScheme == .dark ? .black.opacity(0.2) : .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SplashScreen()
                .environment(\.colorScheme, .light) // Test in light mode
            SplashScreen()
                .environment(\.colorScheme, .dark) // Test in dark mode
        }
    }
}

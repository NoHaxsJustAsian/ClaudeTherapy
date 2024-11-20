import SwiftUI

struct MenuView: View {
    @Environment(\.colorScheme) var colorScheme // Detect light or dark mode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to Claude Therapy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text("Navigate through your options below:")
                    .font(.subheadline)
                    .foregroundColor(colorScheme == .dark ? AppColors.botBubbleColorLight.opacity(0.8) : AppColors.botBubbleColorDark.opacity(0.8))
                    .padding(.horizontal)
                
                Spacer()
                
                // Menu Grid
                VStack(spacing: 20) {
                    menuCard(
                        title: "Chat with Therapist",
                        description: "Start a conversation with your virtual therapist.",
                        icon: "message.fill",
                        destination: TherapyChatbotView()
                    )
                    menuCard(
                        title: "View Insights",
                        description: "Check your mental health trends and progress.",
                        icon: "chart.bar.fill",
                        destination: InsightsView()
                    )
                }
                
                Spacer()
            }
            .padding()
            .background(colorScheme == .dark ? AppColors.darkBackground.edgesIgnoringSafeArea(.all) : AppColors.lightBackground.edgesIgnoringSafeArea(.all))
            .navigationTitle("Menu")
        }
    }
    
    // Menu Card Component
    private func menuCard<Destination: View>(title: String, description: String, icon: String, destination: Destination) -> some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 20) {
                // Icon Circle
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .padding()
                    .background(AppColors.accentColor) // Accent color
                    .clipShape(Circle())
                
                // Title and Description
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(colorScheme == .dark ? AppColors.botBubbleColorLight.opacity(0.8) : AppColors.botBubbleColorDark.opacity(0.8))
                        .lineLimit(2)
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(colorScheme == .dark ? AppColors.botBubbleColorLight.opacity(0.8) : AppColors.botBubbleColorDark.opacity(0.8))
            }
            .padding()
            .background(colorScheme == .dark ? AppColors.botBubbleColorDark : AppColors.botBubbleColorLight)
            .cornerRadius(15)
            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.5) : Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MenuView().environment(\.colorScheme, .light) // Preview in light mode
            MenuView().environment(\.colorScheme, .dark)  // Preview in dark mode
        }
    }
}

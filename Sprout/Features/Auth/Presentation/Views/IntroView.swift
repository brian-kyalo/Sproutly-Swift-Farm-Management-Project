import SwiftUI

struct IntroView: View {
    @Binding var path: NavigationPath
    @Binding var hasSeenIntro: Bool

    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)
            // Banner
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
                .padding(.vertical, 20)
            
            //
            Text("Please sign in to continue.")
                .foregroundColor(.secondary)

            Button("Sign In") {
                hasSeenIntro = true   // mark intro as seen
                path.append("login")
            }
            .buttonStyle(.borderedProminent)

            Button("Sign Up") {
                hasSeenIntro = true   // mark intro as seen
                path.append("register")
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding()
    }
}

import SwiftUI
import Kingfisher

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text("Home").font(.title).bold()
                    Spacer()
                }
                .padding(.horizontal)

                Spacer()

                Text("Welcome to the Homepage")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text("This is your main dashboard")
                    .foregroundColor(.secondary)

                Spacer()

                Button(role: .destructive) {
                    Task {
                        await authViewModel.signOut()
                    }
                } label: {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}





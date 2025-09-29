import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var path: NavigationPath

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 16) {
            

            
            // Banner
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
                .padding(.vertical, 20)
            
            // Email Textfield
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)  // prevent is from capitalizing the first letter.
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            // Password TextField Obscured
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            //
            HStack {
                //
                Spacer()

                //
                Button("Forgot Password") {
                    Task {
                        if !email.isEmpty {
                            await authViewModel.forgotPassword(email: email)
                        } else {
                            authViewModel.errorMessage = "Enter your email to reset password"
                        }
                    }
                }
                .font(.footnote)
                .foregroundColor(.blue)
                
            }
            .padding(.horizontal, 4)
            
            
            // Error Message
            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
            
            // Sign in Button
            Button {
                Task {
                    isLoading = true
                    await authViewModel.signIn(email: email, password: password)
                    isLoading = false
                }
            } label: {
                if isLoading { ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    
                    
                } else { Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
            }
            .background(email.isEmpty || password.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(12)
                        .disabled(email.isEmpty || password.isEmpty)

            
                        
            // Sign Up Link.
            HStack {
                Text("Don’t have an account ?")
                    .foregroundColor(.gray)
                Button("Sign Up") {
                    path.append("register")
                }
                .font(.footnote)
            }
            Spacer()

        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onReceive(authViewModel.$currentUser) { user in
            if user != nil {
                path.removeLast(path.count)
            }
        }
    }
}

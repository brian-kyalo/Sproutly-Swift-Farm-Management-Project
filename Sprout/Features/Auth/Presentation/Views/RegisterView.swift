import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var path: NavigationPath
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // State variables that toggle some func.
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var isLoading = false
    
    
    // Env var that detects the theme
//    @Environment(\.colorScheme) var isDark
    
    var body: some View {
        VStack(spacing: 16) {
            
            //
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 280)
                .padding(.vertical, 20)
            
            
            //
            TextField("Full name", text: $name)
                .textContentType(.name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
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
            
            // Password textfield
            ZStack(alignment: .trailing) {
                Group {
                    if showPassword {
                        TextField("Password", text: $password)
                            .textContentType(.password)
                    } else {
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                // Eye icon Button toggles based on the password being obscured or not.
                Button(action: {showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
            
            //  Confirm Password textfield
            ZStack(alignment: .trailing) {
                Group {
                    if showPassword {
                        TextField("Confirm Password", text: $confirmPassword)
                            .textContentType(.password)
                    } else {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textContentType(.password)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                // Eye icon Button toggles based on the password being obscured or not.
                Button(action: {showConfirmPassword.toggle()
                }) {
                    Image(systemName: showConfirmPassword ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
            
            // Error Message
            if let error = authViewModel.errorMessage {
                            Text(error).foregroundColor(.red).multilineTextAlignment(.center)
                        } else if password != confirmPassword && !confirmPassword.isEmpty {
                            Text("Passwords do not match").foregroundColor(.red).multilineTextAlignment(.center)
                        }
            // Sign Up Button
            Button {
                Task {
                    isLoading = true
                    await authViewModel.signUp(email: email, password: password, name: name)
                    isLoading = false
                }
            } label: {
                if isLoading { ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                } else { Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
            }
            .background(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword
                        ? Color.gray
                        : Color.blue)
                        .cornerRadius(12)
                        .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
            
                        
            // Sign in Link.
            HStack {
                Text("Already have an account ?")
                Button("Sign In") {
                    path.append("login")
                }
                .font(.footnote)
            }
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onChange(of: authViewModel.authState) {
            if case .authenticated = authViewModel.authState {
                path.removeLast(path.count)
            }
        }
    }
}

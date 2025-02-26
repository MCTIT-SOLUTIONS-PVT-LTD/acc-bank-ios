import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var isPasswordValidState: Bool = true
    @State private var isFormCompleted: Bool = false

    var body: some View {
        print("Current Username in [ViewName]: \(username)")

        return NavigationStack {
            
            ZStack {
                
                backgroundGradient

                VStack(spacing: 20) {
                    Text("Register")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    CustomTextField(placeholder: "Username", text: $username)
                    
                    CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                    CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(.top, 5)
                    }

                    Button(action: {
                        print("✅ Username Before Navigating: \(username)") // ✅ Debugging

                        registerUser()
                    }) {
                        actionButton(title: "Register")
                    }
                    .padding(.top, 20)
                    .disabled(!isPasswordValidState)

                    NavigationLink("", destination: PhoneNumberView(username: username), isActive: $isFormCompleted)
                        .hidden()
                }
                .padding(.horizontal, 30)
                
            }
        }
    }

    private func registerUser() {
        errorMessage = nil
        validatePassword()
        
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields are required."
        } else if password != confirmPassword {
            errorMessage = "Passwords do not match."
        } else if !isPasswordValidState {
        } else {
            isFormCompleted = true
        }
    }

    private func validatePassword() {
        errorMessage = nil
        var validationErrors = [String]()

        if password.isEmpty { validationErrors.append("Password cannot be empty.") }
        if password.count < 10 { validationErrors.append("Password must be at least 10 characters long.") }
        if password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
            validationErrors.append("Password must contain at least one uppercase letter.")
        }
        if password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil {
            validationErrors.append("Password must contain at least one lowercase letter.")
        }
        if password.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            validationErrors.append("Password must contain at least one number.")
        }
        let specialCharacterSet = CharacterSet(charactersIn: "@$!%*?&")
        if password.rangeOfCharacter(from: specialCharacterSet) == nil {
            validationErrors.append("Password must contain at least one special character (@$!%*?&).")
        }

        if !validationErrors.isEmpty {
            errorMessage = validationErrors.joined(separator: "\n")
            isPasswordValidState = false
        } else {
            isPasswordValidState = true
        }
    }
}

// Preview
#Preview {
    RegisterView()
}

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var isPasswordValidState: Bool = true
    @State private var isFormCompleted: Bool = false
    @State private var navigateToLogin: Bool = false

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    backgroundGradient
                    
                    VStack(spacing: geometry.size.height * 0.02) {
                        VStack(spacing: 0) {
                                                    ZStack {
                                                        Color.white
                                                            .frame(height: geometry.size.height * 0.12) // Adjust header height dynamically
                                                            .frame(maxWidth: .infinity)
                                                            .ignoresSafeArea(edges: .top)
                                                            .offset(y: -geometry.size.height * 0.2)
                                                        // Logo placed at the top inside the white section
                                                        Image("AppLogo")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.05) // Dynamically adjust logo size
                                                            .padding(.top, 0) // Align logo with the top of the section
                                                            .offset(y: -geometry.size.height * 0.19) // Minor vertical adjustment if needed
                                                    }
                                                    .padding(.bottom, 10)
                                                }
                        // Title
                        Text(NSLocalizedString("register_title", comment: ""))
                            .font(.system(size: geometry.size.width * 0.08, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, geometry.size.height * 0.05)

                        // Username TextField
                        CustomTextField(placeholder: NSLocalizedString("username_placeholder", comment: ""), text: $username)
                            .padding(.top, geometry.size.height * 0.02)

                        // Password TextField
                        CustomTextField(placeholder: NSLocalizedString("password_placeholder", comment: ""), text: $password, isSecure: true)

                        // Confirm Password TextField
                        CustomTextField(placeholder: NSLocalizedString("confirm_password_placeholder", comment: ""), text: $confirmPassword, isSecure: true)

                        // Error Message
                        if let errorMessage = errorMessage {
                            Text(NSLocalizedString(errorMessage, comment: ""))
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.top, 5)
                        }

                        // Register Button
                        Button(action: {
                            registerUser()
                        }) {
                            actionButton(title: NSLocalizedString("register_title", comment: ""))
                        }
                        .padding(.top, geometry.size.height * 0.05)
                        .disabled(!isPasswordValidState)

                        // Navigation link
                        NavigationLink("", destination: PhoneNumberView(username: username), isActive: $isFormCompleted)
                            .hidden()
                    }
                    .padding(.horizontal, geometry.size.width * 0.07)
                }
            }
        }
    }

    // Registration function
    private func registerUser() {
        errorMessage = nil
        validatePassword()

        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields are required."
            return
        }

        if password != confirmPassword {
            errorMessage = "Passwords do not match!"
            return
        }

        if !isPasswordValidState {
            return
        }

        let users = UserDataManager.loadUsers()

        // Check if username already exists
        if users.contains(where: { $0.username.lowercased() == username.lowercased() }) {
            errorMessage = "You are already registered."
            return
        }

        // Save user details in JSON if not already registered
        let newUser = User(username: username, password: password)
        UserDataManager.saveUser(newUser)

        isFormCompleted = true // Proceed to next screen
    }

    // Password validation
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

import SwiftUI

struct RegisterPageView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String? // For validation message
    @State private var isPasswordValidState: Bool = true // Track if password is valid
    @State private var isFormCompleted: Bool = false // To track if user has completed registration
    @State private var isMobileNumberFormCompleted: Bool = false // Track if mobile number form is completed

    @State private var mobileNumber: String = "" // Mobile number for the second form
    @State private var email: String = "" // Email for the third form
    @State private var isNavigatingToWelcomePage = false // Track navigation to welcome page

    var body: some View {
        NavigationStack {
            ZStack {
                // 🔵 Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.deepTeal,
                        Color.dodgerBlue
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    if !isFormCompleted {
                        // 📌 First Registration Form (username and password)
                        Text("Register")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)

                        CustomTextField(placeholder: "Username", text: $username)

                        CustomTextField(placeholder: "Password", text: $password, isSecure: true)

                        CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)

                        // ⚠️ Error Message Display
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.top, 5) // Add space before the error message
                        }

                        // ✅ Register Button
                        Button(action: {
                            print("Register button clicked")
                            registerUser()
                        }) {
                            Text("Register")
                                .fontWeight(.bold)
                                .frame(width: 200, height: 50)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                        .padding(.top, 20)
                        .disabled(!isPasswordValidState) // 🔒 Disable button if password is invalid
                    } else if !isMobileNumberFormCompleted {
                        // 📌 Second Form (Mobile Number)
                        Text("Enter Mobile Number")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)

                        CustomTextField(placeholder: "Mobile Number", text: $mobileNumber)

                        Button(action: {
                            print("Mobile number submitted: \(mobileNumber)")
                            isMobileNumberFormCompleted = true // Switch to email form
                        }) {
                            Text("Next")
                                .fontWeight(.bold)
                                .frame(width: 200, height: 50)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                        .padding(.top, 20)
                    } else {
                        // 📌 Third Form (Email)
                        Text("Enter Email Address")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)

                        CustomTextField(placeholder: "Email Address", text: $email)

                        Button(action: {
                            print("Email submitted: \(email)")
                            // Handle email submission or next steps
                            isNavigatingToWelcomePage = true // Trigger navigation to welcome page
                        }) {
                            Text("Submit")
                                .fontWeight(.bold)
                                .frame(width: 200, height: 50)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                        .padding(.top, 20)
                    }

                    // Navigation to the Welcome Page
                    NavigationLink("", destination: WelcomePageView(username: username), isActive: $isNavigatingToWelcomePage)
                        .hidden() // Keep it hidden, as we don’t need a visible link
                }
                .padding(.horizontal, 30)
            }
        }
    }

    private func registerUser() {
        // Debug print statement
        print("registerUser function called")
        
        // Clear previous error messages
        errorMessage = nil

        // Perform password validation
        validatePassword()

        // Check if username, password, or confirm password fields are empty
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields are required."
        } else if password != confirmPassword {
            errorMessage = "Passwords do not match."
        } else if !isPasswordValidState {
            // This will already be handled in validatePassword()
            // We do not need to assign a generic error here, the errors are already in errorMessage
        } else {
            // Successfully validated password and other fields
            isFormCompleted = true // Switch to the next form
            print("User Registered: \(username)") // You can replace this with actual registration logic
        }
    }

    // ✅ Password Validation Function
    private func validatePassword() {
        // Clear previous error message
        errorMessage = nil
        
        var validationErrors = [String]()
        
        // Check if password is empty
        if password.isEmpty {
            validationErrors.append("Password cannot be empty.")
        }
        
        // Check if password is at least 10 characters long
        if password.count < 10 {
            validationErrors.append("Password must be at least 10 characters long.")
        }
        
        // Check for at least one uppercase letter
        if password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
            validationErrors.append("Password must contain at least one uppercase letter.")
        }
        
        // Check for at least one lowercase letter
        if password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil {
            validationErrors.append("Password must contain at least one lowercase letter.")
        }
        
        // Check for at least one number
        if password.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            validationErrors.append("Password must contain at least one number.")
        }
        
        // Check for at least one special character
        let specialCharacterSet = CharacterSet(charactersIn: "@$!%*?&")
        if password.rangeOfCharacter(from: specialCharacterSet) == nil {
            validationErrors.append("Password must contain at least one special character (@$!%*?&).")
        }
        
        // If there are validation errors, display them
        if !validationErrors.isEmpty {
            errorMessage = validationErrors.joined(separator: "\n") // Join all errors with line breaks
            isPasswordValidState = false
        } else {
            isPasswordValidState = true
        }
    }

    // ✅ Password Validation (regex function)
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])(?=.*[a-z])(?=.*[A-Z]).{10,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}

//struct WelcomePageView: View {
//    var username: String
//
//    var body: some View {
//        VStack {
//            Text("Welcome, \(username)!")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .foregroundColor(.green)
//                .padding()
//            
//            Text("You have successfully registered.")
//                .font(.title)
//                .foregroundColor(.white)
//                .padding()
//        }
//        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .top, endPoint: .bottom))
//        .edgesIgnoringSafeArea(.all)
//    }
//}
import SwiftUI

struct WelcomePageView: View {
    var username: String
    @State private var navigateToLogin = false // To track navigation to LoginPageView

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 🎉 Welcome Title
                Text("Welcome, \(username)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // 📝 Success Message
                Text("You have successfully registered.")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                // ✅ Continue to Login Button
                Button(action: {
                    print("Continue to login clicked")
                    navigateToLogin = true // Trigger navigation
                }) {
                    Text("Continue to Login")
                        .fontWeight(.bold)
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)

                // Hidden NavigationLink to LoginPageView
                NavigationLink("", destination: LoginView(), isActive: $navigateToLogin)
                    .hidden() // Hide this link from view, but it will trigger the navigation when isActive becomes true
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.deepTeal, Color.dodgerBlue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
        }
    }
}



struct CustomTextFieldView: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.8), lineWidth: 2) // Light border
                .background(RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1))) // Transparent background
                .shadow(color: Color.white.opacity(0.2), radius: 5, x: 0, y: 3)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .padding(15)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .padding(15)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 10)
    }
}

// ✅ Preview
#Preview {
    RegisterPageView()
}

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
                // Background Gradient
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
                        // First Registration Form (username and password)
                        Text("Register")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)

                        CustomTextField(placeholder: "Username", text: $username)

                        CustomTextField(placeholder: "Password", text: $password, isSecure: true)

                        CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)

                        // Error Message Display
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.top, 5) // Add space before the error message
                        }

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
                        .disabled(!isPasswordValidState) // 🔒 Disable button if password

                    }   else if !isMobileNumberFormCompleted {
                        // 📌 Second Form (Mobile Number)
                        Text("Enter Mobile Number")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)

                        // Phone Number Field with Country Code Inside
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.8), lineWidth: 2) // Light border
                                .background(RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1))) // Transparent background
                                .shadow(color: Color.white.opacity(0.2), radius: 5, x: 0, y: 3)
                                .frame(height: 50)

                            HStack {
                                // Country Code Picker inside the text field
                                Picker("", selection: $selectedCountry) {
                                    Text("+1").tag("+1")
                                    Text("+91").tag("+91")
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 70)
                                .background(Color.clear)
                                .accentColor(.white)

                                Divider()
                                    .frame(height: 30)
                                    .background(Color.white.opacity(0.5))

                                // Mobile Number TextField
                                TextField("Mobile Number", text: $mobileNumber)
                                    .foregroundColor(.white)
                                    .keyboardType(.numberPad)
                                    .onChange(of: mobileNumber) { oldValue, newValue in
                                        mobileNumber = formatPhoneNumber(newValue, countryCode: selectedCountry)
                                    }
                            }
                            .padding(.horizontal, 15)
                        }
                        .frame(width: 320, height: 50) // Adjust width to match your design

                        // Show error message if invalid
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 5)
                        }

                        Button(action: {
                            if validatePhoneNumber(mobileNumber, countryCode: selectedCountry) {
                                print("✅ Mobile number submitted: \(selectedCountry) \(mobileNumber)")
                                isMobileNumberFormCompleted = true // Proceed to email form
                                errorMessage = nil // Clear errors
                            } else {
                                errorMessage = "❌ Invalid phone number for \(selectedCountry)."
                            }
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
                    }

//
                    else {
                        // 📌 Third Form (Email)
                        Text("Enter Email Address")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)

                        CustomTextField(placeholder: "Email Address", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
//                            .onChange(of: email) { newValue in
//                                email = newValue.trimmingCharacters(in: .whitespacesAndNewlines) // Trim spaces
//                            }
                            .onChange(of: email) { _, newValue in
                                email = newValue.trimmingCharacters(in: .whitespacesAndNewlines) // Trim spaces
                            }


                        // 🔴 Show error message if email is invalid
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 5)
                        }

                        Button(action: {
                            if validateEmail(email) {
                                print("✅ Email submitted: \(email)")
                                isNavigatingToWelcomePage = true // Navigate to welcome page
                                errorMessage = nil // Clear errors
                            } else {
                                errorMessage = "❌ Invalid email. Only @gmail.com and @outlook.com are allowed."
                            }
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
    /// valid email domain
    private func validateEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@(gmail\.com|outlook\.com)$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex?.firstMatch(in: email, options: [], range: range) != nil
    }

    @State private var selectedCountry: String = "+1" // Default to Canada

    /// ✅ Validate phone number based on selected country
    private func validatePhoneNumber(_ number: String, countryCode: String) -> Bool {
        let pattern: String
        switch countryCode {
        case "+1": // Canada
            pattern = #"^\(?([2-9][0-9]{2})\)?[-. ]?([2-9][0-9]{2})[-. ]?([0-9]{4})$"#
        case "+91": // India
            pattern = #"^[6-9]\d{9}$"#
        default:
            return false
        }
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: number)
    }

    /// ✅ Format phone number while typing
    private func formatPhoneNumber(_ number: String, countryCode: String) -> String {
        let digits = number.filter { "0123456789".contains($0) } // Remove non-numeric characters

        if countryCode == "+1" { // Canada Formatting
            if digits.count > 10 {
                return String(digits.prefix(10))
            } else if digits.count >= 6 {
                return "(\(digits.prefix(3))) \(digits.dropFirst(3).prefix(3))-\(digits.dropFirst(6))"
            } else if digits.count >= 3 {
                return "(\(digits.prefix(3))) \(digits.dropFirst(3))"
            } else {
                return digits
            }
        } else { // India Formatting
            return digits.prefix(10).description // Only 10 digits for India
        }
    }


    ///  format phone number while typing
    private func formatCanadianPhoneNumber(_ number: String) -> String {
        let digits = number.filter { "0123456789".contains($0) } // Remove non-numeric characters

        if digits.count > 10 {
            return String(digits.prefix(10)) // Ensure max 10 digits
        } else if digits.count >= 6 {
            return "(\(digits.prefix(3))) \(digits.dropFirst(3).prefix(3))-\(digits.dropFirst(6))"
        } else if digits.count >= 3 {
            return "(\(digits.prefix(3))) \(digits.dropFirst(3))"
        } else {
            return digits
        }
    }


    // Password Validation Function
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

    // Password Validation (regex function)
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])(?=.*[a-z])(?=.*[A-Z]).{10,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}


struct WelcomePageView: View {
    var username: String
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome, \(username)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)

                Text("You have successfully registered.")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                Button(action: {
                    print("Continue to login clicked")
                    //RESET UserDefaults before navigating to login
                    UserDefaults.standard.removeObject(forKey: "SavedUsername")
                    UserDefaults.standard.removeObject(forKey: "HasLoggedInBefore")
                    UserDefaults.standard.synchronize() // Ensure changes are written immediately

                    navigateToLogin = true
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

                NavigationLink("", destination: LoginView(), isActive: $navigateToLogin)
                    .hidden()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.deepTeal, Color.dodgerBlue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}





// Preview
#Preview {
    RegisterPageView()
}

import SwiftUI
import LocalAuthentication // for Face ID integration
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    @State private var username: String = UserDefaults.standard.string(forKey: "SavedUsername") ?? ""
    @State private var password: String = ""
    @State private var isToggled = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var navigateToWelcome = false
    @State private var navigateToRegister = false // ✅ Add state variable for Register navigation
    @State private var errorMessage: String?
    @State private var isAuthenticated = false

    private let correctPassword = "123456" // Static password for demo

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height

                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.deepTeal, Color.dodgerBlue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .edgesIgnoringSafeArea(.all)

                    ScrollView(showsIndicators: false) {
                        VStack {
                            VStack(spacing: 5) {
                                Text("QUOTE OF THE DAY")
                                    .kerning(5)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.top, screenHeight * 0.05)

                                Text("Money isn’t everything,\n but everything needs \nmoney.")
                                    .font(.system(size: 24, weight: .medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding()
                                    .lineSpacing(4)

                                Rectangle()
                                    .frame(width: screenWidth * 0.1, height: 4.5)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.top, 5)
                            }
                            .padding(.bottom, screenHeight * 0.2)

                            // Username & Password Fields
                            VStack(spacing: screenHeight * 0.02) {
                                CustomTextField(placeholder: "Username", text: $username)
                                    .frame(width: screenWidth * 0.7, height: 50)

                                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                                    .frame(width: screenWidth * 0.7, height: 50)

                                if let errorMessage = errorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                        .padding(.top, 2)
                                }
                            }
                            .padding(.bottom, screenHeight * 0.01)

                            // Keep Me Logged In + Register Button
                            HStack(spacing: 10) {
                                Toggle("", isOn: $isToggled)
                                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                    .scaleEffect(0.7)
                                    .labelsHidden()

                                Text("Keep me logged in")
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.system(size: 18))

                                Spacer() // Push Register button to the right

                                // ✅ "Register" Button
                                Button(action: {
                                    navigateToRegister = true // ✅ Navigate to Register Screen
                                }) {
                                    Text("Register")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .underline()
                                }
                            }
                            .frame(width: 350, alignment: .leading)
                            .padding(.horizontal, 40)

                            // Sign In Button
                            Button(action: {
                                verifyLogin()
                            }) {
                                Text("Sign In")
                                    .fontWeight(.bold)
                                    .frame(width: min(350, screenWidth * 0.7), height: 50)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .clipShape(Capsule())
                                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            }
                            .padding(.top, 20)

                            // Separator
                            Rectangle()
                                .frame(width: screenWidth * 0.5, height: 2)
                                .foregroundColor(.white.opacity(0.3))
                                .padding(.top, screenHeight * 0.05)

                            Spacer()

                            // Face ID Button
                            Button(action: {
                                authenticateWithFaceID()
                            }) {
                                HStack {
                                    Image(systemName: "faceid")
                                        .font(.title2)
                                    Text("Use Face ID")
                                        .fontWeight(.bold)
                                }
                                .frame(width: min(350, screenWidth * 0.5), height: 50)
                                .background(Color.black.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.bottom, keyboardHeight)
                        .animation(.easeOut(duration: 0.3), value: keyboardHeight)
                        .onAppear {
                            print("LoginView appeared, checking UserDefaults...")

                            // 🔥 Always clear username when opening login screen after registration
                            if !UserDefaults.standard.bool(forKey: "HasLoggedInBefore") {
                                print("First login detected - clearing username")
                                username = ""
                                UserDefaults.standard.set(true, forKey: "HasLoggedInBefore") // Mark as logged in
                            } else {
                                checkIfReturningUser() // Load username only if user has logged in before
                            }
                        }
                    }
                }
                .frame(width: screenWidth, height: screenHeight)
                .navigationDestination(isPresented: $navigateToWelcome) {
                    //WelcomeView(username: username)
                    MainView()
                }
                .navigationDestination(isPresented: $navigateToRegister) { // ✅ Navigate to Register
                    RegisterPageView()
                }
            }
        }
    }

    private func verifyLogin() {
        if username.isEmpty || password.isEmpty {
            errorMessage = "Username and Password are required."
            return
        }

        if password == correctPassword {
            saveUsernameIfNew()
            errorMessage = nil
            navigateToWelcome = true
        } else {
            errorMessage = "Incorrect password. Please try again."
        }
    }

    private func saveUsernameIfNew() {
        UserDefaults.standard.set(username, forKey: "SavedUsername") // Always overwrite username on successful login
        UserDefaults.standard.set(true, forKey: "HasLoggedInBefore") // Mark user as logged in
    }

    private func checkIfReturningUser() {
        if let savedUsername = UserDefaults.standard.string(forKey: "SavedUsername"), !savedUsername.isEmpty {
            print("Returning user detected: \(savedUsername)")
            username = savedUsername
        } else {
            print("No saved username found - clearing input field")
            username = "" // Ensure empty username on first login after registration
        }
    }

    private func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login using Face ID") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        username = UserDefaults.standard.string(forKey: "SavedUsername") ?? ""
                        password = correctPassword
                        navigateToWelcome = true
                    } else {
                        errorMessage = "Face ID Authentication Failed."
                    }
                }
            }
        } else {
            errorMessage = "Face ID is not available on this device."
        }
    }
}
struct WelcomeView: View {
    var username: String

    var body: some View {
        VStack {
            Text("Welcome, \(username)!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("You have successfully logged in!")
                .font(.title2)
                .padding()

            Spacer()
        }
    }
}
// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

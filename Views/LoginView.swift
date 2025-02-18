import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isToggled = false
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let isLandscape = screenWidth > screenHeight
            let isTablet = UIDevice.current.userInterfaceIdiom == .pad

            ZStack {
                //           LinearGradient(
                //                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.7)]),
                //                startPoint: .topLeading,
                //                endPoint: .bottomTrailing
                //            )
                //            .edgesIgnoringSafeArea(.all)
                            //*******
                //            LinearGradient(
                //                gradient: Gradient(colors: [
                //                    Color(red: 80/255, green: 170/255, blue: 255/255).opacity(0.8), // Light sky blue
                //                    Color(red: 50/255, green: 130/255, blue: 240/255).opacity(0.9), // Medium blue
                //                    Color(red: 30/255, green: 100/255, blue: 220/255).opacity(1.0)  // Deep blue
                //                ]),
                //                startPoint: .topLeading,
                //                endPoint: .bottomTrailing
                //            )
                //            .edgesIgnoringSafeArea(.all)
                 
                //            LinearGradient(
                //                    gradient: Gradient(colors: [
                //                        Color(red: 50/255, green: 150/255, blue: 255/255),  // Vibrant Blue
                //                        //Color(red: 20/255, green: 100/255, blue: 220/255)   // Deep Blue
                //                        Color(red: 50/255, green: 130/255, blue: 240/255)
                //                    ]),
                //                    startPoint: .topLeading,
                //                    endPoint: .bottomTrailing
                //                )
                //                .edgesIgnoringSafeArea(.all)
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.deepTeal,
                        Color.dodgerBlue
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .edgesIgnoringSafeArea(.all)

                ScrollView(showsIndicators: false) {
                    VStack {
                        // Spacer()
                        VStack(spacing: 5) {//space between quote and feilds
                            Text("QUOTE OF THE DAY")
                                .kerning(5)
                                .font(.system(size: isTablet ? 24 : 18, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.top, screenHeight * 0.05)

                            Text("Money isn’t everything,\n but everything needs \nmoney.")
                            //.font(.title3)
                            //.fontWeight(.semibold)
                                .font(.system(size: isTablet ? 36 : 24, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .lineSpacing(4)

                            Rectangle()
                                .frame(width: screenWidth * 0.1, height: 4.5)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.top, 5)
                        }
                        .padding(.bottom, screenHeight * (isLandscape ? 0.1 : 0.2))

                        VStack(spacing: screenHeight * 0.02) {
                            CustomTextField(placeholder: "Username", text: $username)
                                .frame(width: screenWidth * 0.7, height: isTablet ? 60 : 50)
                                //screenWidth take width of every screen if tablet then height 60 otherwise 50

                            CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                                .frame(width: screenWidth * 0.7, height: isTablet ? 60 : 50)
                        }
                        .padding(.bottom, screenHeight * 0.01)

                        HStack(spacing: 10) {//this spacing bet toggle button and keep .....
                            Toggle("", isOn: $isToggled)
                                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                .scaleEffect(0.7)
                                .labelsHidden()//this keep toggle on left side

                            Text("Keep me logged in")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.system(size: 18))

                            //Spacer()
                        }
                        .frame(width: 350, alignment: .leading)
                        .padding(.horizontal, 40)




                        Button(action: {
                            print("Sign In tapped")
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


                        Rectangle()
                            .frame(width: screenWidth * 0.5, height: 2)
                            .foregroundColor(.white.opacity(0.3))
                            .padding(.top, screenHeight * 0.05)

                        Spacer()
                    }
                    .padding(.bottom, keyboardHeight)
                    .animation(.easeOut(duration: 0.3), value: keyboardHeight)
                    .onAppear { addKeyboardObservers() }
                }
            }
            .frame(width: screenWidth, height: screenHeight)
        }
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.keyboardHeight = keyboardFrame.height / 2
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            self.keyboardHeight = 0
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            //.previewLayout(.sizeThatFits)
            //.previewDisplayName("Adaptive Preview")
    }
}

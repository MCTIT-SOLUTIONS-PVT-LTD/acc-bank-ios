//
//  WelcomePageView.swift
//  AcceBankDev
//
//  Created by MCT on 26/02/25.
//

import SwiftUI

struct WelcomePageView: View {
    var username: String
    @State private var navigateToLogin = false

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 20) {
                Text("Welcome, \(username)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("You have successfully registered.")
                    .font(.title)
                    .foregroundColor(.white)

                Button(action: {
                    navigateToLogin = true
                }) {
                    actionButton(title: "Continue to Login")
                }
                .padding(.top, 20)

                NavigationLink("", destination: LoginView(), isActive: $navigateToLogin)
                    .hidden()
            }
        }
    }
}

#Preview {
    WelcomePageView(username:"Testuser")
}

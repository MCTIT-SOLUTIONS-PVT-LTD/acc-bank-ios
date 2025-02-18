//
//  AccountView.swift
//  AcceBankDev
//
//  Created by MCT on 18/02/25.
//

import SwiftUI

struct AccountView: View {
    var icon: String
    var title: String
    var number: String
    var amount: String
    var isSelected: Bool

    var body: some View {
        VStack(spacing: 5) { // Vertical stack with spacing
            ZStack {
                Image(systemName: icon)
                    .font(.system(size: 25)) // Adjust icon size
                    .foregroundColor(.gray)
                
                if isSelected {
                    Circle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 22, height: 22)
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .bold))
                        )
                        .offset(x: 15, y: -15) // Positioned at the top-right of the icon
                }
            }
            
            VStack(spacing: 0) { // Stack title & number closer
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)

                Text(number)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
            
            Text(amount)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    AccountView()
//}
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(
            icon: "house.fill",
            title: "Savings",
            number: "(1234)",
            amount: "$1245.45",
            isSelected: false
        )
        .previewLayout(.sizeThatFits) // Ensures proper preview size
        .padding() // Adds spacing for better visibility
    }
}

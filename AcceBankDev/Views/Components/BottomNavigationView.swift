//
//  BottomNavigationView.swift
//  AcceBankDev
//
//  Created by MCT on 19/02/25.
//

import SwiftUI

struct BottomNavigationBar: View {

    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    // Home button action
                }) {
                    Image(systemName: "house.fill")
                        .font(.system(size:28))
                        .foregroundColor(.white)
//                    Image("Bank")
//                        .resizable() // Allows resizing
//                        .scaledToFit() // Ensures the image maintains its aspect ratio
//                        .frame(width: 40, height: 40) // Set the desired size
//                        .foregroundColor(.white) // If the image is a system icon (SF Symbol)


                }
                
                Spacer()
                
                Button(action: {
                    // Settings button action
                }) {
                    Image(systemName: "creditcard")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {
                    // Add button action
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.deepTeal) // Replace "deepTeal" with a color of your choice
                            .frame(width: 65, height: 65)
                            .shadow(radius: 5)

                        Image(systemName: "plus")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Profile button action
                }) {
                    Image(systemName: "dollarsign.bank.building")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
//                    Image("Dollar")
//                        .resizable() // Allows resizing
//                        .scaledToFit() // Ensures the image maintains its aspect ratio
//                        .frame(width: 40, height: 40) // Set the desired size
//                        .foregroundColor(.white) // If the image is a system icon (SF Symbol)

                }
                
                Spacer()
                
                Button(action: {
                    // Home button action
                }) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
//                    Image("Cardicon")
//                        .resizable() // Allows resizing
//                        .scaledToFit() // Ensures the image maintains its aspect ratio
//                        .frame(width: 30, height: 30) // Set the desired size
//                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            //**************
//            .frame(height: 85)
//            .frame(maxWidth: .infinity)
//            .background(
//                RoundedRectangle(cornerRadius: 30, style: .continuous)
//                    .fill(Color.black.opacity(0.8))
//                    .ignoresSafeArea(.all, edges: .bottom)
//            )
            //*************************************
            
            //                .background(Color.black)
            //                //.cornerRadius(20)
            //                .clipShape(RoundedCorner(radius: 25, corners: [.topLeft, .topRight]))
            //                .ignoresSafeArea(edges: .bottom)
            
            //                .frame(height: 85) // Adjusted height for better fitting
            //                .frame(maxWidth: .infinity, alignment: .bottom) // Ensure it stays at bottom
            //                .background(Color.black)
            //                .clipShape(RoundedCorner(radius: 25, corners: [.topLeft, .topRight])) // Top rounded corners only
            //                .padding(.bottom, 0) // E
            //                .ignoresSafeArea(.all, edges: .bottom) //
                            //below is working
                            //.padding(.bottom, 1)
            .frame(height: 90)
            .frame(height: 85)
            .frame(maxWidth: .infinity)
            
            //                .background(RoundedRectangle(cornerRadius: 30, style: .continuous)
            //                    .fill(Color.black)
            //                    .opacity(0.6)
            //                    .ignoresSafeArea(.all, edges: .bottom)
            //                )
            .background(RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.black.opacity(0.99))
                        .ignoresSafeArea(.all, edges: .bottom)
                            )
        }
    }
}

// Preview
struct BottomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationBar()
    }
}

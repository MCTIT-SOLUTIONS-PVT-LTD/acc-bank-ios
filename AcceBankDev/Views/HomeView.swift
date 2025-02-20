
import SwiftUI

struct HomeView: View {
    var username: String
    @State private var selectedAccount: String = "Chequing" // Default selected account
    let cardImages = ["Card", "Card", "Card"] // Replace with actual image names

    
    
    
    
    
    
    var body: some View {
           GeometryReader { geometry in
               let screenWidth = geometry.size.width
               let screenHeight = geometry.size.height
               let isTablet = UIDevice.current.userInterfaceIdiom == .pad
               let isLandscape = screenWidth > screenHeight

               ZStack(alignment: .bottom) {
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

                   // **Enable ScrollView only in Landscape Mode**
                   let content = VStack {
                       Spacer()

                       // Profile Image
                       Image("profilePic")
                           .resizable()
                           .scaledToFit()
                           .frame(width: screenWidth * 0.15, height: screenWidth * 0.2)
                           .clipShape(Circle())

                       // Welcome Text
                       Text("Welcome \(username) to")
                           .font(.system(size: isTablet ? 32 : 18, weight: .bold))
                           .foregroundColor(.white)

                       Text("Acceinfo Bank")
                           .font(.system(size: isTablet ? 29 : 22, weight: .bold))
                           .foregroundColor(.white)

                       Text(getGreeting())
                           .font(.system(size: isTablet ? 29 : 20, weight: .bold))
                           .foregroundColor(.white)
                           .padding(.top, 5)

                       Spacer()

                       // White Rounded Box
                       RoundedRectangle(cornerRadius: 20)
                           .fill(Color.white)
                           .frame(
                               width: min(screenWidth * 0.85, 550),
                               height: min(screenHeight * 0.55, 550)
                           )
                           .overlay(
                               VStack(spacing: 5) {
                                   // Accounts Section
                                   // Accounts Section (Fix for icon alignment)
                                   HStack(spacing: isLandscape ? 40 : 20) { // Increase spacing in landscape mode
                                       AccountView(icon: "house.fill", title: "Savings", number: "(1234)", amount: "USD 1245.45", isSelected: selectedAccount == "Savings")
                                           .onTapGesture { selectedAccount = "Savings" }
                                       
                                       Divider()
                                           .frame(width: 1, height: 40)
                                           .background(Color.black)

                                       AccountView(icon: "creditcard.fill", title: "Chequing", number: "(3456)", amount: "USD 2000.45", isSelected: selectedAccount == "Chequing")
                                           .onTapGesture { selectedAccount = "Chequing" }
                                       
                                       Divider()
                                           .frame(width: 1, height: 40)
                                           .background(Color.black)

                                       AccountView(icon: "magnifyingglass.circle.fill", title: "Loan", number: "(9999)", amount: "USD -5555.45", isSelected: selectedAccount == "Loan")
                                           .onTapGesture { selectedAccount = "Loan" }
                                   }
                                   .frame(maxWidth: .infinity) // Allow content to expand properly
                                   .padding(.top, isLandscape ? 15 : -50) // Adjust position in landscape mode


                                   // **Only Show Cards When "Chequing" is Selected**
                                   if selectedAccount == "Chequing" {
                                       ScrollView(.horizontal, showsIndicators: false) {
                                           HStack(spacing: 15) {
                                               ForEach(cardImages, id: \.self) { card in
                                                   CreditCardView(imageName: card)
                                                       .frame(width: isTablet ? 500 : 350)
                                               }
                                           }
                                           .padding(.horizontal)
                                       }
                                       .frame(height: isTablet ? 300 : 200)
                                       .transition(.opacity)
                                       .padding(.bottom, 20)

                                   } else {
                                       // **Keep Empty Space to Maintain Height**
                                       Spacer()
                                           .frame(height: min(screenHeight * 0.25, 200))
                                           .padding(.bottom, 20)
                                   }
                               }
                           )
                           .animation(.easeInOut(duration: 0.3), value: selectedAccount)

                       Spacer()
                   }
                   .padding(.bottom, isLandscape ? screenHeight * 0.12 : screenHeight * 0.15)

                   // **Apply ScrollView only when in Landscape Mode**
                   if isLandscape {
                       ScrollView(.vertical, showsIndicators: false) {
                           content
                       }
                   } else {
                       content
                   }

                   // **Bottom Navigation Bar**
                   BottomNavigationBar()
                       .frame(height: screenHeight * 0.1)
                       .background(RoundedRectangle(cornerRadius: 30, style: .continuous)
                                   .fill(Color.black.opacity(0.99))
                                   .ignoresSafeArea(.all, edges: .bottom)
                                       )
                       .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
                       .position(x: screenWidth / 2, y: screenHeight - (screenHeight * 0.05))
               }
           }
       }

    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
// Credit Card View




struct CreditCardView: View {
    var imageName: String

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let isTablet = UIDevice.current.userInterfaceIdiom == .pad

            Image(imageName)
                .resizable()
                .scaledToFit() // Ensures correct aspect ratio
                .frame(
                    width: isTablet ? min(screenWidth * 0.75, 600) : min(screenWidth * 0.9, 420), // Wider size
                    height: isTablet ? min(screenHeight * 0.4, 320) : min(screenHeight * 0.3, 250) // Taller size
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal, isTablet ? 30 : 10) // Extra padding for larger screens
        }
        .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 320 : 250) // Prevents shrinking
    }
}





// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(username: "Danielle")
    }
}

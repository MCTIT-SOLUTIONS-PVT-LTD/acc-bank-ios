import SwiftUI

struct HomeView: View {
    var username: String
    @State private var selectedAccount: String = "Chequing" // Default selected account
    let cardImages = ["Card", "Card", "Card"] // Replace with actual image names

    var body: some View {
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

            VStack {
                Spacer()

                // Profile Image
                Image("profilePic")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(radius: 5)

                // Welcome Text
                Text("Welcome \(username) to")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)

                Text("Acceinfo Bank")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Text(getGreeting())
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 5)

                Spacer()

                // Account Summary Section
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 360, height: 450) // Increased height for better fit
                    .shadow(radius: 5)
                    .overlay(
                        VStack(spacing: 15) {
                            // Accounts Section
                            HStack {
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
                            .padding(.bottom, 30) // Reduce space to fit better
                            .padding(.horizontal, 10)

                            // Scrollable Credit Cards Section
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(cardImages, id: \.self) { card in
                                        CreditCardView(imageName: card)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 190) // Make sure the scrollable view has proper height
                            .padding(.bottom, 20) // Reduce gap
                        }
                    )

                Spacer()
            }
            .padding(.bottom, 80) // Ensures spacing above the navigation bar

            // **Bottom Black Navigation Bar**
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Home button action
                    }) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Settings button action
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Add button action
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 55, height: 55)
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
                        Image(systemName: "person.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    Button(action: {
                        // Home button action
                    }) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
//                .frame(height: 90)
//                .background(Color.black)
//                //.cornerRadius(20)
//                .clipShape(RoundedCorner(radius: 25, corners: [.topLeft, .topRight]))
//                .ignoresSafeArea(edges: .bottom)
                .frame(height: 85) // Adjusted height for better fitting
                .frame(maxWidth: .infinity, alignment: .bottom) // Ensure it stays at bottom
                .background(Color.black)
                //.clipShape(RoundedCorner(radius: 25, corners: [.topLeft, .topRight])) // Top rounded corners only
                .padding(.bottom, 0) // E
                .ignoresSafeArea(.all, edges: .bottom) //
            
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
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 280, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(username: "Danielle")
    }
}

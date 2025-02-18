import SwiftUI

struct HomeView: View {
    var username: String
    @State private var selectedAccount: String = "Chequing" // Default selected account

    var body: some View {
        ZStack {
            // Background Gradient
//            LinearGradient(
//                gradient: Gradient(colors: [
//                    Color.blue.opacity(0.8),
//                    Color.blue
//                ]),
//                startPoint: .top, endPoint: .bottom
//            )
//            .edgesIgnoringSafeArea(.all)
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
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
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
                    .frame(width: 360, height: 400)
                    .shadow(radius: 5)
                    .overlay(
                        VStack {
                            HStack {
                                AccountView(icon: "house.fill", title: "Savings", number: "(1234)", amount: "USD 1245.45", isSelected: selectedAccount == "Savings")
                                    .onTapGesture { selectedAccount = "Savings" }
                                
                                Divider() // Horizontal line between items
                                    .frame(height: 40) // Adjust height of the line
                                    .background(Color.black)
                            

                                AccountView(icon: "creditcard.fill", title: "Chequing", number: "(3456)", amount: "USD 2000.45", isSelected: selectedAccount == "Chequing")
                                    .onTapGesture { selectedAccount = "Chequing" }

                                Divider() // Another divider between items
                                    .frame(height: 40)
                                    .background(Color.black)
                                   //.alignmentGuide(.center) { d in d[.center] } // Ensures it stays in center

                              

                                AccountView(icon: "magnifyingglass.circle.fill", title: "Loan", number: "(9999)", amount: "USD 5555.45", isSelected: selectedAccount == "Loan")
                                    .onTapGesture { selectedAccount = "Loan" }
                            }
                            .padding(.bottom,250)
                            .padding(.horizontal, 10)


                        }
                    )

                Spacer()
            }
            .padding(.bottom, 50)
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




// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(username: "Danielle")
    }
}

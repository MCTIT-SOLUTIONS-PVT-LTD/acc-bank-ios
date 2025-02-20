import SwiftUI

struct MoveMoneyView: View {
    @State private var selectedTab = "Current" // Default selected tab
    @State private var showOptions = true // Controls visibility of options
    let buttonWidth: CGFloat = 380 // Adjust width

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                //icon ,move money, lock icon
                HStack {
                    CircleButton(icon: "line.horizontal.3") {
                        print("Menu Tapped")
                    }

                    Spacer()

                    Text("Move Money")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    Spacer()

                    CircleButton(icon: "lock.fill") {
                        print("Lock Tapped")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                //button
                HStack(spacing: 0) {
                    //selection of button
                    Button(action: {
                        selectedTab = "Current"
                        showOptions = true
                    }) {
                        Text("Current")
                            .fontWeight(.bold)
                            .foregroundColor(selectedTab == "Current" ? .white : .black)//font color
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedTab == "Current" ? Color.blue : Color.clear)//background color
                            .clipShape(Capsule())
                            .shadow(color: selectedTab == "Current" ? Color.black.opacity(0.4) : Color.clear, radius: 4, x: 0, y: 4)//shadow of button
                    }

                    // **Saving Button**
                    Button(action: {
                        selectedTab = "Saving"
                        showOptions = false // Hide options when Saving is selected
                    }) {
                        Text("Saving")
                            .fontWeight(.bold)
                            .foregroundColor(selectedTab == "Saving" ? .white : .black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedTab == "Saving" ? Color.blue : Color.clear)
                            .clipShape(Capsule())
                            .shadow(color: selectedTab == "Saving" ? Color.black.opacity(0.2) : Color.clear, radius: 4, x: 0, y: 4)
                    }
                }
                .frame(width: buttonWidth, height: 50)//width of capsule
                .background(Color.gray.opacity(0.3))
                .clipShape(Capsule())
                .padding(.horizontal, 20)
                .padding(.top, 10)//padding of button from move money
                
                if showOptions {
                    ScrollView {
                        VStack(spacing: 15) {
                            OptionItem(icon: "dollarsign.circle.fill", title: "Transfer Between My Accounts", subtitle: "Own Bank Accounts")
                            OptionItem(icon: "creditcard.fill", title: "Pay a Bill", subtitle: "Water or Other")
                            OptionItem(icon: "arrow.right.circle.fill", title: "Send an Interac e-Transfer", subtitle: "Transfer Funds Between Canadian Bank")
                            OptionItem(icon: "person.fill", title: "Send to an Own Client", subtitle: "Send Money to Your Client")
                            OptionItem(icon: "tray.and.arrow.down.fill", title: "Deposit a Cheque", subtitle: "Add Funds by Depositing a Cheque")
                            OptionItem(icon: "arrow.triangle.2.circlepath", title: "Request Money", subtitle: "Ask for a Payment")
                            OptionItem(icon: "globe", title: "International Money Transfer", subtitle: "Send Money to a Different Country")
                            OptionItem(icon: "globe", title: "International Money Transfer", subtitle: "Send Money to a Different Country")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                    .transition(.opacity)
                    .frame(maxHeight: .infinity) // 🛠 Fixes scrolling issue
                } else {
                    Color.white
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.opacity)
                }
            }
            //whole background color
            .background(Color.white.edgesIgnoringSafeArea(.all))

            // Bottom Navigation Bar
            BottomNavigationBar()
        }
    }
}

// **Reusable Circle Button Component**
struct CircleButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .padding(12)
                .background(Color.black)
                .clipShape(Circle())
                .foregroundColor(.white)
        }
    }
}

// **Reusable Option Item**
struct OptionItem: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
    }
}

// **Preview**
struct MoveMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        MoveMoneyView()
    }
}

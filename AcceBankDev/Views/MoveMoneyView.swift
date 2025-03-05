import SwiftUI

struct MoveMoneyView: View {
    static let allSections: [MoveMoneySection] = [
        MoveMoneySection(
            title: NSLocalizedString("transfers_title", comment: ""),
            options: [
                MoveMoneyOption(icon: "arrow.right.arrow.left", title: NSLocalizedString("transfer_money", comment: "")),
//                MoveMoneyOption(icon: "network", title: NSLocalizedString("wire_transfer", comment: "")),
//                MoveMoneyOption(icon: "globe", title: NSLocalizedString("international_transfer", comment: "")),
//                MoveMoneyOption(icon: "bolt.fill", title: NSLocalizedString("instant_transfer", comment: "")),
//               MoveMoneyOption(icon: "qrcode", title: NSLocalizedString("quick_pay", comment: "")),
//                MoveMoneyOption(icon: "house.fill", title: NSLocalizedString("local_transfer", comment: "")),
//                MoveMoneyOption(icon: "iphone", title: NSLocalizedString("mobile_wallet", comment: "")),
//                MoveMoneyOption(icon: "bitcoinsign.circle.fill", title: NSLocalizedString("crypto_transfer", comment: "")),
//                MoveMoneyOption(icon: "house.fill", title: NSLocalizedString("local_transfer", comment: "")),
                MoveMoneyOption(icon: "person.2.fill", title: NSLocalizedString("manage_recipient", comment: "")),
                MoveMoneyOption(icon: "calendar.circle", title: NSLocalizedString("schedule_transfer", comment: "")),
                //MoveMoneyOption(icon: "bitcoinsign.circle.fill", title: NSLocalizedString("crypto_transfer", comment: ""))
            ]
        ),
        MoveMoneySection(
            title: NSLocalizedString("interac_transfer", comment: ""),
            options: [
                MoveMoneyOption(icon: "square.and.arrow.up.fill", title: NSLocalizedString("send_money", comment: "")),
                MoveMoneyOption(icon: "arrow.down.left.circle.fill", title: NSLocalizedString("request_money", comment: "")),
//                MoveMoneyOption(icon: "person.2.fill", title: NSLocalizedString("manage_contacts", comment: "")),
                MoveMoneyOption(icon: "clock.arrow.circlepath", title: NSLocalizedString("pending_transactions", comment: "")),
                MoveMoneyOption(icon: "clock.fill", title: NSLocalizedString("transfer_history", comment: "")),
               // MoveMoneyOption(icon: "gearshape.fill", title: NSLocalizedString("auto_deposit", comment: "")),
               // MoveMoneyOption(icon: "person.crop.circle", title: NSLocalizedString("profile_settings", comment: "")),
//                MoveMoneyOption(icon: "shield.fill", title: NSLocalizedString("security_settings", comment: ""))
            ]
        ),
        MoveMoneySection(
            title: NSLocalizedString("payments_option", comment: ""),
            options: [
                MoveMoneyOption(icon: "creditcard.fill", title: NSLocalizedString("utility_bills", comment: "")),
                MoveMoneyOption(icon: "banknote.fill", title: NSLocalizedString("mutiple_bills", comment: "")),
//                MoveMoneyOption(icon: "arrow.2.circlepath.circle.fill", title: NSLocalizedString("loan_repayment", comment: "")),
//                MoveMoneyOption(icon: "cross.circle.fill", title: NSLocalizedString("insurance_payments", comment: "")),
//                MoveMoneyOption(icon: "graduationcap.fill", title: NSLocalizedString("education_fees", comment: "")),
//                MoveMoneyOption(icon: "cart.fill", title: NSLocalizedString("online_shopping", comment: "")),
//                MoveMoneyOption(icon: "play.circle.fill", title: NSLocalizedString("subscription_services", comment: "")),
//                MoveMoneyOption(icon: "doc.fill", title: NSLocalizedString("government_taxes", comment: ""))
            ]
        ),
//        MoveMoneySection(
//            title: NSLocalizedString("scheduled_transfers", comment: ""),
//            options: [
//                MoveMoneyOption(icon: "square.and.arrow.up.fill", title: NSLocalizedString("send_money", comment: "")),
//                MoveMoneyOption(icon: "arrow.down.left.circle.fill", title: NSLocalizedString("request_money", comment: "")),
//                MoveMoneyOption(icon: "person.2.fill", title: NSLocalizedString("manage_contacts", comment: "")),
//                MoveMoneyOption(icon: "clock.arrow.circlepath", title: NSLocalizedString("pending_transactions", comment: "")),
//                MoveMoneyOption(icon: "clock.fill", title: NSLocalizedString("transfer_history", comment: "")),
//                MoveMoneyOption(icon: "gearshape.fill", title: NSLocalizedString("auto_deposit", comment: "")),
//                MoveMoneyOption(icon: "person.crop.circle", title: NSLocalizedString("profile_settings", comment: "")),
//                MoveMoneyOption(icon: "shield.fill", title: NSLocalizedString("security_settings", comment: ""))
//            ]
//        ),
//        MoveMoneySection(
//            title: NSLocalizedString("scheduled_transfers", comment: ""),
//            options: [
//                MoveMoneyOption(icon: "square.and.arrow.up.fill", title: NSLocalizedString("send_money", comment: "")),
//                MoveMoneyOption(icon: "arrow.down.left.circle.fill", title: NSLocalizedString("request_money", comment: "")),
//                MoveMoneyOption(icon: "person.2.fill", title: NSLocalizedString("manage_contacts", comment: "")),
//                MoveMoneyOption(icon: "clock.arrow.circlepath", title: NSLocalizedString("pending_transactions", comment: "")),
//                MoveMoneyOption(icon: "clock.fill", title: NSLocalizedString("transfer_history", comment: "")),
//                MoveMoneyOption(icon: "gearshape.fill", title: NSLocalizedString("auto_deposit", comment: "")),
//                MoveMoneyOption(icon: "person.crop.circle", title: NSLocalizedString("profile_settings", comment: "")),
//                MoveMoneyOption(icon: "shield.fill", title: NSLocalizedString("security_settings", comment: ""))
//            ]
        //)
    ]
    
    @State private var showSendMoneyView = false // To show the Send Money screen
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.backgroundGradient.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text(NSLocalizedString("move_money_title", comment: ""))
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(MoveMoneyView.allSections, id: \.title) { section in
                                MoveMoneySectionView(section: section)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    
                }
            }
            .fullScreenCover(isPresented: $showSendMoneyView) {
                SendMoneyView() // Open
            }
        }
    }
    
    // MARK: - Move Money Section View
    struct MoveMoneySectionView: View {
        let section: MoveMoneySection
        @State private var isShowingAllOptions = false
        
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(section.title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.leading, 15)
                    .padding(.top, 10)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(section.options.prefix(7)) { option in
                        MoveMoneyOptionView(option: option)
                    }
                    
                    if section.options.count > 7 {
                        Button(action: {
                            isShowingAllOptions.toggle() // Toggle visibility of the full list
                        }) {
                            VStack {
                                Image(systemName: "ellipsis.circle.fill") // "See More" Icon
                                    .font(.system(size: 28))
                                    .foregroundColor(.black)
                                
                                Text(NSLocalizedString("see_more", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 80, height: 80)
                        }
                    }
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal, 15)
            .fullScreenCover(isPresented: $isShowingAllOptions) {
                MoveMoneyFullView(sections: MoveMoneyView.allSections) // This will open in a new screen without bottom navbar
            }
        }
    }
    struct MoveMoneyFullView: View {
        let sections: [MoveMoneySection]
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        @Environment(\.dismiss) var dismiss // To dismiss the current view
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(NSLocalizedString("all_options_title", comment: "")) // Title
                            .font(.title)
                            .bold()
                            .padding(.top, 20)
                            .padding(.horizontal, 15)
                        
                        ForEach(sections, id: \.title) { section in
                            VStack(alignment: .leading) {
                                Text(section.title)
                                    .font(.headline)
                                    .bold()
                                    .padding(.leading, 15)
                                    .padding(.top, 10)
                                
                                LazyVGrid(columns: columns, spacing: 20) {
                                    ForEach(section.options) { option in
                                        MoveMoneyOptionView(option: option)
                                    }
                                }
                                .padding()
                            }
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.horizontal, 15)
                        }
                    }
                }
                .background(Constants.backgroundGradient.edgesIgnoringSafeArea(.all))
                //            .navigationTitle(NSLocalizedString("all_options_title", comment: "")) // Title for the screen
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss() // Dismiss the view and go back to the previous screen
                        }) {
                            Image(systemName: "chevron.left") // This is the back arrow symbol

                            //Text("Back") // Custom back button text
                                .foregroundColor(.blue) // Set the color to blue
                                .font(.headline) // Use a bold font to make it look prominent
                        }
                    }
                }
            }
        }
    }
    
    
    
//below is based on if else
//    struct MoveMoneyOptionView: View {
//        let option: MoveMoneyOption
//        @State private var isShowingSendMoney = false // State to control full-screen presentation
//        @State private var isShowingPayBill = false // State to control full-screen presentation for Pay Bills
//        var body: some View {
//            VStack {
//                Image(systemName: option.icon)
//                    .font(.system(size: 24))
//                    .foregroundColor(.black)
//                    //.symbolRenderingMode(.multicolor) // Enables SF Symbols' colors
//
//                
//                Text(option.title)
//                    .font(.caption)
//                    .foregroundColor(.black)
//                    .multilineTextAlignment(.center)
//            }
//            .frame(width: 80, height: 80)
//            .onTapGesture {
////                if option.title == NSLocalizedString("send_money", comment: "") {
////                    isShowingSendMoney = true // Show the Send Money screen in full screen
////                }
////            }
//                if option.title == NSLocalizedString("send_money", comment: "") {
//                                isShowingSendMoney = true // Show Send Money screen
//                            } else if option.title == NSLocalizedString("utility_bills", comment: "") {
//                                isShowingPayBill = true // Show Pay Bills screen
//                            }
//                        }
//            .fullScreenCover(isPresented: $isShowingSendMoney) {
//                SendMoneyView() // Open Send Money screen as a full-screen view
//            }
//            .fullScreenCover(isPresented: $isShowingPayBill) {
//                        PayBillScreen() // Open Pay Bill screen as a full-screen view
//                    }
//
//        }
//    }
    
    //below using switch
    struct MoveMoneyOptionView: View {
        let option: MoveMoneyOption
        @State private var isShowingSendMoney = false
        @State private var isShowingPayBill = false
        
        var body: some View {
            VStack {
                Image(systemName: option.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.black)

                Text(option.title)
                    .font(.caption)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80, height: 80)
            .onTapGesture {
                // Handle different screens dynamically
                switch option.title {
                case NSLocalizedString("send_money", comment: ""):
                    isShowingSendMoney = true
                case NSLocalizedString("utility_bills", comment: ""):
                    isShowingPayBill = true
                // Add more cases for other screens as needed
                default:
                    break
                }
            }
            .fullScreenCover(isPresented: $isShowingSendMoney) {
                SendMoneyView()
            }
            .fullScreenCover(isPresented: $isShowingPayBill) {
                PayBillScreen()
            }
        }
    }

    
    struct MoveMoneySection {
        let title: String
        let options: [MoveMoneyOption]
    }
    
    struct MoveMoneyOption: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
    }
    
    //struct SendMoneyView: View {
    //    var body: some View {
    //        Text("Send Money Page")
    //            .font(.title)
    //            .padding()
    //    }
    //}
}
struct MoveMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        MoveMoneyView()
    }
}



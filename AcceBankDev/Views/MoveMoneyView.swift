import SwiftUI

struct MoveMoneyView: View {
    @State private var isShowingTransferOptions = false // State to show modal
    
    @State private var isShowingPaymentsOptions = false //  State to show Payments modal

    var body: some View {
        ZStack {
           
            Color.backgroundGradient.edgesIgnoringSafeArea(.all) //Global Gradient


            VStack(spacing: 25) {
                //Text("Move money")
                Text(NSLocalizedString("move_money_title", comment: ""))

                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                            .padding(.top, 30)
                    .padding(.bottom, 35)

                //optionButton(title: "Transfers")
                optionButton(title: NSLocalizedString("transfers_option", comment: ""))

                
//                optionButton(title: "Interac e-Transfer®", italic: true) {
//                    isShowingTransferOptions.toggle() // Open modal on tap
//                }
                optionButton(title: NSLocalizedString("interac_transfer", comment: "")) {
                    isShowingTransferOptions.toggle()
                }

//                optionButton(title: "Payments")
//                {
//                isShowingPaymentsOptions.toggle() //  Open Payments modal
//                }
                optionButton(title: NSLocalizedString("payments_option", comment: "")) {
                    isShowingPaymentsOptions.toggle()
                }
                //optionButton(title: "Scheduled transfers & payments")
                optionButton(title: NSLocalizedString("scheduled_transfers", comment: ""))

                Spacer()
            }
            .padding(.top, 10)
        }
        // MARK: - Show Transfer Options Modal
        .sheet(isPresented: $isShowingTransferOptions) {
            TransferOptionsView()
                .presentationDetents([.medium, .large]) // Set modal sizes
                .presentationDragIndicator(.visible) // Show drag indicator
        }
        .sheet(isPresented: $isShowingPaymentsOptions) {
                    PaymentsOptionsView() //  New Payments Bottom Sheet
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
        
    }
        
    /// Reusable Button
    private func optionButton(title: String, italic: Bool = false, action: (() -> Void)? = nil) -> some View {
        Button(action: {
            action?() // Call the function if provided
        }) {
            HStack {
                if italic {
                    Text(title)
                        .font(.system(size: 20, weight: .medium))
                        .italic()
                        .foregroundColor(.white)
                } else {
                    Text(title)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color.black)
            .cornerRadius(10)
        }
        .padding(.horizontal, 20)
    }
}
struct PaymentsOptionsView: View {
    @State private var isShowingBillPayment = false //  Show Bill Payment Form

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                //Text("Payments")
                Text(NSLocalizedString("payments_title", comment: ""))

                    .font(.headline)
                    .italic()
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                
                Spacer()
                
                Button(action: {
                    // Close the modal
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                }) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(15)
                }
            }
            .padding(.top, 15)
            
            Divider()
            
//            paymentOption(icon: "creditcard.fill", title: "Pay bills")
//            paymentOption(icon: "arrow.right.arrow.left", title: "Transfer between accounts")
//            paymentOption(icon: "calendar.badge.clock", title: "Manage scheduled payments")
//            paymentOption(icon: "gearshape.fill", title: "Payment settings")
            paymentOption(icon: "creditcard.fill", title: NSLocalizedString("pay_bills", comment: ""))
            paymentOption(icon: "arrow.right.arrow.left", title: NSLocalizedString("transfer_accounts", comment: ""))
            paymentOption(icon: "calendar.badge.clock", title: NSLocalizedString("scheduled_payments", comment: ""))
            paymentOption(icon: "gearshape.fill", title: NSLocalizedString("payment_settings", comment: ""))

            
            //Spacer()
        }
        .padding(.horizontal, 20) //  Keep consistent horizontal padding
        
        .frame(width: 350)
        .background(Color(.white).opacity(0.6))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }

    private func paymentOption(icon: String, title: String) -> some View {
        Button(action: {
            if title == "Pay bills" {
                isShowingBillPayment.toggle() // Open Bill Payment Form
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.black)
                    .font(.title2)
                    .frame(width: 20, height: 30)

                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(.black)

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.clear)
            .cornerRadius(10)
        }
        .padding(.horizontal)
//        .sheet(isPresented: $isShowingBillPayment) {
//            BillPaymentView() //  Open the new Bill Payment Form
//        }
    }
}


//  shows option like send money and all Create the Bottom Sheet View

struct TransferOptionsView: View {
    @State private var isShowingSendMoneyForm = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                //Text("Interac e-Transfer®")
                Text(NSLocalizedString("interac_transfer", comment: ""))

                    .font(.headline)
                    .italic()
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                    .padding(.top, 20) // Increased padding to match Payments modal


                Spacer()

                Button(action: {
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                }) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(15)
                    //Text(NSLocalizedString("close_button", comment: ""))
                }
            }
            .padding(.top, 15)

            Divider()

//            transferOption(icon: "square.and.arrow.up.fill", title: "Send money")
//            transferOption(icon: "arrow.down.left.circle.fill", title: "Request money")
//            transferOption(icon: "person.2.fill", title: "Manage contacts")
//            transferOption(icon: "clock.arrow.circlepath", title: "Pending")
//            transferOption(icon: "clock.fill", title: "History")
//            transferOption(icon: "gearshape.fill", title: "Autodeposit settings")
//            transferOption(icon: "person.crop.circle", title: "Profile settings")
            transferOption(icon: "square.and.arrow.up.fill", title: NSLocalizedString("send_money", comment: ""))
            transferOption(icon: "arrow.down.left.circle.fill", title: NSLocalizedString("request_money", comment: ""))
            transferOption(icon: "person.2.fill", title: NSLocalizedString("manage_contacts", comment: ""))
            transferOption(icon: "clock.arrow.circlepath", title: NSLocalizedString("pending_transactions", comment: ""))
            transferOption(icon: "clock.fill", title: NSLocalizedString("transfer_history", comment: ""))
            transferOption(icon: "gearshape.fill", title: NSLocalizedString("auto_deposit", comment: ""))
            transferOption(icon: "person.crop.circle", title: NSLocalizedString("profile_settings", comment: ""))


            Spacer()
        }
        .frame(width: 350)
        .background(Color(.white).opacity(0.9)) //  Match background opacity with Payments modal
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }

    private func transferOption(icon: String, title: String) -> some View {
//        Button(action: {
//            if title == "Send money" {
//                isShowingSendMoneyForm.toggle()
//            }
        Button(action: {
            if title == NSLocalizedString("send_money", comment: "") {
                isShowingSendMoneyForm.toggle()
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.black)
                    .font(.title2)
                    .frame(width: 20, height: 30)

                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(.black)

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.clear)
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .sheet(isPresented: $isShowingSendMoneyForm) {
            SendMoneyView()
        }
    }
}

    
    

//}
    //  Preview
    struct MoveMoneyView_Previews: PreviewProvider {
        static var previews: some View {
            MoveMoneyView()
        }
    }


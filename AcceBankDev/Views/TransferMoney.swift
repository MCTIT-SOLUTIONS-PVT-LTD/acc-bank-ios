

import SwiftUI

struct TransferMoneyScreen: View {
    @State private var selectedDate = Date() // Date for the DatePicker
        @State private var showDatePicker = false // Toggle for DatePicker visibility

    @Environment(\.presentationMode) var presentationMode // To dismiss the modal
    @StateObject private var accountManager = AccountManager()

    @State private var selectedPaymentType: String? = nil // Track selected payment type
    @State private var showAccountSheet = false // Toggle for full-screen modal
    @State private var selectedContact: Contact?
    @State private var showContactSheet = false // Show Contact Selection Sheet
    @State private var showAddContactSheet = false // New state to show Add Contact form

    @State private var payFrom = ""
    @State private var payee = ""
    @State private var amount = ""
    @State private var text = ""

    @State private var date = Date()
    @State private var dateText: String? = nil //  TextField remains empty until date is selected
    @State private var isRecurring = false // Toggle state for One-Time/Recurring
        @State private var selectedFrequency = "Weekly" // De
    @State private var onetime = false // ✅ Toggle for email transfers
    
    @State private var showTransferToError = false
       @State private var showAmountError = false
       @State private var showDateError = false

        @State private var recurring = false // ✅
    @State private var showFromAccountSheet = false // ✅ Separate modal for "Transfer From"
        @State private var showToAccountSheet = false // ✅ Separate modal for "Transfer To"
        @State private var selectedFromAccount: Account? = nil // ✅ Separate state for "Transfer From"
        @State private var selectedToAccount: Account? = nil
    @State private var showTransferFromError = false

    var body: some View {
        ScrollView {
            VStack {
                // Top Bar with Back Button
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text(NSLocalizedString("tansfer_money", comment: ""))
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()

                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 0) { // Remove spacing between buttons
                                    // My accounts Button
                        Button(action: {
                                   selectedPaymentType = "My accounts"
                               }) {
                                   Text("My accounts")
                                       .font(.headline)
                                       .padding()
                                       .frame(maxWidth: .infinity) // Take equal space
                                       .background(
                                           selectedPaymentType == "My accounts" ?
                                           Constants.backgroundGradient : LinearGradient(
                                               gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.5)]),
                                               startPoint: .top,
                                               endPoint: .bottom
                                           )
                                       )
                                       .foregroundColor(selectedPaymentType == "My accounts" ? .white : .gray)
                                       //.clipShape(Capsule()) // Capsule shape
                                       
                               }
                               
                               // History Button
                               Button(action: {
                                   selectedPaymentType = "History"
                               }) {
                                   Text("History")
                                       .font(.headline)
                                       .padding()
                                       .frame(maxWidth: .infinity) // Take equal space
                                       .background(
                                           selectedPaymentType == "History" ?
                                           Constants.backgroundGradient : LinearGradient(
                                               gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.5)]),
                                               startPoint: .top,
                                               endPoint: .bottom
                                           )
                                       )
                                       .foregroundColor(selectedPaymentType == "History" ? .white : .gray)
                                       //.clipShape(Capsule()) // Capsule shape
                               }
                           }
                           .padding(.horizontal) 
                              
                    // Option to choose between one-time and recurring payments
//                    Picker("Payment Type", selection: $selectedPaymentType) {
//                        Text("My accounts").tag("My accounts")
//                        Text("Another member").tag("Another member")
//                    }
//                    .pickerStyle(SegmentedPickerStyle()) // Segmented style for better UI
//                    //.background(Constants.backgroundGradient)
//                    .padding()

                    // Show the form when One-time Payment is selected
                    if selectedPaymentType == "My accounts" {
                        VStack(spacing: 15) {
                            // "Pay from" Dropdown
//                            Text(NSLocalizedString("transfer_from", comment: ""))
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left

                            Button(action: { showFromAccountSheet = true }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
        //                                Text(accountManager.selectedAccount?.accountName ?? "Select Account")
                                        //Text(accountManager.selectedAccount?.accountName ?? NSLocalizedString("select_account", comment: ""))
                                        Text(selectedFromAccount?.accountName ?? NSLocalizedString("transfer_from", comment: ""))


                                        .font(.headline)
                                            .bold()
                                            .foregroundColor(.black)
                                        //Text(accountManager.selectedAccount?.accountType ?? "")
                                        Text(selectedFromAccount?.accountType ?? "")

                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        //Text(accountManager.selectedAccount?.accountNumber ?? "")
                                        Text(selectedFromAccount?.accountNumber ?? "")

                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    //Text(accountManager.selectedAccount?.balance ?? "")
                                    Text(selectedFromAccount?.balance ?? "")

                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                            .sheet(isPresented: $showFromAccountSheet) {
                                TransferAccountSheet(accountManager: accountManager, selectedAccount: $selectedFromAccount, isPresented: $showFromAccountSheet)
                            }

                            // "Payee" Dropdown
                            //Text("Send to")//
//                            Text(NSLocalizedString("send_to", comment: ""))
//
//                            .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
//                            Button(action: { showContactSheet = true }) {
//                                HStack {
//        //                            Text(selectedContact?.name ?? "Select Contact")
//                                    Text(selectedContact?.name ?? NSLocalizedString("payee", comment: ""))
//                                    Spacer()
//                                    Image(systemName: "chevron.down")
//                                }
//                                .padding()
//                                .background(Color(.systemGray6))
//                                .cornerRadius(10)
//                                
//                                
//                            }
//                            Text(NSLocalizedString("transfer_to", comment: ""))
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left

                            Button(action: { showToAccountSheet = true }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
        //                                Text(accountManager.selectedAccount?.accountName ?? "Select Account")
//                                        Text(accountManager.selectedAccount?.accountName ?? NSLocalizedString("select_account", comment: ""))
                                        Text(selectedToAccount?.accountName ?? NSLocalizedString("transfer_to", comment: ""))

                                        .font(.headline)
                                            .bold()
                                            .foregroundColor(.black)
                                        //Text(accountManager.selectedAccount?.accountType ?? "")
                                        Text(selectedToAccount?.accountType ?? "")

                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        //Text(accountManager.selectedAccount?.accountNumber ?? "")
                                        Text(selectedToAccount?.accountNumber ?? "")

                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    //Text(accountManager.selectedAccount?.balance ?? "")
                                    Text(selectedToAccount?.balance ?? "")

                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                            .sheet(isPresented: $showToAccountSheet) {
                                TransferAccountSheet(accountManager: accountManager, selectedAccount: $selectedToAccount, isPresented: $showToAccountSheet)
                            }

                            if showTransferToError {
                                                Text("This field is required")
                                                    .foregroundColor(.red)
                                                    .font(.caption)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 2)
                                            }
                            VStack(spacing: 10) {
                            HStack(spacing: 20) { // ✅ Adds spacing between the two toggle boxes
                                // ✅ One-Time Toggle Box
                                VStack {
                                    Toggle(NSLocalizedString("onetime_payment", comment: ""), isOn: $onetime)
                                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                                        .scaleEffect(0.8) // ✅ Reduces the size of the toggle
                                        .lineLimit(1)

                                        .padding(.horizontal, 10) // ✅ Adjusts padding inside the box
                                }
                                .frame(width: 160, height: 60) // ✅ Ensures equal-sized boxes
                                .background(Color(.systemGray6)) // ✅ Adds gray background
                                .cornerRadius(10) // ✅ Rounds corners

                                // ✅ Recurring Toggle Box
                                VStack {
                                    Toggle(NSLocalizedString("recurring_payment", comment: ""), isOn: $recurring)
                                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                                        .scaleEffect(0.8) // ✅ Reduces the size of the toggle
                                        .lineLimit(1)


                                        .padding(.horizontal, 10) // ✅ Adjusts padding inside the box
                                }
                                
                                
                                .frame(width: 160, height: 60) // ✅ Ensures equal-sized boxes
                                .background(Color(.systemGray6)) // ✅ Adds gray background
                                .cornerRadius(10) // ✅ Rounds corners
                            }
                            .padding(.horizontal, 10) // ✅ Adjusts outer spacing

                                if recurring {
                                      VStack {
                                          Text("Select Frequency")
                                              .font(.subheadline)
                                              .foregroundColor(.gray)
                                              .frame(maxWidth: .infinity, alignment: .leading)
                                              .padding(.top, 5)

                                          Picker("Frequency", selection: $selectedFrequency) {
                                              Text("Weekly").tag("Weekly")
                                              Text("Monthly").tag("Monthly")
                                              Text("Yearly").tag("Yearly")
                                          }
                                          .pickerStyle(SegmentedPickerStyle()) // ✅ Clean segmented style
                                          .padding()
                                      }
                                      .transition(.opacity) // ✅ Smooth fade-in effect
                                  }
                              }
                              .animation(.easeInOut) // ✅
                            
                            // "Amount" Text Field
                            TextField("enter_transfer_amount", text: $amount)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            if showAmountError {
                                               Text("This field is required")
                                                   .foregroundColor(.red)
                                                   .font(.caption)
                                                   .frame(maxWidth: .infinity, alignment: .leading)
                                                   .padding(.top, 2)
                                           }
//                            // "Date" Date Picker
//                            DatePicker("date", selection: $date, displayedComponents: .date)
//                                .padding()
//                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                            TextField("date", text: $amount)
//                                //.keyboardType(.decimalPad)
//                                .padding()
//                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            // TextField with Calendar Icon Using .overlay()
                            TextField("Select Date", text: Binding(
                                        get: { dateText ?? "" }, // Show empty state initially
                                        set: { _ in }
                                    ))
                                    .disabled(true) // Prevent manual typing
                                    .padding()
                                    .frame(height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                    .overlay(
                                        HStack {
                                            Spacer() // Push icon to the right
                                            Button(action: {
                                                showDatePicker.toggle()
                                            }) {
                                                Image(systemName: "calendar")
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    )
                                    .onTapGesture {
                                        showDatePicker.toggle()
                                    }
                            if showDateError {
                                              Text("This field is required")
                                                  .foregroundColor(.red)
                                                  .font(.caption)
                                                  .frame(maxWidth: .infinity, alignment: .leading)
                                                  .padding(.top, 2)
                                          }
                            TextField("memo", text: $text)
                                //.keyboardType(.decimalPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                    // ✅ Date Picker as Popover
                                    if showDatePicker {
                                        DatePicker("", selection: Binding(
                                            get: { selectedDate ?? Date() }, // ✅ If no date selected, use today
                                            set: { newValue in
                                                selectedDate = newValue
                                                dateText = formatDate(newValue) // ✅ Only update after selection
                                                //showDatePicker = false // Auto-close picker
                                                DispatchQueue.main.async {
                                                    showDatePicker = false // Close the date picker after selection
                                                }

                                            }
                                        ), displayedComponents: .date)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                                        .offset(y:-430) // Moves DatePicker ABOVE field

                                    }
                                }
                                .padding()
                            }

                        
                            // Continue Button
                            Button(action: {
                                validateFields()

                                print("Continue tapped")
                            }) {
                                Text("Continue")
                                    .font(.headline)
                                    //.frame(maxWidth: .infinity)
                                    .frame(width:300)
                                    //.padding(.horizontal,30)
                                
                                    .padding()
                                    //.background(Color.black)
                                    .background(Constants.backgroundGradient)
                                    .foregroundColor(.white)
                                    .cornerRadius(150)
                            }
                            .frame(maxWidth: .infinity, alignment: .center) //  Centering the button

                            .padding(.top, 5)
                        }
                .padding(.horizontal, 10)
                    }
                }.sheet(isPresented: $showAccountSheet) {
                    AccountSelectionSheet(accountManager: accountManager, isPresented: $showAccountSheet)
                }
        
            }
    private func validateFields() {
            showTransferFromError = selectedFromAccount == nil
            showTransferToError = selectedToAccount == nil
            showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
            showDateError = dateText == nil
        }

        }

    //}
//}


struct TransferAccountSheet: View {
    @ObservedObject var accountManager: AccountManager
    @Binding var selectedAccount: Account? // ✅ Add this line

    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            // Header
            HStack {
                //Text("Transfer from")
                Text(NSLocalizedString("transfer_from", comment: ""))

                    .font(.headline)
                    .bold()
                Spacer()
                Button(action: {
                    isPresented = false // Close sheet
                }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            // Account List
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(accountManager.accounts) { account in
                        Button(action: {
                            accountManager.selectedAccount = account
                            isPresented = false // Close sheet
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    // Account Name (Bold)
                                    Text(account.accountName)
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    // Account Type (New Line)
                                    Text(account.accountType)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    // Account Number (New Line)
                                    Text(account.accountNumber)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                
                                // Balance
                                Text(account.balance)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.black)
                                
                                if account == accountManager.selectedAccount {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(account == accountManager.selectedAccount ? Color.blue.opacity(0.2) : Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large]) // Allows swipe-up bottom sheet
    }
}

private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }




struct TransferMoneyScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransferMoneyScreen()
    }
}

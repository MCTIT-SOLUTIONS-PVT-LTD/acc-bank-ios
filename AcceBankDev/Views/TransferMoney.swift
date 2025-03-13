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
    @State private var onetime = false // Toggle for email transfers
    
    @State private var showTransferToError = false
       @State private var showAmountError = false
    @State private var showMemoError = false

       @State private var showDateError = false
    @State private var showError: Bool = false

        @State private var recurring = false //
    @State private var showFromAccountSheet = false // Separate modal for "Transfer From"
        @State private var showToAccountSheet = false // Separate modal for "Transfer To"
//        @State private var selectedFromAccount: Account? = nil // Separate state for "Transfer From"
//        @State private var selectedToAccount: Account? = nil
    @State private var selectedFromAccount: BankAccount? // For "Send From"
    @State private var selectedToAccount: BankAccount?   // For "Send To"

    @State private var showTransferFromError = false
    
    
    @State private var showToAccountSheet_to = false //this is state for transfer to
    
    
    @State private var selectedAccount_from: BankAccount?
    @State private var selectedAccount_to: BankAccount?
    @State private var isTransferFromSheetPresented = false
    @State private var isSendToSheetPresented = false
    
    @State private var showInsufficientFundsError = false

   

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
                    HStack(spacing: 0) { // No spacing between buttons
                        ZStack {
                            // Unified background for both buttons
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)]), // Light gray gradient

                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(30) // Rounded corners for the whole background
                            
                            HStack(spacing: 0) {
                                // Current Button (Selected)
                                Button(action: {
                                    selectedPaymentType = "My accounts"
                                }) {
                                    Text("My accounts")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity) // Take equal space
                                        .background(
                                            selectedPaymentType == "My accounts" ?
//                                            LinearGradient(
//
//                                                gradient: Gradient(colors: [Color.blue, Color.purple]),
//                                                startPoint: .leading,
//                                                endPoint: .trailing
//                                            )
                                            Constants.backgroundGradient:

                                            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear]), startPoint: .leading, endPoint: .trailing) // Transparent gradient for unselected

                                                                                    )
                                        .foregroundColor(selectedPaymentType == "My accounts" ? .white : .gray) // Text color
                                        .cornerRadius(30) // Rounded corners for the button
                                }

                                // Saving Button (Unselected)
                                Button(action: {
                                    selectedPaymentType = "Another member"
                                }) {
                                    Text("Another member")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity) // Take equal space
                                        .background(
                                            selectedPaymentType == "Another member" ?
//                                            LinearGradient(
//                                                gradient: Gradient(colors: [Color.blue, Color.purple]),
//                                                startPoint: .leading,
//                                                endPoint: .trailing
//                                            ) :
                                            Constants.backgroundGradient:

                                            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear]), startPoint: .leading, endPoint: .trailing) // Transparent gradient for unselected

                                            )
                                        
                                        .foregroundColor(selectedPaymentType == "Another member" ? .white : .gray) // Text color
                                        .cornerRadius(30) // Rounded corners for the button
                                }
                            }
                            .cornerRadius(30) // Apply rounded corners to the entire HStack
                        }
                    }
                    .padding(.horizontal) // Apply padding to the whole HStack



                              
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
//                                .frame(maxWidth: .infinity, alignment: .leading) // Align text to the

                            Button(action: {
                                print("Button clicked to show 'From Account' sheet.")
                                print("Selected From Account: \(selectedFromAccount?.accountName ?? "None")")
                                


                                //isTransferFromSheetPresented = true
                                isTransferFromSheetPresented.toggle()}) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(selectedAccount_from?.accountName ?? NSLocalizedString("transfer_from", comment: ""))




                                        .font(.headline)
                                            .bold()
                                            .foregroundColor(.black)
                                        

                                        Text(selectedAccount_from?.accountType ?? "")

                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        

                                        Text(selectedAccount_from?.accountNumber ?? "")


                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    

                                    Text(selectedAccount_from?.balance ?? "")

                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .frame(height:70)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                                .sheet(isPresented: $isTransferFromSheetPresented) {
                                    TransferAccountSheet(
                                        accountManager: accountManager,
                                        selectedAccount_from: $selectedAccount_from,
                                        isPresented: $isTransferFromSheetPresented
                                    )
                                }
                            
                            
//                            Text(NSLocalizedString("transfer_to", comment: ""))
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left

                            Button(action: { //isSendToSheetPresented = true
                                isSendToSheetPresented.toggle()

                            }
                            ) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(selectedAccount_to?.accountName ?? NSLocalizedString("transfer_to", comment: ""))


                                        .font(.headline)
                                            .bold()
                                            .foregroundColor(.black)
                                        

                                        Text(selectedAccount_to?.accountType ?? "")


                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        

                                        Text(selectedAccount_to?.accountNumber ?? "")


                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    

                                    Text(selectedAccount_to?.balance ?? "")


                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .frame(height:70)

                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                            .sheet(isPresented: $isSendToSheetPresented) {
                                            SendToSheet(
                                                accountManager_to: accountManager,
                                                selectedAccount_to: $selectedAccount_to,
                                                isPresented_to: $isSendToSheetPresented
                                            )
                                        }
//                            if showTransferToError {
//                                                Text("This field is required")
//                                                    .foregroundColor(.red)
//                                                    .font(.caption)
//                                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                                    .padding(.top, 2)
//                                            }
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
                            TextField("memo", text: $text)
                                //.keyboardType(.decimalPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            if showMemoError {
                                               Text("This field is required")
                                                   .foregroundColor(.red)
                                                   .font(.caption)
                                                   .frame(maxWidth: .infinity, alignment: .leading)
                                                   .padding(.top, 2)
                                           }
                                }
                                .padding()
                            }

                        
                            // Continue Button
                            Button(action: {
                                validateFields()
                                //validateAmount()

                                print("Continue tapped")
                            }) {
                                Text("Continue")
                                    .font(.headline)
                                    //.frame(maxWidth: .infinity)
                                    .frame(width:330)
                                    //.padding(.horizontal,30)
                                
                                    .padding()
                                    //.background(Color.black)
                                    .background(Constants.backgroundGradient)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
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
        showMemoError=text.trimmingCharacters(in: .whitespaces).isEmpty
        }

        }

// Function to validate amount against available balance




struct TransferAccountSheet: View {
    @ObservedObject var accountManager: AccountManager
    @Binding var selectedAccount_from: BankAccount? // ✅ Unique variable for "Transfer From"
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            headerView
            accountListView
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large]) // Allows swipe-up bottom sheet
    }

    /// ✅ Extracted Header
    private var headerView: some View {
        HStack {
            Text(NSLocalizedString("transfer_from", comment: ""))
                .font(.headline)
                .bold()
            Spacer()
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    /// ✅ Extracted Account List
    private var accountListView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(accountManager.accounts) { account in
                    accountButton(for: account)
                }
            }
            .padding()
        }
    }

    /// ✅ Extracted Button Component
    private func accountButton(for account: BankAccount) -> some View {
        Button(action: {
            selectedAccount_from = account
            isPresented = false
            print("Selected Account From: \(account.accountName)")
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(account.accountName)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    Text(account.accountType)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(account.accountNumber)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(account.balance)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
                if let selected = selectedAccount_from, selected.id == account.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }

            }
            .padding()
            .background {
                if let selected = selectedAccount_from, selected.id == account.id {
                    Color.blue.opacity(0.2)
                } else {
                    Color(.systemGray6)
                }
            }


            .cornerRadius(10)
        }
    }
}


struct SendToSheet: View {
    @ObservedObject var accountManager_to: AccountManager
    @Binding var selectedAccount_to: BankAccount? //  Unique variable for "Send To"
    @Binding var isPresented_to: Bool

    var body: some View {
        VStack {
            headerView
            accountListView
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large]) // Allows swipe-up bottom sheet
    }

    /// ✅ Extracted Header
    private var headerView: some View {
        HStack {
            Text(NSLocalizedString("transfer_to", comment: ""))
                .font(.headline)
                .bold()
            Spacer()
            Button(action: { isPresented_to = false }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    /// ✅ Extracted Account List
    private var accountListView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(accountManager_to.accounts) { account in
                    accountButton(for: account)
                }
            }
            .padding()
        }
    }

    /// ✅ Extracted Button Component
    private func accountButton(for account: BankAccount) -> some View {
        Button(action: {
            selectedAccount_to = account
            isPresented_to = false
            print("Selected Account To: \(account.accountName)")
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(account.accountName)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    Text(account.accountType)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(account.accountNumber)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(account.balance)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
                if let selected = selectedAccount_to, selected.id == account.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }

            }
            .padding()
            .background {
                if let selected = selectedAccount_to, selected.id == account.id {
                    Color.blue.opacity(0.2)
                } else {
                    Color(.systemGray6)
                }
            }


            .cornerRadius(10)
        }
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

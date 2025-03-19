import SwiftUI

struct TransferMoneyScreen: View {
    @State private var selectedDate = Date() // Date for the DatePicker
        @State private var showDatePicker = false // Toggle for DatePicker visibility

    @Environment(\.presentationMode) var presentationMode // To dismiss the modal
    @StateObject private var accountManager = AccountManager()

    //@State private var selectedPaymentType: String? = nil // Track selected payment type
    @State private var selectedPaymentType: String? = "My accounts" // Set "My accounts" as default

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
    @State private var showConfirmationSheet = false // Controls Confirmation Screen

    
    @State private var showToAccountSheet_to = false //this is state for transfer to
    
    
    @State private var selectedAccount_from: BankAccount?
    @State private var selectedAccount_to: BankAccount?
    @State private var isTransferFromSheetPresented = false
    @State private var isSendToSheetPresented = false
    
    @State private var showInsufficientFundsError = false
  
    @State private var selectedDateText: String? = nil // Display text for Select Date


    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var startDateText: String? = nil
    @State private var endDateText: String? = nil
    @State private var isSelectingStartDate = true // Track which field is being edited
 
        @State private var isSelectingEndDate = false // Track if end date is being edited

    @StateObject private var contactManager = ContactManager()

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
                if showInsufficientFundsError {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                        
                        VStack(alignment: .leading) {
                            Text("Payment failed")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("This transfer amount exceeds your transaction limit. Please try again.")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 5)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .transition(.opacity)
                    .animation(.easeInOut) // Smooth UI update when error appears/disappears
                }
                
                
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
                    
                    
  
                    
                    // Show the form when One-time Payment is selected
                    if selectedPaymentType == "My accounts" {
                        VStack(spacing: 15) {
                           
                            
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
                                    // .frame(height:70)
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
                            if showTransferToError {
                                Text("This field is required")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 2)
                            }
                            VStack(spacing: 10) {
                                HStack(spacing: 20) { // Adds spacing between the two toggle boxes
                                    // One-Time Toggle Box
                                    VStack {
                                        Toggle(NSLocalizedString("onetime_payment", comment: ""), isOn: Binding(
                                            get: { onetime },
                                            set: { newValue in
                                                onetime = newValue
                                                if newValue { recurring = false } // Deselect recurring when selecting one-time
                                            }
                                        ))
                                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                                        .scaleEffect(0.8) // Reduces the size of the toggle
                                        .lineLimit(1)
                                        .padding(.horizontal, 10) // Adjusts padding inside the box
                                    }
                                    .frame(width: 160, height: 60) // Ensures equal-sized boxes
                                    .background(Color(.systemGray6)) //  Adds gray background
                                    .cornerRadius(10) // Rounds corners
                                    
                                    // Recurring Toggle Box
                                    VStack {
                                        Toggle(NSLocalizedString("recurring_payment", comment: ""), isOn: Binding(
                                            get: { recurring },
                                            set: { newValue in
                                                recurring = newValue
                                                if newValue { onetime = false } // Deselect one-time when selecting recurring
                                            }
                                        ))
                                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                                        .scaleEffect(0.8) // Reduces the size of the toggle
                                        .lineLimit(1)
                                        .padding(.horizontal, 10) // Adjusts padding inside the box
                                    }
                                    .frame(width: 160, height: 60) // Ensures equal-sized boxes
                                    .background(Color(.systemGray6)) // Adds gray background
                                    .cornerRadius(10) // Rounds corners
                                }
                                .padding(.horizontal, 10) // Adjusts outer spacing
                                
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
                                        .pickerStyle(SegmentedPickerStyle()) // Clean segmented style
                                        .padding()
                                    }
                                    .transition(.opacity) // Smooth fade-in effect
                                }
                                
                            }
                            .animation(.easeInOut) //
                            
                            // "Amount" Text Field
                            TextField("enter_transfer_amount", text: $amount)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .onChange(of: amount) { newValue in
                                    amount = formatCurrencyInput(newValue)
                                }
                            
                            if showAmountError {
                                Text("This field is required")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 2)
                            }
                            
                            
                            // Recurring Payment: Show "Start Date" and "End Date"
                            // **One-Time Payment: Show "Select Date" Field**
                            if !recurring {
                                TextField("Select Date", text: Binding(
                                    get: { dateText ?? "" },
                                    set: { _ in }
                                ))
                                .disabled(true)
                                .padding()
                                .frame(height: 50)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            isSelectingStartDate = false
                                            isSelectingEndDate = false
                                            showDatePicker.toggle()
                                        }) {
                                            Image(systemName: "calendar")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 10)
                                        }
                                    }
                                )
                                .onTapGesture {
                                    isSelectingStartDate = false
                                    isSelectingEndDate = false
                                    showDatePicker.toggle()
                                }
                            }
                            
                            // **Recurring Payment: Show "Start Date" and "End Date"**
                            if recurring {
                                VStack {
                                    // Start Date Picker Field
                                    TextField("Start Date", text: Binding(
                                        get: { startDateText ?? "" },
                                        set: { _ in }
                                    ))
                                    .disabled(true)
                                    .padding()
                                    .frame(height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                    .overlay(
                                        HStack {
                                            Spacer()
                                            Button(action: {
                                                isSelectingStartDate = true
                                                isSelectingEndDate = false
                                                showDatePicker.toggle()
                                            }) {
                                                Image(systemName: "calendar")
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    )
                                    .onTapGesture {
                                        isSelectingStartDate = true
                                        isSelectingEndDate = false
                                        showDatePicker.toggle()
                                    }
                                    
                                    // End Date Picker Field
                                    TextField("End Date", text: Binding(
                                        get: { endDateText ?? "" },
                                        set: { _ in }
                                    ))
                                    .disabled(true)
                                    .padding()
                                    .frame(height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                    .overlay(
                                        HStack {
                                            Spacer()
                                            Button(action: {
                                                isSelectingStartDate = false
                                                isSelectingEndDate = true
                                                showDatePicker.toggle()
                                            }) {
                                                Image(systemName: "calendar")
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    )
                                    .onTapGesture {
                                        isSelectingStartDate = false
                                        isSelectingEndDate = true
                                        showDatePicker.toggle()
                                    }
                                }
                            }
                            
                            // **Date Picker Modal (Handles both Start and End Date)**
                            if showDatePicker {
                                VStack {
                                    DatePicker("Select Date", selection: Binding(
                                        get: {
                                            if !recurring { return date }
                                            return isSelectingStartDate ? startDate : endDate
                                        },
                                        set: { newValue in
                                            if !recurring {
                                                date = newValue
                                                dateText = formatDate(newValue)
                                            } else {
                                                if isSelectingStartDate {
                                                    startDate = newValue
                                                    startDateText = formatDate(newValue)
                                                } else {
                                                    endDate = newValue
                                                    endDateText = formatDate(newValue)
                                                }
                                            }
                                            showDatePicker = false
                                        }
                                    ), displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .labelsHidden()
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                                }
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
                    
                    //
                    if selectedPaymentType == "Another member"{
                    VStack(spacing: 15) {
                       
                        
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
                                // .frame(height:70)
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
                            //isSendToSheetPresented.toggle()
                            showContactSheet=true
                            
                        }
                        ) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(selectedAccount_to?.accountName ?? NSLocalizedString("send_to", comment: ""))
                                    
                                    
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
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
//                        .sheet(isPresented: $isSendToSheetPresented) {
//                            SendToSheet(
//                                accountManager_to: accountManager,
//                                selectedAccount_to: $selectedAccount_to,
//                                isPresented_to: $isSendToSheetPresented
//                            )
//                        }
                        .sheet(isPresented: $showContactSheet) {
                            ContactSelectionSheet(contactManager: contactManager, selectedContact: $selectedContact, isPresented: $showContactSheet)
                        }
                        if showTransferToError {
                            Text("This field is required")
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 2)
                        }
                        VStack(spacing: 10) {
                            HStack(spacing: 20) { // Adds spacing between the two toggle boxes
                                // One-Time Toggle Box
                                VStack {
                                    Toggle(NSLocalizedString("onetime_payment", comment: ""), isOn: Binding(
                                        get: { onetime },
                                        set: { newValue in
                                            onetime = newValue
                                            if newValue { recurring = false } // Deselect recurring when selecting one-time
                                        }
                                    ))
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                                    .scaleEffect(0.8) // Reduces the size of the toggle
                                    .lineLimit(1)
                                    .padding(.horizontal, 10) // Adjusts padding inside the box
                                }
                                .frame(width: 160, height: 60) // Ensures equal-sized boxes
                                .background(Color(.systemGray6)) //  Adds gray background
                                .cornerRadius(10) // Rounds corners
                                
                                // Recurring Toggle Box
                                VStack {
                                    Toggle(NSLocalizedString("recurring_payment", comment: ""), isOn: Binding(
                                        get: { recurring },
                                        set: { newValue in
                                            recurring = newValue
                                            if newValue { onetime = false } // Deselect one-time when selecting recurring
                                        }
                                    ))
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                                    .scaleEffect(0.8) // Reduces the size of the toggle
                                    .lineLimit(1)
                                    .padding(.horizontal, 10) // Adjusts padding inside the box
                                }
                                .frame(width: 160, height: 60) // Ensures equal-sized boxes
                                .background(Color(.systemGray6)) // Adds gray background
                                .cornerRadius(10) // Rounds corners
                            }
                            .padding(.horizontal, 10) // Adjusts outer spacing
                            
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
                                    .pickerStyle(SegmentedPickerStyle()) // Clean segmented style
                                    .padding()
                                }
                                .transition(.opacity) // Smooth fade-in effect
                            }
                            
                        }
                        .animation(.easeInOut) //
                        
                        // "Amount" Text Field
                        TextField("enter_transfer_amount", text: $amount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .onChange(of: amount) { newValue in
                                amount = formatCurrencyInput(newValue)
                            }
                        
                        if showAmountError {
                            Text("This field is required")
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 2)
                        }
                        
                        
                        // Recurring Payment: Show "Start Date" and "End Date"
                        // **One-Time Payment: Show "Select Date" Field**
                        if !recurring {
                            TextField("Select Date", text: Binding(
                                get: { dateText ?? "" },
                                set: { _ in }
                            ))
                            .disabled(true)
                            .padding()
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .overlay(
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isSelectingStartDate = false
                                        isSelectingEndDate = false
                                        showDatePicker.toggle()
                                    }) {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 10)
                                    }
                                }
                            )
                            .onTapGesture {
                                isSelectingStartDate = false
                                isSelectingEndDate = false
                                showDatePicker.toggle()
                            }
                        }
                        
                        // **Recurring Payment: Show "Start Date" and "End Date"**
                        if recurring {
                            VStack {
                                // Start Date Picker Field
                                TextField("Start Date", text: Binding(
                                    get: { startDateText ?? "" },
                                    set: { _ in }
                                ))
                                .disabled(true)
                                .padding()
                                .frame(height: 50)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            isSelectingStartDate = true
                                            isSelectingEndDate = false
                                            showDatePicker.toggle()
                                        }) {
                                            Image(systemName: "calendar")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 10)
                                        }
                                    }
                                )
                                .onTapGesture {
                                    isSelectingStartDate = true
                                    isSelectingEndDate = false
                                    showDatePicker.toggle()
                                }
                                
                                // End Date Picker Field
                                TextField("End Date", text: Binding(
                                    get: { endDateText ?? "" },
                                    set: { _ in }
                                ))
                                .disabled(true)
                                .padding()
                                .frame(height: 50)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            isSelectingStartDate = false
                                            isSelectingEndDate = true
                                            showDatePicker.toggle()
                                        }) {
                                            Image(systemName: "calendar")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 10)
                                        }
                                    }
                                )
                                .onTapGesture {
                                    isSelectingStartDate = false
                                    isSelectingEndDate = true
                                    showDatePicker.toggle()
                                }
                            }
                        }
                        
                        // **Date Picker Modal (Handles both Start and End Date)**
                        if showDatePicker {
                            VStack {
                                DatePicker("Select Date", selection: Binding(
                                    get: {
                                        if !recurring { return date }
                                        return isSelectingStartDate ? startDate : endDate
                                    },
                                    set: { newValue in
                                        if !recurring {
                                            date = newValue
                                            dateText = formatDate(newValue)
                                        } else {
                                            if isSelectingStartDate {
                                                startDate = newValue
                                                startDateText = formatDate(newValue)
                                            } else {
                                                endDate = newValue
                                                endDateText = formatDate(newValue)
                                            }
                                        }
                                        showDatePicker = false
                                    }
                                ), displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .labelsHidden()
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
                            }
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
                        if !showInsufficientFundsError {
                            print("Valid amount entered. Showing confirmation screen.")
                            
                        }
                        
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

                    .sheet(isPresented: $showConfirmationSheet) {
                        ConfirmationSheet(
                            fromAccount: selectedAccount_from,
                            toAccount: selectedAccount_to,
                            amount: amount,
                            dateText: dateText ?? "N/A",
                            memo: text,
                            isRecurring: recurring,
                            selectedFrequency: recurring ? selectedFrequency : nil,
                            startDateText: recurring ? startDateText : nil,
                            endDateText: recurring ? endDateText : nil
                        )
                    }

                    
                }
                .padding(.horizontal, 10)
            }
        }
    }


    private func validateFields() {
        // Ensure amount and balance are correctly parsed as numbers
        let enteredAmount = Double(amount.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)) ?? 0.0
        let availableBalance = Double(selectedAccount_from?.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces) ?? "0") ?? 0.0

        print("Entered Amount: \(enteredAmount)")
        print("Available Balance: \(availableBalance)")

        // Validate required fields
        showTransferFromError = selectedFromAccount == nil
        showTransferToError = selectedToAccount == nil
        showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
        showDateError = dateText == nil
        showMemoError = text.trimmingCharacters(in: .whitespaces).isEmpty

        // Fix: Properly compare numeric values
        if enteredAmount > availableBalance {
            showInsufficientFundsError = true  // Show error message
            showConfirmationSheet = false      // Do not show confirmation
        } else {
            showInsufficientFundsError = false // Hide error message
            showConfirmationSheet = true       // Show confirmation sheet
        }

        DispatchQueue.main.async {
            self.showInsufficientFundsError = enteredAmount > availableBalance
        }
    }


    func formatCurrencyInput(_ input: String) -> String {
        // Remove non-numeric characters except `.`
        let filtered = input.filter { "0123456789.".contains($0) }
        
        // Ensure there is at most one `.`
        let components = filtered.split(separator: ".")
        if components.count > 2 {
            return "$" + String(components[0]) + "." + String(components[1].prefix(2)) // Keep two decimal places
        }
        
        return "$" + filtered
    }

        }

// Function to validate amount against available balance


//struct ConfirmationSheet: View {
//    var fromAccount: BankAccount?
//    var toAccount: BankAccount?
//    var amount: String
//    var dateText: String
//    var memo: String
//
//    @Environment(\.presentationMode) var presentationMode // To close the sheet
//
//    var body: some View {
//        VStack(spacing: 15) {
//            // Close button
//            HStack {
//                Text("Confirmation")
//                    .font(.title3)
//                    .bold()
//                Spacer()
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Image(systemName: "xmark")
//                        .font(.title2)
//                        .foregroundColor(.black)
//                }
//            }
//            .padding()
//
////            Text("Once you click Confirm, we'll transfer the funds from your account. The service charge (if applicable) is non-refundable.")
////                .font(.subheadline)
////                .foregroundColor(.gray)
////                .padding(.horizontal)
//
//            //Divider()
//
//            // Using PaymentDetailRow for a cleaner UI
//            VStack(alignment: .leading, spacing: 10) {
//                PaymentDetailRow(
//                    title: "Transfer from",
//                    value: "\(fromAccount?.accountName ?? "No Account") - \(fromAccount?.accountNumber ?? "")",
//                    bold: true
//                )
//
//                PaymentDetailRow(
//                    title: "Transfer to",
//                    value: "\(toAccount?.accountName ?? "No Account") - \(toAccount?.accountNumber ?? "")",
//                    //value: toAccount?.accountName ?? "No Recipient",
//                    bold: true
//                )
//
//                PaymentDetailRow(
//                    title: "Amount",
//                    value: "$\(amount)",
//                    bold: true
//                )
//
//                PaymentDetailRow(
//                    title: "Date",
//                    value: dateText,
//                    bold: false
//                )
//
//                PaymentDetailRow(
//                    title: "Memo",
//                    value: memo.isEmpty ? "N/A" : memo,
//                    bold: false
//                )
//            }
//            .padding(.horizontal)
//
//            Spacer()
//
//            // Confirm Button
//            Button(action: {
//                print("Transaction confirmed")
//                presentationMode.wrappedValue.dismiss() // Dismiss the sheet
//            }) {
//                Text("Confirm")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.black)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal)
//            .padding(.bottom, 20)
//        }
//        .padding(.vertical)
//    }
//}

struct ConfirmationSheet: View {
    var fromAccount: BankAccount?
    var toAccount: BankAccount?
    var amount: String
    var dateText: String
    var memo: String
    var isRecurring: Bool
    var selectedFrequency: String?
    var startDateText: String?
    var endDateText: String?

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 15) {
            // Close button
            HStack {
                Text("Confirmation")
                    .font(.title3)
                    .bold()
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding()

            VStack(alignment: .leading, spacing: 10) {
                PaymentDetailRow(
                    title: "Transfer from",
                    value: "\(fromAccount?.accountName ?? "No Account") - \(fromAccount?.accountNumber ?? "")",
                    bold: true
                )

                PaymentDetailRow(
                    title: "Transfer to",
                    value: "\(toAccount?.accountName ?? "No Account") - \(toAccount?.accountNumber ?? "")",
                    bold: true
                )

                PaymentDetailRow(
                    title: "Amount",
                    value: "$\(amount)",
                    bold: true
                )

                if isRecurring {
                    PaymentDetailRow(
                        title: "Payment Type",
                        value: "Recurring",
                        bold: true
                    )

                    PaymentDetailRow(
                        title: "Frequency",
                        value: selectedFrequency ?? "N/A",
                        bold: false
                    )

                    PaymentDetailRow(
                        title: "Start Date",
                        value: startDateText ?? "N/A",
                        bold: false
                    )

                    PaymentDetailRow(
                        title: "End Date",
                        value: endDateText ?? "N/A",
                        bold: false
                    )
                } else {
                    PaymentDetailRow(
                        title: "Payment Type",
                        value: "One-Time",
                        bold: true
                    )

                    PaymentDetailRow(
                        title: "Date",
                        value: dateText,
                        bold: false
                    )
                }

                PaymentDetailRow(
                    title: "Memo",
                    value: memo.isEmpty ? "N/A" : memo,
                    bold: false
                )
            }
            .padding(.horizontal)

            Spacer()

            // Confirm Button
            Button(action: {
                print("Transaction confirmed")
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Confirm")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding(.vertical)
    }
}


struct PaymentDetailRow: View {
    var title: String
    var value: String
    var bold: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)

            Text(value)
                .font(.body)
                .fontWeight(bold ? .bold : .regular)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5) // Adds spacing above the line

            Divider() // This adds the bottom border effect
        }
    }
}
struct ContactSelectionSheet: View {
    @ObservedObject var contactManager: ContactManager
    @Binding var selectedContact: Contact?
    @Binding var isPresented: Bool
    @State private var searchText: String = "" // Search text state
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contactManager.contacts
        } else {
            return contactManager.contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                //Text("Select Contact")
                Text(NSLocalizedString("select_account", comment: ""))

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
            
            // Search Bar
            //TextField("Search", text: $searchText)
            TextField(NSLocalizedString("search", comment: ""), text: $searchText)
                .padding(10)
                .background(Color(.white))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // Border shape
                        .stroke(Color.black, lineWidth: 1) // Border color & width
                )
                .padding(.horizontal)
            
            
            
            // Contact List (Filtered)
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(filteredContacts) { contact in
                        Button(action: {
                            selectedContact = contact
                            isPresented = false
                        }) {
                            HStack {
                                //  Show only name
                                Text(contact.name)
                                    .font(.headline)
                                    .bold()
                                    .bold()
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                // Show checkmark if selected
                                if selectedContact?.id == contact.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(selectedContact?.id == contact.id ? Color.blue.opacity(0.2) : Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            //.frame(maxHeight: .infinity) // Ensures ScrollView expands fully
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large])
    }
}






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

    /// Extracted Account List
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

    /// Extracted Button Component
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
    @Binding var selectedAccount_to: BankAccount? // ✅ Unique variable for "Send To"
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

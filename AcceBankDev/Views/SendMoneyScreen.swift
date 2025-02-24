import SwiftUI
import Foundation
struct SendMoneyView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the modal
    @StateObject private var accountManager = AccountManager()
    @StateObject private var contactManager = ContactManager()
    
    @State private var showAccountSheet = false // Toggle for full-screen modal
    @State private var showAddContactSheet = false // New state to show Add Contact form
    @State private var selectedContact: Contact?
    @State private var showContactSheet = false // Show Contact Selection Sheet
    
    @State private var transferAmount: String = "" // Transfer Amount
    @State private var message: String = ""
    @State private var isAcknowledged = false // Checkbox state
    @State private var showError = false // Error state
    @State private var showPaymentError = false // Payment Error State
    @State private var showPaymentSummarySheet = false // Show Payment Summary
    @State private var showPaymentSuccess = false // Show Payment Success Screen
    
    
    
    var body: some View {
        
        VStack {
            // ✅ Top Bar with Back Button
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Send Money")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding()
            
            // ✅ Payment Error Banner
            if showPaymentError {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.white)
                    VStack(alignment: .leading) {
                        Text("Payment failed")
                            .font(.headline)
                            .bold()
                        Text("This payment amount exceeds your transaction limit. Please try again.")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.red.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 15) {
                // ✅ Transfer From
                Text("Transfer from")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: { showAccountSheet = true }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(accountManager.selectedAccount?.accountName ?? "Select Account")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.black)
                            Text(accountManager.selectedAccount?.accountType ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(accountManager.selectedAccount?.accountNumber ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(accountManager.selectedAccount?.balance ?? "")
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
                
                // ✅ Send To (Dropdown with Contact List)
                Text("Send to")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: { showContactSheet = true }) { // ✅ Show Contact Picker
                    HStack {
                        Text(selectedContact?.name ?? "Select Contact")
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // ✅ Add Contact Button (Opens Form)
                Button(action: { showAddContactSheet = true }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple)
                            .clipShape(Circle())
                        Text("Add contact")
                            .foregroundColor(.purple)
                    }
                }
                .padding(.vertical)
                
                // ✅ Show only Security Question if a contact is selected
                if let contact = selectedContact, !contact.securityQuestion.isEmpty {
                    Text("Security Question")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("", text: .constant(contact.securityQuestion))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(true) // ✅ Make it non-editable
                        .foregroundColor(.gray) // ✅ Display as read-only
                        .padding(.bottom, 10)
                }
                
                // ✅ Transfer Amount & Message Fields
                TextField("Enter transfer amount", text: $transferAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 5)
                
                
                
                TextField("Message (optional)", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // ✅ Auto-Deposit Acknowledgment Checkbox
                HStack(alignment: .top) {
                    Button(action: {
                        isAcknowledged.toggle() // ✅ Toggle checkbox state
                    }) {
                        Image(systemName: isAcknowledged ? "checkmark.square.fill" : "square")
                            .foregroundColor(.purple)
                    }
                    Text("I acknowledge that this recipient has auto-deposit enabled. They won't need to answer a security question, and the funds will be deposited automatically.")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.leading, 5)
                }
                .padding()
                .background(Color.purple.opacity(0.2))
                .cornerRadius(8)
                
                // ✅ Error Message
                if showError {
                    Text("⚠️ Please select a contact, enter an amount, and acknowledge the terms.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }
                
                // ✅ Continue Button with Validation
                Button(action: {
                    //validateAndContinue()
                    validateAndShowSummary()
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
        //show account list
        .sheet(isPresented: $showAccountSheet) {
            AccountSelectionSheet(accountManager: accountManager, isPresented: $showAccountSheet)
        }
        //show contact creation
        .sheet(isPresented: $showAddContactSheet) {
            AddContactFormView(isPresented: $showAddContactSheet, contactManager: contactManager)
        }
        //show contact list
        .sheet(isPresented: $showContactSheet) {
            ContactSelectionSheet(contactManager: contactManager, selectedContact: $selectedContact, isPresented: $showContactSheet)
        }
        .sheet(isPresented: $showPaymentSummarySheet) {
            PaymentSummaryView(
                isPresented: $showPaymentSummarySheet,
                account: accountManager.selectedAccount,
                contact: selectedContact,
                amount: transferAmount,
                message: message
            )
        }
        
    }
    
    //function valiadate amount with balance and give summary
    private func validateAndShowSummary() {
        guard let balanceString = accountManager.selectedAccount?.balance
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: ",", with: ""),
              let accountBalance = Double(balanceString),
              let enteredAmount = Double(transferAmount) else {
            showError = true
            return
        }
        
        if selectedContact == nil || transferAmount.isEmpty || !isAcknowledged {
            showError = true
        } else if enteredAmount > accountBalance {
            showPaymentError = true
        } else {
            showPaymentError = false
            showPaymentSummarySheet = true // ✅ Open Payment Summary Sheet
        }
    }
    
    
    //            private func validateAndContinue() {
    //                // ✅ Ensure that selectedAccount and balance are safely unwrapped
    //                guard let balanceString = accountManager.selectedAccount?.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ""),
    //                      let accountBalance = Double(balanceString) else {
    //                    return
    //                }
    //
    //
    //                guard let enteredAmount = Double(transferAmount) else {
    //                    showError = true
    //                    return
    //                }
    //
    //                if selectedContact == nil || transferAmount.isEmpty || !isAcknowledged {
    //                    showError = true
    //                    showPaymentError = false
    //                } else if enteredAmount > accountBalance {
    //                    showPaymentError = true // ✅ Show "Payment Failed" banner
    //                    showError = false
    //                } else {
    //                    showError = false
    //                    showPaymentError = false
    //                    print("Continue tapped with \(selectedContact?.name ?? "No Contact Selected"), Amount: \(transferAmount)")
    //                }
    //            }
    //        }
    
    
    //########################################################
    
    //this shows final screen of payment
    struct PaymentSuccessView: View {
        var body: some View {
            VStack {
                Spacer()
                
                // ✅ Payment Confirmation Bubble
                Text("Payment sent. Your money is on its way")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                //.clipShape(BubbleShape()) // ✅ Custom Bubble Shape
                
                // ✅ Confirmation Number
                Text("Confirmation number: CAqVsmac")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                // ✅ Share Details Button
                Button(action: {
                    print("Share details tapped")
                }) {
                    Text("Share details")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .background(Color.purple.edgesIgnoringSafeArea(.all))
        }
    }
    
    // ✅ Custom Bubble Shape for Payment Confirmation
    struct BubbleShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let bubbleTailSize: CGFloat = 20
            
            path.move(to: CGPoint(x: rect.minX + 10, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + 10), control: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 10))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - 10, y: rect.maxY), control: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + bubbleTailSize, y: rect.maxY))
            
            // Bubble Tail
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY + bubbleTailSize), control: CGPoint(x: rect.minX + 10, y: rect.maxY + bubbleTailSize))
            path.addQuadCurve(to: CGPoint(x: rect.minX + bubbleTailSize * 2, y: rect.maxY), control: CGPoint(x: rect.minX + 10, y: rect.maxY + bubbleTailSize))
            
            path.addLine(to: CGPoint(x: rect.minX + 10, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - 10), control: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 10))
            path.addQuadCurve(to: CGPoint(x: rect.minX + 10, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
            
            return path
        }
    }
    
    //this give summary of payments after click continue
    struct PaymentSummaryView: View {
        @Binding var isPresented: Bool
        var account: BankAccount?
        var contact: Contact?
        var amount: String
        var message: String
        @State private var showPaymentSuccess = false // Show Payment Success Screen
        
        var body: some View {
            VStack {
                // Header
                HStack {
                    Text("Confirmation")
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
                
                Text("Once you click Send Now, we’ll transfer the funds from your account. You may cancel the transfer while it is still pending. The service charge (if applicable) is non-refundable.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    PaymentDetailRow(title: "Transfer from", value: "\(account?.accountName ?? "") - \(account?.accountNumber ?? "")")
                    PaymentDetailRow(title: "Transfer to", value: contact?.name ?? "")
                    PaymentDetailRow(title: "Send transfer to", value: contact?.email ?? "")
                    PaymentDetailRow(title: "Amount", value: "$\(amount)", bold: true)
                    PaymentDetailRow(title: "Service fee", value: "$0.00")
                    PaymentDetailRow(title: "Total amount", value: "$\(amount)")
                    PaymentDetailRow(title: "Message", value: message)
                    PaymentDetailRow(title: "Security question", value: contact?.securityQuestion ?? "", bold: true)
                }
                .padding(.horizontal)
                
                // ✅ Confirm Button
                Button(action: {
                    showPaymentSuccess = true // ✅ Navigate to Payment Success Screen
                }) {
                    Text("Confirm")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $showPaymentSuccess) { // ✅ Open Payment Success Screen
                PaymentSuccessView()
            }
        }
    }
    
    // Renamed DetailRow to PaymentDetailRow show all details in confirmation
    struct PaymentDetailRow: View {
        var title: String
        var value: String
        var bold: Bool = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text(value)
                    .font(bold ? .subheadline.bold() : .subheadline)
                    .foregroundColor(.black)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
            }
        }
    }
    
    
    // Bottom Sheet for Selecting Account
    struct AccountSelectionSheet: View {
        @ObservedObject var accountManager: AccountManager
        @Binding var isPresented: Bool
        
        var body: some View {
            VStack {
                // ✅ Header
                HStack {
                    Text("Transfer from")
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
                
                // ✅ Account List
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(accountManager.accounts) { account in
                            Button(action: {
                                accountManager.selectedAccount = account
                                isPresented = false // Close sheet
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        // ✅ Account Name (Bold)
                                        Text(account.accountName)
                                            .font(.headline)
                                            .bold()
                                            .foregroundColor(.black)
                                        
                                        // ✅ Account Type (New Line)
                                        Text(account.accountType)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        // ✅ Account Number (New Line)
                                        Text(account.accountNumber)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    
                                    // ✅ Balance
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
    
    //for showing account form
    
    
    struct AddContactFormView: View {
        @Binding var isPresented: Bool
        @ObservedObject var contactManager: ContactManager // ✅ Contact Manager
        
        @State private var name = ""
        @State private var email = ""
        @State private var mobilePhone = ""
        @State private var sendByEmail = false
        @State private var sendByMobile = false
        @State private var securityQuestion = ""
        @State private var securityAnswer = ""
        @State private var reEnterSecurityAnswer = ""
        
        @State private var showConfirmationSheet = false // ✅ Show confirmation preview
        
        var body: some View {
            VStack {
                // ✅ Top Header
                HStack {
                    Text("Add contact")
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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        // ✅ Name Field
                        TextField("Name", text: $name)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.red, lineWidth: name.isEmpty ? 1 : 0))
                        Text("Required field.")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .opacity(name.isEmpty ? 1 : 0)
                        
                        // ✅ Email Field
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.red, lineWidth: email.isEmpty ? 1 : 0))
                        Text("Required field.")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .opacity(email.isEmpty ? 1 : 0)
                        
                        // ✅ Mobile Field
                        TextField("Mobile phone", text: $mobilePhone)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.red, lineWidth: mobilePhone.isEmpty ? 1 : 0))
                        Text("Required field.")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .opacity(mobilePhone.isEmpty ? 1 : 0)
                        
                        // ✅ Send Transfers By
                        Toggle("Send transfers by Email", isOn: $sendByEmail)
                        Toggle("Send transfers by Mobile phone", isOn: $sendByMobile)
                        
                        // ✅ Security Details
                        TextField("Security question", text: $securityQuestion)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Security answer", text: $securityAnswer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        // ✅ Add Contact Button (Opens Confirmation)
                        Button(action: {
                            showConfirmationSheet = true // ✅ Open preview
                        }) {
                            Text("Review Contact")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showConfirmationSheet) {
                ContactConfirmationView(
                    isPresented: $showConfirmationSheet,
                    contactManager: contactManager,
                    name: name,
                    email: email,
                    mobilePhone: mobilePhone,
                    sendByEmail: sendByEmail,
                    sendByMobile: sendByMobile,
                    securityQuestion: securityQuestion,
                    securityAnswer: securityAnswer
                )
                .presentationDetents([.large]) // ✅ Forces full height
                .presentationDragIndicator(.hidden) // ✅ Hides drag indicator
                
            }
        }
    }
    
    
    // summary form of conatct
    struct ContactConfirmationView: View {
        @Binding var isPresented: Bool
        @ObservedObject var contactManager: ContactManager
        
        var name: String
        var email: String
        var mobilePhone: String
        var sendByEmail: Bool
        var sendByMobile: Bool
        var securityQuestion: String
        var securityAnswer: String
        
        var body: some View {
            VStack {
                // ✅ Header
                HStack {
                    Text("Confirmation")
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
                
                Text("Are you sure you want to add this contact?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                // ✅ Contact Details
                VStack(alignment: .leading, spacing: 10) {
                    DetailRow(title: "Name", value: name)
                    DetailRow(title: "Email", value: email)
                    DetailRow(title: "Mobile phone", value: mobilePhone)
                    DetailRow(title: "Send transfer by", value: sendByEmail ? "Email" : "Mobile phone")
                    DetailRow(title: "Security question", value: securityQuestion, bold: true)
                    DetailRow(title: "Security answer", value: "*******") // Hide security answer
                }
                .padding(.horizontal)
                
                // ✅ Confirm Button
                Button(action: {
                    saveContact()
                    isPresented = false
                }) {
                    Text("Confirm")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        
        // ✅ Save contact to JSON
        private func saveContact() {
            let newContact = Contact(
                name: name,
                email: email,
                mobilePhone: mobilePhone,
                sendByEmail: sendByEmail,
                sendByMobile: sendByMobile,
                securityQuestion: securityQuestion,
                securityAnswer: securityAnswer
            )
            contactManager.addContact(newContact)
        }
    }
    
    // Helper View for Detail Row
    struct DetailRow: View {
        var title: String
        var value: String
        var bold: Bool = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text(value)
                    .font(bold ? .subheadline.bold() : .subheadline)
                    .foregroundColor(.black)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
            }
        }
    }
    
    
    
    //show saved contatcts and search bar
    
    
    
    
    struct ContactSelectionSheet: View {
        @ObservedObject var contactManager: ContactManager
        @Binding var selectedContact: Contact?
        @Binding var isPresented: Bool
        @State private var searchText: String = "" // ✅ Search text state
        
        var filteredContacts: [Contact] {
            if searchText.isEmpty {
                return contactManager.contacts
            } else {
                return contactManager.contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }
        }
        
        var body: some View {
            VStack {
                // ✅ Header
                HStack {
                    Text("Select Contact")
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
                
                // ✅ Search Bar
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color(.white))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // ✅ Border shape
                            .stroke(Color.black, lineWidth: 1) // ✅ Border color & width
                    )
                    .padding(.horizontal)
                
                
                
                // ✅ Contact List (Filtered)
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredContacts) { contact in
                            Button(action: {
                                selectedContact = contact
                                isPresented = false
                            }) {
                                HStack {
                                    // ✅ Show only name
                                    Text(contact.name)
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    // ✅ Show checkmark if selected
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
            }
            .padding(.horizontal)
            .presentationDetents([.medium, .large])
        }
    }
    
    
    
    
    
}
// ✅ Preview
struct SendMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        SendMoneyView()
    }
}

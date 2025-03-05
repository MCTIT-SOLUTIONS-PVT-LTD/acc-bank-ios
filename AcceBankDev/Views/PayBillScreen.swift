////
////  PayBillScreen.swift
////  AcceBankDev
////
////  Created by MCT on 05/03/25.
////
//
//import SwiftUI
//
//struct PayBillScreen: View {
//    @Environment(\.presentationMode) var presentationMode // To dismiss the modal
//    //@State private var selectedPaymentType: String = "One-time Payment" // Track the payment type
//    @State private var selectedPaymentType: String? = nil // Track selected payment type
//    
//    var body: some View {
//        //Text("Hello, World!")
//        ScrollView {
//            
//            VStack {
//                //  Top Bar with Back Button
//                HStack {
//                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
//                        Image(systemName: "arrow.left")
//                            .font(.title2)
//                            .foregroundColor(.black)
//                    }
//                    Spacer()
//                    // Text("Send Money")//
//                    Text(NSLocalizedString("make_payment", comment: ""))
//                    
//                        .font(.title2)
//                        .bold()
//                    Spacer()
//                }
//                .padding()
//                VStack(alignment: .leading, spacing: 15) {
//                    //                    Text(NSLocalizedString("select_payment_type", comment: ""))
//                    //                        .font(.headline)
//                    //                        .padding(.top, 20)
//                    
//                    // Option to choose between one-time and recurring payments
//                    Picker("Payment Type", selection: $selectedPaymentType) {
//                        Text("One-time Payment").tag("One-time Payment")
//                        Text("Recurring Payment").tag("Recurring Payment")
//                    }
//                    .pickerStyle(SegmentedPickerStyle()) // Segmented style for better UI
//                    .padding()
//
//                    
//                }
//                
//            }
//        }
//        
//    }
//}
//    struct PayBillScreen_Previews: PreviewProvider {
//        static var previews: some View {
//            PayBillScreen()
//        }
//    }
//

import SwiftUI

struct PayBillScreen: View {
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
    @State private var date = Date()
    
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
                    Text(NSLocalizedString("make_payment", comment: ""))
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()

                VStack(alignment: .leading, spacing: 15) {
                    // Option to choose between one-time and recurring payments
                    Picker("Payment Type", selection: $selectedPaymentType) {
                        Text("One-time Payment").tag("One-time Payment")
                        Text("Recurring Payment").tag("Recurring Payment")
                    }
                    .pickerStyle(SegmentedPickerStyle()) // Segmented style for better UI
                    .padding()

                    // Show the form when One-time Payment is selected
                    if selectedPaymentType == "One-time Payment" {
                        VStack(spacing: 15) {
                            // "Pay from" Dropdown
                            Text(NSLocalizedString("pay_from", comment: ""))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left

                            Button(action: { showAccountSheet = true }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
        //                                Text(accountManager.selectedAccount?.accountName ?? "Select Account")
                                        Text(accountManager.selectedAccount?.accountName ?? NSLocalizedString("select_account", comment: ""))

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
                            
                            // "Payee" Dropdown
                            //Text("Send to")//
//                            Text(NSLocalizedString("send_to", comment: ""))
//
//                            .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                            Button(action: { showContactSheet = true }) {
                                HStack {
        //                            Text(selectedContact?.name ?? "Select Contact")
                                    Text(selectedContact?.name ?? NSLocalizedString("payee", comment: ""))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                            
                            // Add Contact Button (Opens Form)
                            Button(action: { showAddContactSheet = true }) {
                                HStack {
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.colorBlue)
                                        .clipShape(Circle())
                                    //Text("Add contact")//
                                    Text(NSLocalizedString("add_payee", comment: ""))
                                        .foregroundColor(.colorBlue)
                                        .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                                }
                            }
                            .padding(.vertical)
                            // "Amount" Text Field
                            TextField("enter_transfer_amount", text: $amount)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

//                            // "Date" Date Picker
//                            DatePicker("date", selection: $date, displayedComponents: .date)
//                                .padding()
//                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                            TextField("date", text: $amount)
//                                //.keyboardType(.decimalPad)
//                                .padding()
//                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            HStack {
                                               TextField("Date", text: $amount)
                                                   .padding()
                                                   .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                                   .padding(.leading, 10)

                                               // Calendar Icon Button to trigger DatePicker
                                               Button(action: {
                                                   showDatePicker.toggle()
                                               }) {
                                                   Image(systemName: "calendar")
                                                       .foregroundColor(.gray)
                                                       .padding(.trailing, 10)
                                               }
                                           }

                                           // Display DatePicker when showDatePicker is true
                                           if showDatePicker {
                                               DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                                                   .datePickerStyle(GraphicalDatePickerStyle())
                                                   .padding()
                                                   .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                                   .padding(.top, 10)
                                           }


                            // Continue Button
                            Button(action: {
                                print("Continue tapped")
                            }) {
                                Text("Continue")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.horizontal, 20)
                    }
                }.sheet(isPresented: $showAccountSheet) {
                    AccountSelectionSheet(accountManager: accountManager, isPresented: $showAccountSheet)
                }
            }
        }
    }
}
struct AccountSelectionSheet: View {
    @ObservedObject var accountManager: AccountManager
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
struct PayBillScreen_Previews: PreviewProvider {
    static var previews: some View {
        PayBillScreen()
    }
}

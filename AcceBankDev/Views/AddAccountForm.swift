//
//  AddAccountForm.swift
//  AcceBankDev
//
//  Created by MCT on 07/03/25.
//

import SwiftUI

struct AddAccountFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var accountManager: AccountManager

    @State private var accountName = ""
    @State private var accountType = ""
    @State private var accountNumber = ""
    @State private var balance = ""
    
    @State private var accountNameError = false
    @State private var accountTypeError = false
    @State private var accountNumberError = false
    @State private var balanceError = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Add New Account")
                        .font(.title)
                        .bold()
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        // Account Name
                        TextField("Account Name", text: $accountName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(accountNameError ? Color.red : Color.clear, lineWidth: 1))
                        if accountNameError {
                            Text("Required field.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }

                        // Account Type
                        TextField("Account Type", text: $accountType)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(accountTypeError ? Color.red : Color.clear, lineWidth: 1))
                        if accountTypeError {
                            Text("Required field.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }

                        // Account Number
                        TextField("Account Number", text: $accountNumber)
                            .padding()
                            .keyboardType(.numberPad)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(accountNumberError ? Color.red : Color.clear, lineWidth: 1))
                        if accountNumberError {
                            Text("Required field.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }

                        // Balance
                        TextField("Balance", text: $balance)
                            .padding()
                            .keyboardType(.decimalPad)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(balanceError ? Color.red : Color.clear, lineWidth: 1))
                        if balanceError {
                            Text("Required field.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()

                    Button(action: {
                        if validateFields() {
                            let newAccount = BankAccount(accountName: accountName, accountType: accountType, accountNumber: accountNumber, balance: balance)
                            accountManager.addAccount(account: newAccount)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Save Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // Function to Validate Fields
    private func validateFields() -> Bool {
        accountNameError = accountName.isEmpty
        accountTypeError = accountType.isEmpty
        accountNumberError = accountNumber.isEmpty
        balanceError = balance.isEmpty

        return !(accountNameError || accountTypeError || accountNumberError || balanceError)
    }
}


//#Preview {
//    AddAccountFormView()
//}
struct AddAccountFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountFormView(accountManager: AccountManager())
           // .previewDevice("iPhone 14 Pro") // Adjust the device as needed
            .previewLayout(.sizeThatFits) // This will make the preview fit the content size
            .padding()
    }
}

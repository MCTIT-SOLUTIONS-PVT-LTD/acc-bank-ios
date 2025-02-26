import SwiftUI

struct PhoneNumberView: View {
    @State var username: String
    @State private var mobileNumber: String = ""
    @State private var mobileOtp: String = ""
    @State private var isMobileOTPFieldVisible: Bool = false
    @State private var isMobileNumberFormCompleted: Bool = false
    @State private var errorMessage: String?
    @State private var selectedCountry: String = "+1"

    var body: some View {
        print("Current Username in phone [ViewName]: \(username)")
        return NavigationStack{
            ZStack {
                backgroundGradient
                
                VStack(spacing: 20) {
                    Text("Enter Mobile Number")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Picker("", selection: $selectedCountry) {
                            Text("+1").tag("+1")
                            Text("+91").tag("+91")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 70)
                        .background(Color.clear)
                        .accentColor(.white)
                        TextField("", text: $mobileNumber, prompt: Text("Mobile Number")
                            .foregroundColor(.white.opacity(0.7)))
                                .keyboardType(.numberPad)
                                .padding(.leading, 15) // ✅ Adjusts left padding
                                .foregroundColor(.white)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(height: 50, alignment: .leading) // ✅ Matches height of picker
                                .onChange(of: mobileNumber) { _, newValue in
                                    mobileNumber = formatPhoneNumber(newValue, countryCode: selectedCountry)
                                }
                    }
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1)))
                    //.overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.8), lineWidth: 2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(mobileNumber.isEmpty ? Color.white.opacity(0.7) : Color.white.opacity(1), lineWidth: 2)
                    )

                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 5)
                    }
                    
                    if isMobileOTPFieldVisible {
                        Text("Enter OTP")
                            .font(.headline)
                            .foregroundColor(.white)
                        TextField("Enter OTP", text: $mobileOtp)

                            .foregroundColor(.white)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
                            .frame(width: 200, height: 50)
//                            //.foregroundColor(.white)
//                            .keyboardType(.numberPad)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
//                            .frame(width: 200, height: 50)
                    }
                    
                    Button(action: {
                        if !isMobileOTPFieldVisible {
                            
                            if validatePhoneNumber(mobileNumber, countryCode: selectedCountry) {
                                print("✅ OTP Sent (Static: 1234)")
                                withAnimation {
                                    isMobileOTPFieldVisible = true
                                }
                                errorMessage = nil
                            } else {
                                errorMessage = "❌ Invalid phone number for \(selectedCountry)"
                            }
                        } else {
                            if validateOTP(mobileOtp) {
                                print("✅ OTP Verified")
                                isMobileNumberFormCompleted = true
                            } else {
                                errorMessage = "❌ Invalid OTP. Please try again."
                            }
                        }
                    }) {
                        actionButton(title: isMobileOTPFieldVisible ? "Next" : "Send OTP")
                    }
                    .padding(.top, 20)
                    
                    NavigationLink("", destination: EmailView(username: username), isActive: $isMobileNumberFormCompleted)
                        .hidden()
                }
                .padding(.horizontal, 30)
            }
            .onAppear {
                print("✅ Username in PhoneNumberView: \(username)") // ✅ Debugging
            }

        }
    }
        
    // ✅ Validate OTP
    private func validateOTP(_ otp: String) -> Bool {
        return otp == "1234"
    }

    // ✅ Validate phone number based on selected country
    private func validatePhoneNumber(_ number: String, countryCode: String) -> Bool {
        let pattern: String
        switch countryCode {
        case "+1": // Canada
            pattern = #"^\(?([2-9][0-9]{2})\)?[-. ]?([2-9][0-9]{2})[-. ]?([0-9]{4})$"#
        case "+91": // India
            pattern = #"^[6-9]\d{9}$"#
        default:
            return false
        }
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: number)
    }

    // ✅ Format phone number while typing
    private func formatPhoneNumber(_ number: String, countryCode: String) -> String {
        let digits = number.filter { "0123456789".contains($0) } // Remove non-numeric characters

        if countryCode == "+1" { // Canada Formatting
            if digits.count > 10 {
                return String(digits.prefix(10))
            } else if digits.count >= 6 {
                return "(\(digits.prefix(3))) \(digits.dropFirst(3).prefix(3))-\(digits.dropFirst(6))"
            } else if digits.count >= 3 {
                return "(\(digits.prefix(3))) \(digits.dropFirst(3))"
            } else {
                return digits
            }
        } else { // India Formatting
            return digits.prefix(10).description // Only 10 digits for India
        }
    }
}
#Preview {
    PhoneNumberView(username: "TestUser")
}

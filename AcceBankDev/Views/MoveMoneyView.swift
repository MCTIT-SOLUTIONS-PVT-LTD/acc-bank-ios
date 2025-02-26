import SwiftUI

struct MoveMoneyView: View {
    @State private var isShowingTransferOptions = false // State to show modal

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.deepTeal, Color.dodgerBlue]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 25) {
                Text("Move money")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                            .padding(.top, 30)
                    .padding(.bottom, 35)

                optionButton(title: "Transfers")
                
                optionButton(title: "Interac e-Transfer®", italic: true) {
                    isShowingTransferOptions.toggle() // Open modal on tap
                }

                optionButton(title: "Payments")
                optionButton(title: "Scheduled transfers & payments")

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
    }

    /// ✅ Reusable Button
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

//  Step 2: Create the Bottom Sheet View
struct TransferOptionsView: View {
    @State private var isShowingSendMoneyForm = false // Show Send Money Form
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Interac e-Transfer®")
                    .font(.headline)
                    .italic()
                    .foregroundColor(.black)
                    .padding(.leading, 20) // ✅ Add left padding
                
                Spacer()
                
                Button(action: {
                    // Close the modal
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                }) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(15) // ✅ Increase padding for better tap target
                }
            }
            .padding(.top, 15) // ✅ Add top padding
            //.frame(maxWidth: .infinity)
            
            Divider() // ✅ Adds a subtle line below the title
            
            // List of Transfer Options
            transferOption(icon: "square.and.arrow.up.fill", title: "Send money")
            transferOption(icon: "arrow.down.left.circle.fill", title: "Request money")
            transferOption(icon: "person.2.fill", title: "Manage contacts")
            transferOption(icon: "clock.arrow.circlepath", title: "Pending")
            transferOption(icon: "clock.fill", title: "History")
            transferOption(icon: "gearshape.fill", title: "Autodeposit settings")
            transferOption(icon: "person.crop.circle", title: "Profile settings")
            
            Spacer()
        }
        //.padding(.all,50)
        //.background(Color.gray)
        
        
        
        //        .sheet(isPresented: $isShowingSendMoneyForm) {
        //            SendMoneyView() // Calls the new file for Send Money form
        //        }
        .frame(width: 350) // ✅ Make white box smaller
        .background(
            Color(.white).opacity(0.6) // ✅ White box is now semi-transparent
        )
        .cornerRadius(20) // ✅ Rounded corners
        .padding(.horizontal, 20) // ✅ Reduce width further
        
        
        
    }
    
    /// ✅ Transfer Option Button
    //    private func transferOption(icon: String, title: String) -> some View {
    //            Button(action: {
    //                print("\(title) tapped")
    //            }) {
    //                HStack {
    //                    Image(systemName: icon)
    //                        .foregroundColor(.black)
    //                        .font(.title2)
    //                        .frame(width: 20, height: 30)
    //
    //                    Text(title)
    //                        .font(.system(size: 18))
    //                        .foregroundColor(.black) // ✅ No pre-selection
    //
    //                    Spacer()
    //                    Image(systemName: "chevron.right")
    //                        .foregroundColor(.gray)
    //                }
    //                .padding()
    //                .background(Color.clear) // ✅ No background selection by default
    //                .cornerRadius(10)
    //            }
    //            .padding(.horizontal)
    //        }
    //    }
    private func transferOption(icon: String, title: String) -> some View {
        Button(action: {
            if title == "Send money" {
                isShowingSendMoneyForm.toggle() // Open Send Money Form
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
            SendMoneyView() // ✅ Open the new Send Money Form
        }
    }
    
}
    // ✅ Preview
    struct MoveMoneyView_Previews: PreviewProvider {
        static var previews: some View {
            MoveMoneyView()
        }
    }


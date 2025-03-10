import SwiftUI

//struct MoveMoneyView: View {
//    @State private var showBottomSheet = false // Controls modal visibility
//    
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                ZStack {
//                    // Background Gradient
//                    Constants.backgroundGradient
//                        .edgesIgnoringSafeArea(.all)
//                    VStack(spacing: 10) {
//                       HeaderView()
//
////                        VStack(spacing: 0) {
////                            ZStack {
////                                Color.white
////                                    .frame(height: geometry.size.height * 0.12) // Adjust header height dynamically
////                                    .frame(maxWidth: .infinity)
////                                    .ignoresSafeArea(edges: .top)
////
////                                // Logo placed centrally below the notch
////                                Image("AppLogo")
////                                    .resizable()
////                                    .scaledToFit()
////                                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.05) // Adjust logo size dynamically
////    //                                .padding(.top, geometry.safeAreaInsets.top * 0.3) // Adds some space below the notch
////                                    .padding(.top, geometry.safeAreaInsets.top * -0.9) // Adds some space below the notch, while keeping logo inside white box
////                                
////                            }
////                            .padding(.bottom, 10)
////                        }
//
//                      
//                        // **Move Money Title**
//                        Text("Move Money")
//                            .font(.title)
//                            .bold()
//                            .foregroundColor(.white)
//                            .padding(.bottom, 15)
//                        
//                        // **Fixed Height Scrollable Gray Box**
//                        VStack {
//                            ScrollView {
//                                VStack(spacing: 15) { // Increased spacing
//                                    MoveMoneyOptionRow(icon: "arrow.left.arrow.right", title: "Transfers", subtitle: "OWN BANK ACCOUNTS")
//                                    Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
//                                    
//                                    // **Interac e-Transfer opens the Bottom Sheet**
//                                    Button(action: {
//                                        showBottomSheet = true
//                                    }) {
//                                        MoveMoneyOptionRow(icon: "doc.text", title: "Interac e-Transfer", subtitle: "SEND OR REQUEST MONEY")
//                                    }
//                                    .buttonStyle(PlainButtonStyle()) // Removes default button style
//                                    
//                                    Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
//                                    
//                                    MoveMoneyOptionRow(icon: "building.columns.fill", title: "Payments", subtitle: "TRANSFER FUNDS BETWEEN CANADIAN BANK")
//                                    Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
//                                    //                                    MoveMoneyOptionRow(icon: "building.columns.fill", title: "Payments", subtitle: "TRANSFER FUNDS BETWEEN CANADIAN BANK")
//                                    //                                    Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
//                                    
//                                    MoveMoneyOptionRow(icon: "person.fill.checkmark", title: "Scheduled transfers & payments", subtitle: "SEND MONEY TO YOUR CLIENT")
//                                    Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
//                                }
//                                .padding(.horizontal, 5)
//                                .padding(.vertical, 1)
//                            }
//                        }
//                        //.padding(.horizontal,15)
//                        .padding(20)
//                        .frame(width: geometry.size.width * 0.95, height: 550)
//                        .background(Color(UIColor.systemGray6)) // **Set same Gray**
//                        .cornerRadius(20)
//                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
//                        
//                        Spacer()
//                    }
//                    
//                }
//            }
//            .edgesIgnoringSafeArea(.top)
//            .sheet(isPresented: $showBottomSheet) {
//                InteracETransferSheet()
//                    .presentationDetents([.fraction(0.5)]) // **Half Height Bottom Sheet**
//                    .background(.clear) // **Fix transparency issue**
//                    .edgesIgnoringSafeArea(.bottom) // **Ensures full coverage**
//                
//            }
//        }
//    }
//}

struct MoveMoneyView: View {
    @State private var showBottomSheet = false // Controls modal visibility
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                Constants.backgroundGradient
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    // ✅ Use Reusable Header
                    HeaderView()
                        .padding(.top,20)

                    // ✅ Move Money Title
                    Text("Move Money")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.bottom, 15)

                    // ✅ Fixed Height Scrollable Gray Box
                    VStack {
                        ScrollView {
                            VStack(spacing: 15) { // Increased spacing
                                MoveMoneyOptionRow(icon: "arrow.left.arrow.right", title: "Transfers", subtitle: "OWN BANK ACCOUNTS")
                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)

                                // ✅ Interac e-Transfer opens the Bottom Sheet
                                Button(action: {
                                    showBottomSheet = true
                                }) {
                                    MoveMoneyOptionRow(icon: "doc.text", title: "Interac e-Transfer", subtitle: "SEND OR REQUEST MONEY")
                                }
                                .buttonStyle(PlainButtonStyle()) // Removes default button style

                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)

                                MoveMoneyOptionRow(icon: "building.columns.fill", title: "Payments", subtitle: "TRANSFER FUNDS BETWEEN CANADIAN BANK")
                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)

                                MoveMoneyOptionRow(icon: "person.fill.checkmark", title: "Scheduled transfers & payments", subtitle: "SEND MONEY TO YOUR CLIENT")
                                Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                        }
                    }
                    .padding(20)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 550)
                    .background(Color(UIColor.systemGray6)) // **Set same Gray**
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                    Spacer()
                }
            }
            .navigationBarTitle("", displayMode: .inline) // ✅ Ensures no empty space at top
            .navigationBarHidden(true) // ✅ Hides default navigation bar to avoid extra padding
            .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: $showBottomSheet) {
                InteracETransferSheet()
                    .presentationDetents([.fraction(0.5)]) // **Half Height Bottom Sheet**
                    .background(.clear) // **Fix transparency issue**
                    .edgesIgnoringSafeArea(.bottom) // **Ensures full coverage**
            }
        }
    }
}

    
    // MARK: - Interac e-Transfer Bottom Sheet View
    struct InteracETransferSheet: View {
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            VStack {
                HStack {
                    Text("Interac e-Transfer®")
                        .font(.headline)
                        .bold()
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        InteracOptionRow(icon: "paperplane.fill", title: "Send money")
                        InteracOptionRow(icon: "arrow.down.doc.fill", title: "Request money")
                        InteracOptionRow(icon: "person.crop.circle.fill", title: "Manage contacts")
                        InteracOptionRow(icon: "clock.fill", title: "Pending")
                        InteracOptionRow(icon: "list.bullet", title: "History")
                        InteracOptionRow(icon: "gearshape.fill", title: "Autodeposit settings")
                        InteracOptionRow(icon: "person.text.rectangle.fill", title: "Profile settings")
                    }
                    .padding()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGray6)) // **Ensures same gray as the main screen**
            //.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            //.background(.clear)
            .edgesIgnoringSafeArea(.bottom) // **Fixes bottom white issue**
        }
    }
    
    struct InteracOptionRow: View {
        let icon: String
        let title: String
        
        // Track the navigation state for "Send Money"
        @State private var isShowingSendMoney = false
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color.black)
                    .frame(width: 35, height: 35)
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .onTapGesture {
                // ✅ Open "Send Money" full screen if tapped
                if title == "Send money" {
                    isShowingSendMoney = true
                }
            }
            .fullScreenCover(isPresented: $isShowingSendMoney) {
                SendMoneyView()
            }
        }
    }
    //// MARK: - Interac e-Transfer Option Row
    //struct InteracOptionRow: View {
    //    let icon: String
    //    let title: String
    //
    //    var body: some View {
    //        HStack {
    //            Image(systemName: icon)
    //                .font(.title2)
    //                .foregroundColor(Color.black)
    //                .frame(width: 35, height: 35)
    //
    //            Text(title)
    //                .font(.headline)
    //
    //            Spacer()
    //
    //            Image(systemName: "chevron.right")
    //                .foregroundColor(.gray)
    //        }
    //        .padding(.vertical, 10)
    //        .padding(.horizontal,20)
    //    }
    //}
    
    // MARK: - Move Money Row View
    struct MoveMoneyOptionRow: View {
        let icon: String
        let title: String
        let subtitle: String
        
        var body: some View {
            HStack(spacing: 19) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 45, height: 45) // Adjusted icon size
                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20)) // Increased icon size
                        .foregroundColor(.black)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 0)
        }
    }
    


// MARK: - Preview
struct MoveMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        MoveMoneyView()
    }
}

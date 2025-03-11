////import SwiftUI
////
////struct CustomTextField: View {
////    var placeholder: String
////    @Binding var text: String
////    var isSecure: Bool = false
////
////    var body: some View {
////        ZStack {
////            RoundedRectangle(cornerRadius: 25)
////                //.strokeBorder(text.isEmpty ? Color.white.opacity(0.4) : Color.white.opacity(0.2), lineWidth: 4)
////                .strokeBorder(text.isEmpty ? Color.white.opacity(0.5) : Color.white.opacity(0.9), lineWidth: 4)
////
////                .background(
////                    RoundedRectangle(cornerRadius: 25)
////                        .fill(Color.white.opacity(0.35))
////                        .blur(radius: 5)
////                )
////                .frame(width: 350, height: 50)
////                .shadow(radius: 2)
////
////            if isSecure {
////                SecureField(placeholder, text: $text)
////                    .padding(.horizontal, 20)
////                    .foregroundColor(.black)
////                    .textInputAutocapitalization(.never)
////            } else {
////                TextField(placeholder, text: $text)
////                    .padding(.horizontal, 20)
////                    .foregroundColor(.black)
////                    .textInputAutocapitalization(.never)
////            }
////        }
////        .padding(.horizontal, 40)
////    }
////}
////
////struct CustomTextField_Previews: PreviewProvider {
////    static var previews: some View {
////        CustomTextField(placeholder: "Placeholder", text: .constant(""))
////    }
////}
//import SwiftUI
//
//struct CustomTextField: View {
//    var placeholder: String
//    @Binding var text: String
//    var isSecure: Bool = false
//
//    var body: some View {
//        ZStack(alignment: .leading) {
//            RoundedRectangle(cornerRadius: 25)
//                .strokeBorder(text.isEmpty ? Color.white.opacity(0.5) : Color.white.opacity(0.9), lineWidth: 2)
//                .background(
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(Color.white.opacity(0.1))
//                        .clipShape(RoundedRectangle(cornerRadius: 25))
//                )
//                .frame(width: 350, height: 50)
//                .shadow(radius: 2)
//
//            if isSecure {
//                SecureField("", text: $text)
//                    .placeholder(when: text.isEmpty) {
//                        Text(placeholder)
//                            .foregroundColor(.white.opacity(0.7))
//                            .padding(.leading, 5) // Keep placeholder inside, left-aligned
//                    }
//                    .padding(.leading, 20) // Ensure text also starts from left
//                    .foregroundColor(.white)
//                    .textInputAutocapitalization(.never)
//                    //textInputAutocapitalization(TextInputAutocapitalization.never)
//
//                    .autocorrectionDisabled()
//                    .frame(width: 350, height: 50, alignment: .leading) // Ensure input is aligned left
//            } else {
//                TextField("", text: $text)
//                    .placeholder(when: text.isEmpty) {
//                        Text(placeholder)
//                            .foregroundColor(.white.opacity(0.7))
//                            .padding(.leading, 5) // Keep placeholder inside, left-aligned
//                    }
//                    .padding(.leading, 20) // Ensure text also starts from left
//                    .foregroundColor(.white)
//                    .textInputAutocapitalization(.never)
//                    .autocorrectionDisabled()
//                    .frame(width: 350, height: 50, alignment: .leading) // Ensure input is aligned left
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal, 40)
//        .animation(.easeInOut(duration: 0.2), value: text)
//    }
//}
//
//extension View {
//    func placeholder<Content: View>(
//        when shouldShow: Bool,
//        alignment: Alignment = .leading, // Left-aligned inside field
//        @ViewBuilder placeholder: () -> Content
//    ) -> some View {
//        ZStack(alignment: alignment) {
//            placeholder().opacity(shouldShow ? 1 : 0)
//            self
//        }
//    }
//}


import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    @State private var isPasswordVisible: Bool = false // Toggle for password visibility

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(text.isEmpty ? Color.white.opacity(0.5) : Color.white.opacity(0.9), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                )
                .frame(width: 350, height: 50)
                .shadow(radius: 2)

            HStack {
                if isSecure {
                    if isPasswordVisible {
                        TextField("", text: $text)
                            .placeholder(when: text.isEmpty) {
                                Text(placeholder)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.leading, 5)
                            }
                            .padding(.leading, 20)
                            .foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .frame(width: 300, height: 50, alignment: .leading) // Adjusted width for icon space
                    } else {
                        SecureField("", text: $text)
                            .placeholder(when: text.isEmpty) {
                                Text(placeholder)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.leading, 5)
                            }
                            .padding(.leading, 20)
                            .foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .frame(width: 300, height: 50, alignment: .leading) // Adjusted width for icon space
                    }

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 15)
                } else {
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.leading, 5)
                        }
                        .padding(.leading, 20)
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .frame(width: 350, height: 50, alignment: .leading)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

// Placeholder Extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

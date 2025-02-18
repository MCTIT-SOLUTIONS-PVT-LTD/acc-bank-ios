//import SwiftUI
//
//struct CustomTextField: View {
//    var placeholder: String
//    @Binding var text: String
//    var isSecure: Bool = false
//
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 25)
//                //.strokeBorder(text.isEmpty ? Color.white.opacity(0.4) : Color.white.opacity(0.2), lineWidth: 4)
//                .strokeBorder(text.isEmpty ? Color.white.opacity(0.5) : Color.white.opacity(0.9), lineWidth: 4)
//
//                .background(
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(Color.white.opacity(0.35))
//                        .blur(radius: 5)
//                )
//                .frame(width: 350, height: 50)
//                .shadow(radius: 2)
//
//            if isSecure {
//                SecureField(placeholder, text: $text)
//                    .padding(.horizontal, 20)
//                    .foregroundColor(.black)
//                    .textInputAutocapitalization(.never)
//            } else {
//                TextField(placeholder, text: $text)
//                    .padding(.horizontal, 20)
//                    .foregroundColor(.black)
//                    .textInputAutocapitalization(.never)
//            }
//        }
//        .padding(.horizontal, 40)
//    }
//}
//
//struct CustomTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextField(placeholder: "Placeholder", text: .constant(""))
//    }
//}
import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

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

            if isSecure {
                SecureField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.leading, 5) // Keep placeholder inside, left-aligned
                    }
                    .padding(.leading, 20) // Ensure text also starts from left
                    .foregroundColor(.white)
                    .textInputAutocapitalization(.never)
                    //textInputAutocapitalization(TextInputAutocapitalization.never)

                    .autocorrectionDisabled()
                    .frame(width: 350, height: 50, alignment: .leading) // Ensure input is aligned left
            } else {
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.leading, 5) // Keep placeholder inside, left-aligned
                    }
                    .padding(.leading, 20) // Ensure text also starts from left
                    .foregroundColor(.white)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .frame(width: 350, height: 50, alignment: .leading) // Ensure input is aligned left
            }
        }
        .frame(maxWidth: .infinity) // Center horizontally
        .padding(.horizontal, 40)
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading, // Left-aligned inside field
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

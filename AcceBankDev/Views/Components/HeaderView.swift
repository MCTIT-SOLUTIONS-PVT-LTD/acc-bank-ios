import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            Color.white
                .frame(height: 90) // set fixed height
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(edges: .top)

            // Properly Scaled and Centered Logo
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 35) // Set fixed width & height for consistency
        }
    }
}
//struct HeaderView: View {
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Color.white
//                    .frame(height: geometry.size.height * 0.12) // Dynamic height for different screens
//                    .frame(maxWidth: .infinity)
//                    .ignoresSafeArea(edges: .top)
//
//                // Properly Scaled and Centered Logo
//                Image("AppLogo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.05) // ✅ Adjusted for better scaling
//            }
//        }
//       .frame(height: UIScreen.main.bounds.height * 0.12) // ✅ Ensures stable height across devices
//        .padding(.bottom, 5) // ✅ Provides proper spacing below the header
//    }
//}

//struct HeaderView: View {
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Color.white
//                    .frame(height: geometry.safeAreaInsets.top + 100) // ✅ Adjust dynamically for safe area
//                    .frame(maxWidth: .infinity)
//                    .ignoresSafeArea(edges: .top)
//
//                // ✅ Properly Scaled and Centered Logo
//                Image("AppLogo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: geometry.size.width * 0.4, height: 50) // ✅ Adjusted Logo Sizing
//            }
//        }
//        .frame(height: 100) // ✅ Ensures stability across all screen sizes
//    }
//}
// MARK: - Preview
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}

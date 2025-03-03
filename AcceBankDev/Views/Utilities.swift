import SwiftUI

// Fix: Convert `backgroundGradient` into a computed property
var backgroundGradient: some View {
    Color.backgroundGradient.edgesIgnoringSafeArea(.all)
}

// Fix: No change needed for `actionButton`
func actionButton(title: String) -> some View {
    Text(title)
        .fontWeight(.bold)
        .frame(width: 200, height: 50)
        .background(Color.white)
        .foregroundColor(.black)
        .clipShape(Capsule())
}

// Remove this since `Utilities` is not a view
// #Preview {
//     Utilities()
// }

// Fix: Use an actual view for preview
#Preview {
    ZStack {
        backgroundGradient
        actionButton(title: "Test Button")
    }
}

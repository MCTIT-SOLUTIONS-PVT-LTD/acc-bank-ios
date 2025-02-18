import SwiftUI

struct HomeView: View {
    var username: String

    var body: some View {
        ZStack {
            // Background Gradient
//            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]),
//                           startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.deepTeal,
                    Color.dodgerBlue
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Profile Image
                Image("profilePic")
                    .resizable()
                    .background(.black)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    //.overlay(Circle().stroke(Color.white, lineWidth: 2))

                VStack {
                    Text("Welcome \(username) to")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Acceinfo Bank")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 10)

                Text(getGreeting())
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 5)

                Spacer()
                
                
                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 360, height: 400) // Adjust height based on content
                                    .shadow(radius: 5)
                                    .padding(.bottom,15)
                
                Spacer()
                
                
            }
            .padding(.bottom,100)
        }
    }

    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(username: "Danielle")
    }
}

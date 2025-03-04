import SwiftUI
//in this file add logic that open icon wise on home click open home 
struct MainView: View {
    @State private var selectedTab = 0 // Tracks the selected tab

    var body: some View {
        ZStack {
            selectedView //  Calls the selected view dynamically

            VStack {
                Spacer()
                BottomNavigationBar(selectedTab: $selectedTab) // Pass binding
            }
        }
    }

    //Returns the view based on selectedTab
    private var selectedView: some View {
        Group {
            switch selectedTab {
            case 0:
                HomeView()
            case 1:
                MoveMoneyView()
            default:
                HomeView()
            }
        }
    }
}

// Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

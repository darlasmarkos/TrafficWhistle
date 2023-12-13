import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    //  @State private var showSplash = true // Add this line for splash screen state
    var body: some View {
        
        Group {
            
            if $viewModel.userSession != nil {
                if ((viewModel.currentUser?.userRole)  == "citizen") {
                    HomeView()
                } else if((viewModel.currentUser?.userRole)  == "admin"){
                    AdminView()
                    
                } else {
                    LoginView()
                }
            }
        }
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

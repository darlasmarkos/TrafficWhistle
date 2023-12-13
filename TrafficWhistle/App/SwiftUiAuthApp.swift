//
//  SwiftUiAuthApp.swift
//  SwiftUiAuth
//
//  Created by Mark Darlas on 13/12/23.
//

import SwiftUI
import Firebase

@main
struct SwiftUiAuthApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

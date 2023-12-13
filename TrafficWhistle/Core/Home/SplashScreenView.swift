//
//  SplashScreenView.swift
//  SplashScreenTutorial
//
//  Created by Eymen on 23.07.2023.
//

import SwiftUI

struct SplashScreenView: View {
    let title: String
    var body: some View {
        ZStack {
            Color.orange
                .edgesIgnoringSafeArea(.all)
            
            Text(title)
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(title: "a")
    }
}

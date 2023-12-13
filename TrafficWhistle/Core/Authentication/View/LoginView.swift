//
//  LoginView.swift
//  SwiftUiAuth
//
//  Created by Mark Darlas on 13/12/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email=""
    @State private var password=""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                //form fields
                VStack(spacing: 24){
                    InputView(text: $email, title: "Email Adress", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    InputView(text: $password, title: "Password", placeholder: "Enter your Password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 200)
                
                //sign in butto
                
                Button{
                    Task{
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                }label:{
                    HStack{
                        Text("Sign In ")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .padding()
                .frame(width: 280, height: 60)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(17)
                
                Spacer()
                //sign up button
                NavigationLink{
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 2){
                        Text(" Dont have an account yet?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

#Preview {
    LoginView()
}

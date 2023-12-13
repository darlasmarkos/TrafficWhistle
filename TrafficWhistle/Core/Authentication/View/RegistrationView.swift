//
//  LoginView.swift
//  SwiftUiAuth
//
//  Created by Mark Darlas on 13/12/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email=""
    @State private var fullname=""
    @State private var password=""
    @State private var confirmPassword=""
    @State private var userRole="citizen"
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
            VStack{
                //form fields
                VStack(spacing: 24){
                    InputView(text: $email, title: "Email Adress", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $fullname, title: "Full Name", placeholder: "Enter your name")
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your Password", isSecureField: true)
                    
                    //InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your Password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 200)
                
                //sign up button
                Button{
                    Task{
                        try await viewModel.createUser(withEmail: email, password: password, fullname: fullname, userRole: userRole)
                    }
                }label:{
                    HStack{
                        Text("Sign Up")
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
                
                //sign in button
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 2){
                    Text("Already have an account yet?")
                    Text("Sign in")
                        .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }

#Preview {
    RegistrationView()
}

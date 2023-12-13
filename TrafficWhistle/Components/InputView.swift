//
//  InputView.swift
//  SwiftUiAuth
//
//  Created by Mark Darlas on 13/12/23.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
          VStack(spacing: 5) {
            HStack(spacing: 8) {
              HStack(spacing: 8) {
                  
                HStack(spacing: 10) {
                  VStack(alignment: .leading, spacing: 0) {
                      
                      if isSecureField{
                          SecureField(placeholder, text: $text)
                              .font(Font.custom("Archivo", size: 12))
                              .lineSpacing(16.80)
                              .foregroundColor(Color(red: 0.04, green: 0.06, blue: 0.11))
                      } else{
                          TextField(placeholder, text: $text)
                              .font(Font.custom("Archivo", size: 12))
                              .lineSpacing(16.80)
                              .foregroundColor(Color(red: 0.04, green: 0.06, blue: 0.11))
                      }
                      
                  }
                  .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, minHeight: 17, maxHeight: 17)
              }
              .frame(maxWidth: .infinity, minHeight: 17, maxHeight: 17)
            }
            .padding(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 15))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(15)
            .overlay(
              RoundedRectangle(cornerRadius: 15)
                .inset(by: 1)
                .stroke(Color(red: 0.26, green: 0.26, blue: 0.90), lineWidth: 1)
            )
          }
          .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
        }
        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        .frame(width: 340, height: 58)
    }
}

#Preview {
    InputView(text: .constant(""), title:"Email Adress", placeholder: "name@example.com")
}

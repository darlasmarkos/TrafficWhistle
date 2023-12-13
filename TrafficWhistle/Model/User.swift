//
//  User.swift
//  SwiftUiAuth
//
//  Created by Mark Darlas on 18/12/23.
//

import Foundation
struct User: Identifiable, Codable{
    let id: String
    let fullname: String
    let email: String
    let userRole: String
    
    var initials: String{
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

extension User{
    static var MOCK_USER : [User] = [.init(id: NSUUID().uuidString, fullname: "Markos Darlas", email:"test@gmail.com", userRole: "admin")]
}

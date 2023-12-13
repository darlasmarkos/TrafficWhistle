//
//  AuthViewModel.swift
//  SwiftUiAuth
//
//  Created by Mark Darlas on 18/12/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            print("DEBUG: FAILED TO LOGIN WITH ERROR: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, userRole: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, userRole: userRole)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        }catch{
            print("DEBUG: FAILED TO CREATE USER WITH ERROR \(error.localizedDescription)")
        }
        
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut() //signs out on backend
            self.userSession = nil  //wipes out users session and takes us back to login view
            self.currentUser = nil
        }catch{
            print("DEBUG: FAILED TO SIGN OUT \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
            guard let user = Auth.auth().currentUser else { return }
            let uid = user.uid
            
            do {
                try await Firestore.firestore().collection("users").document(uid).delete()
                try await user.delete()
                self.userSession = nil
                self.currentUser = nil
            } catch {
                print("DEBUG: FAILED TO DELETE USER WITH ERROR \(error.localizedDescription)")
                throw error
            }
        }
    
    static func loadUser(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: CURRENT USER IS  \(String(describing: self.currentUser))")
    }
}

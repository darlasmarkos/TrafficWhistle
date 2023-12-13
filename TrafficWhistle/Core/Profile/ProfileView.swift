import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showDeleteAccountAlert = false
    @State private var deleteAccountError: String?

    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }
                Section("Reports History") {
                    SettingsViewRow(imageName: "clock.fill", title: "History", tintColor: Color(.systemGray))
                }
                Section("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsViewRow(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.red))
                    }

                    Button {
                        showDeleteAccountAlert = true
                    } label: {
                        SettingsViewRow(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red))
                    }
                }
            }
            .alert(isPresented: $showDeleteAccountAlert) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        Task {
                            do {
                                try await viewModel.deleteAccount()
                            } catch {
                                deleteAccountError = error.localizedDescription
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            
            if let error = deleteAccountError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}

struct SettingsViewRow: View {
    let imageName: String
    let title: String
    let tintColor: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    ProfileView()
}

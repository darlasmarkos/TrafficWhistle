//
//  AdminView.swift
//  SwiftUiAuth
//
//  Created by Mark Darlas on 8/1/24.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var viewModel2 = FeedViewModel()
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Reported Incidents")
                            .font(.system(size: 25))
                            .fontWeight(.heavy)
                            .foregroundColor(.black.opacity(0.8))
                    }
                    Spacer()
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "gear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .accentColor(.black.opacity(0.8))
                    }
                    .accentColor(.orange)
                }
                .padding(.top, 80)
                .padding(.horizontal, 30)
                .frame(height: 150)
                .background(Color.orange)
                .mask(CustomShape(radius: 50))
                .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 5)
                .edgesIgnoringSafeArea(.top)
               
                ScrollView {
                    LazyVStack(spacing: 32) {
                        ForEach(viewModel2.reports.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })) { report in
                            AdminReportCell(report: report)
                        }
                    }
                }
            }
            .containerRelativeFrame([.horizontal, .vertical])
        }
    }
}

   

#Preview {
    AdminView()
}

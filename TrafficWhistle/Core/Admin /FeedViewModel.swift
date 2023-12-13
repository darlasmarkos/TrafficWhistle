//
//  FeedViewModel.swift
//  TrafficWhistle
//
//  Created by Mark Darlas on 1/5/24.
//

import Foundation
import Firebase

class FeedViewModel: ObservableObject {
    @Published var reports = [ReportedIncident]()
    
    init(){
        Task {try await fetchIncidents() }
    }
    func fetchIncidents() async throws {
            let snapshot = try await Firestore.firestore().collection("incidents").getDocuments()
            print("Fetched \(snapshot.documents.count) documents") // Debugging line
            
            var fetchedReports = [ReportedIncident]()
            
            for document in snapshot.documents {
                do {
                    var report = try document.data(as: ReportedIncident.self)
                    print("Successfully decoded report: \(report)") // Debugging line
                    
                    if report.isAnonymous == true {
                        fetchedReports.append(report)
                    } else {
                        let ownerUid = report.ownerUid
                        let reportUser = try await AuthViewModel.loadUser(withUid: ownerUid)
                        report.user = reportUser
                        fetchedReports.append(report)
                        print("Loaded user for report: \(reportUser)") // Debugging line
                    }
                } catch {
                    print("Failed to decode report: \(error)") // Debugging line
                }
            }
            
            DispatchQueue.main.async {
                self.reports = fetchedReports
                print("Total reports fetched: \(self.reports.count)") // Debugging line
            }
        }
    }

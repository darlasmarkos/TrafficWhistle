import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation
import PhotosUI
import SwiftUI

@MainActor
class IncidentViewModel: ObservableObject {
//    @Published var reportedIncidents: [ReportedIncident] = []
//    let authViewModel: AuthViewModel // Inject AuthViewModel here
//    
//    init(authViewModel: AuthViewModel) async {
//        self.authViewModel = authViewModel
//        await fetchReportedIncidents() // Load reported incidents upon initialization
//    }
//    
//    func reportIncident(type: String, coordinate: CLLocationCoordinate2D) async throws {
//        guard let currentUser = await authViewModel.currentUser else {
//            print("DEBUG: User not logged in")
//            return
//        }
//        
//        do {
//            let incident = ReportedIncident(type: type, latitude: coordinate.latitude, longitude: coordinate.longitude, user: currentUser)
//            let encoder = JSONEncoder()
//            let encodedIncident = try encoder.encode(incident)
//            let json = try JSONSerialization.jsonObject(with: encodedIncident, options: []) as? [String: Any] ?? [:]
//            let _ = try await Firestore.firestore().collection("reported_incidents").addDocument(data: json) // Use addDocument(data:) to add the incident directly
//            await fetchReportedIncidents()
//        } catch {
//            print("DEBUG: FAILED TO REPORT INCIDENT WITH ERROR \(error.localizedDescription)")
//        }
//    }
//
//
//    
//    func fetchReportedIncidents() async {
//        do {
//            let querySnapshot = try await Firestore.firestore().collection("reported_incidents").getDocuments()
//            self.reportedIncidents = querySnapshot.documents.compactMap { document in
//                try? document.data(as: ReportedIncident.self)
//            }
//        } catch {
//            print("DEBUG: FAILED TO FETCH REPORTED INCIDENTS WITH ERROR \(error.localizedDescription)")
//        }
//    }
    @Published var selectedImage: PhotosPickerItem?{
        didSet{Task{await loadImage(fromItem: selectedImage)}}
    }
    @Published var incidentImage: Image?
    private var uiImage: UIImage?
    
    // item is the photo from the photopicker
    func loadImage(fromItem item: PhotosPickerItem?) async{
        //in this guard it makes sure we have the image
        guard let item = item else {return}
        
        //in here we get the actual data used to construct the image
        guard let data = try? await item.loadTransferable(type: Data.self) else {return} //native photo picker SwiftUI
        //create image using the image data form above
        guard let uiImage = UIImage(data: data) else {return}
        //then finally create the SwiftUI image from the UIImage
        self.uiImage = uiImage
        self.incidentImage = Image(uiImage: uiImage)
    }
    
    func uploadReport(type: String, location: String, info: String, isAnonymous: Bool) async throws{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let uiImage = uiImage else {return}
        let postRef = Firestore.firestore().collection("incidents").document()
        guard let imageUrl = try await ImageUploader.uploadImage(image: uiImage) else {return}
        let report = ReportedIncident(id: postRef.documentID, ownerUid: uid, type: type, imageUrl: imageUrl, timestamp: Timestamp(), location: location, info: info, isAnonymous: isAnonymous)
        guard let encodedReport = try? Firestore.Encoder().encode(report) else {return}
        
        guard let encodedReport = try? Firestore.Encoder().encode(report) else { return }
        
        try await postRef.setData(encodedReport)
    }

}

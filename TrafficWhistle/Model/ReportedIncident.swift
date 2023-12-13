import Foundation
import Firebase

struct ReportedIncident: Identifiable, Codable {
    let id: String
    let ownerUid: String
    let type: String
    let imageUrl: String
    let timestamp: Timestamp
    let location: String
    let info: String
    var user: User?
    let isAnonymous: Bool?
    
    enum CodingKeys: String, CodingKey {
          case id
          case ownerUid
          case type
          case imageUrl
          case timestamp
          case location
          case info
          case user
          case isAnonymous
      }
}
    
extension ReportedIncident {
    static var MOCK_REPORTS: [ReportedIncident] = [
        .init(id: NSUUID().uuidString, ownerUid: NSUUID().uuidString, type: "Speeding", imageUrl: "crash", timestamp: Timestamp(),  location: "Thessaloniki", info: "I crashed into another driver!!",user: User.MOCK_USER[0], isAnonymous: true),
//        .init(id: NSUUID().uuidString, ownerUid: NSUUID().uuidString, type: "Traffic Jam", imageUrl: "crash", timestamp: Timestamp(),  location: "Los Angeles", info: "Stuck in traffic for hours!", user: User.MOCK_USER[0]),
//        .init(id: NSUUID().uuidString, ownerUid: NSUUID().uuidString, type: "Pothole", imageUrl: "crash", timestamp: Timestamp(),  location: "New York", info: "Huge pothole on the highway!", user: User.MOCK_USER[0]),
//        .init(id: NSUUID().uuidString, ownerUid: NSUUID().uuidString, type: "Road Closure", imageUrl: "crash", timestamp: Timestamp(),  location: "London", info: "Road closed for construction!", user: User.MOCK_USER[0])
    ]
}

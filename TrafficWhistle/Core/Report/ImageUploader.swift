//
//  ImageUploader.swift
//  TrafficWhistle
//
//  Created by Mark Darlas on 26/4/24.
//

import UIKit
import Firebase
import FirebaseStorage

struct ImageUploader{
    static func uploadImage(image: UIImage) async throws -> String?{
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return nil }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/incident_images/\(filename)")
        
        do{
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
            
        }
        catch{
            print("Failed to uplaod image wirth error \(error.localizedDescription)")
            return nil
        }
    }
}

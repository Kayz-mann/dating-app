////
////  Photo.swift
////  datingApp
////
////  Created by Balogun Kayode on 09/08/2024.
////
//import UIKit
//import Foundation
//import Firebase
//import FirebaseStorage
//import FirebaseFirestoreSwift
//
//struct Photo: Identifiable, Codable {
//    @DocumentID var id: String?
//    var imageURLString = ""
//    var description  = ""
//    var reviewer = Auth.auth().currentUser?.email ?? ""
//    var postedOn = Date()
//    
//    var dictionary: [String: Any] {
//        return ["imageURLString": imageURLString]
//    }
//}
//
//func saveImage(spot: Spot, photo: Photo, image: UIImage) async -> Bool {
//    guard let spotID = spot.id else {
//        print("ERROR: spot.id == mil")
//        return false
//    }
//    
//    let photoName = UUID().uuidString // this will be the name of the image file
//    let storage = Storage.storage() //create a firebase storage instance
//    let storageRef = storage.reference().child("\(spotID)/\(photoName).jpeg")
//    
//    guard let resizedImage =  image.jpegData(compressionQuality: 0.2) else {
//        print("ERROR: Could not resize image")
//        return false
//    }
//    
//    let metadata = StorageMetadata()
//    metadata.contentType = "image/jpg" //Setting metadata allows you to see console image in the web  browser. This setting will work for png as well as jpeg
//    
//    var imageURLString = "" //We'll set this after image is saved successfully
//    
//    do {
//        let _  = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
//        print("image saved")
//        
//        do {
//            let imageURL = try await storageRef.downloadURL()
//            imageURLString = "\(imageURL)" //We'll save this to Colud Firestore as part of documents in 'photos' collection below
//        } catch {
//            print("ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
//            return false
//        }
//        
//    } catch {
//        print("ERROR: uploading image to FirebaseStorage")
//        return false
//    }
//    
//    //Now save to the photos collection of the spot document "spotID"
//    let db = Firestore.firestore()
//    let collectionString = "spots/\(spotID)/photos"
//    
//    do {
//        var newPhoto = photo
//        newPhoto.imageURLString = imageURLString
//        try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
//        print("Data updated successfully")
//        return true
//    } catch {
//        print("ERROR: Could not update data in 'photos' for spotID \(spotID)")
//        return false
//    }
//}

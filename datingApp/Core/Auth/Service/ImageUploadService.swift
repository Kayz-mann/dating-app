////
////  ImageUploadService.swift
////  datingApp
////
////  Created by Balogun Kayode on 12/08/2024.
////
//
//import SwiftUI
//import Alamofire
//
//
//
//// Function to upload an image to Cloudinary
//public func uploadImageToCloudinary(image: UIImage, completion: @escaping (String?) -> Void) {
//    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//        completion(nil)
//        return
//    }
//    
//    // Retrieve Cloudinary URL and upload preset from Keychain
//    let config = getCloudinaryConfig()
//    guard let cloudinaryURL = config.url, let uploadPreset = config.uploadPreset else {
//        print("Cloudinary configuration is missing.")
//        completion(nil)
//        return
//    }
//    
//    let parameters: [String: String] = [
//        "upload_preset": uploadPreset
//    ]
//    
//    AF.upload(multipartFormData: { formData in
//        formData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
//        for (key, value) in parameters {
//            formData.append(value.data(using: .utf8)!, withName: key)
//        }
//    }, to: cloudinaryURL)
//    .responseJSON { response in
//        switch response.result {
//        case .success(let value):
//            print("Cloudinary Response: \(value)")
//            if let json = value as? [String: Any],
//               let urlString = json["secure_url"] as? String {
//                completion(urlString)
//            } else {
//                completion(nil)
//            }
//        case .failure(let error):
//            print("Error uploading image to Cloudinary: \(error.localizedDescription)")
//            completion(nil)
//        }
//    }
//}

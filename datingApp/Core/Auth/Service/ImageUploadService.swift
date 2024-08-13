////
////  ImageUploadService.swift
////  datingApp
////
////  Created by Balogun Kayode on 12/08/2024.
////
//
import SwiftUI
import Alamofire


//// Function to upload an image to Cloudinary
public func uploadImageToCloudinary(image: UIImage, completion: @escaping (String?, Error?) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        completion(nil, NSError(domain: "ImageProcessing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image data."]))
        return
    }
    
    let url = "https://api.cloudinary.com/v1_1/afrotronika/image/upload" // Replace with your Cloudinary URL
    let preset = "ml_default"
    let parameters: [String: String] = [
        "upload_preset": preset
    ]
    
    AF.upload(multipartFormData: { formData in
        formData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
        for (key, value) in parameters {
            formData.append(value.data(using: .utf8)!, withName: key)
        }
    }, to: url)
    .responseJSON { response in
        switch response.result {
        case .success(let value):
            print("Cloudinary Response: \(value)")
            if let json = value as? [String: Any],
               let urlString = json["secure_url"] as? String {
                completion(urlString, nil)
            } else {
                completion(nil, NSError(domain: "CloudinaryResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Cloudinary response format."]))
            }
        case .failure(let error):
            print("Error uploading image to Cloudinary: \(error.localizedDescription)")
            completion(nil, error)
        }
    }
}


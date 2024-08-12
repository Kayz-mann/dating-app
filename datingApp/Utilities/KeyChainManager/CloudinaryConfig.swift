////
////  CloudinaryConfig.swift
////  datingApp
////
////  Created by Balogun Kayode on 12/08/2024.
////
//
//import Foundation
//
//class CloudinaryConfigManager {
//    static let shared = CloudinaryConfigManager()
//    
//    private init() {
//        initializeCloudinaryConfigFromEnv()
//    }
//    
//    func initializeCloudinaryConfigFromEnv() {
//        guard let cloudinaryURL = loadEnvironmentVariable(named: "CLOUDINARY_URL"),
//              let uploadPreset = loadEnvironmentVariable(named: "UPLOAD_PRESET") else {
//            print("Cloudinary configuration not found in environment variables.")
//            return
//        }
//        
//        // Save to Keychain or other secure storage if necessary
//        saveCloudinaryConfig(url: cloudinaryURL, uploadPreset: uploadPreset)
//    }
//}

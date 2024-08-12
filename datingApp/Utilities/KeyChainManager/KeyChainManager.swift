//
//  KeyChainManager.swift
//  datingApp
//
//  Created by Balogun Kayode on 12/08/2024.
//

import KeychainSwift

let keychain = KeychainSwift()

/// Initializes Cloudinary configuration from environment variables and stores them in Keychain.
func initializeCloudinaryConfigFromEnv() {
    if let url = loadEnvironmentVariable(named: "CLOUDINARY_URL"),
       let uploadPreset = loadEnvironmentVariable(named: "CLOUDINARY_PRESET") {
        saveCloudinaryConfig(url: url, uploadPreset: uploadPreset)
    } else {
        print("Error: Environment variables for Cloudinary configuration are missing.")
    }
}

/// Saves Cloudinary configuration to Keychain.
func saveCloudinaryConfig(url: String, uploadPreset: String) {
    keychain.set("https://api.cloudinary.com/v1_1/afrotronika/image/upload", forKey: "cloudinaryURL")
    keychain.set("ml_default", forKey: "uploadPreset")
}

/// Retrieves Cloudinary configuration from Keychain.
func getCloudinaryConfig() -> (url: String?, uploadPreset: String?) {
    let url = keychain.get("cloudinaryURL")
    let uploadPreset = keychain.get("uploadPreset")
    return (url, uploadPreset)
}

func printCloudinaryConfig() {
    let config = getCloudinaryConfig()
    print("Cloudinary URL: \(config.url ?? "nil")")
    print("Upload Preset: \(config.uploadPreset ?? "nil")")
}



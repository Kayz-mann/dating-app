//
//  AditionalInfoView.swift
//  datingApp
//
//  Created by Balogun Kayode on 06/08/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Alamofire

struct AdditionalInfoView: View {
    @Binding var currentStep: Int
    @State private var occupation: String = ""
    @State private var selectedZodiacSign: String = ""
    @State private var sexualOrientation: String = ""
    @State private var interestedIn: String = ""
    @State private var isPickerPresented = false
    @State private var isInterestPickerPresented = false
    @State private var validationMessage = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var uploadProgress: [Double] = []
    @State private var imageLoadingErrors: [Int: String] = [:]
    
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var appState: AppState
    private let db = Firestore.firestore()
    
    private var isFormValid: Bool {
        !occupation.isEmpty &&
        !selectedZodiacSign.isEmpty &&
        !sexualOrientation.isEmpty &&
        !interestedIn.isEmpty
    }
    
    private let sexualOrientations = ["Straight", "Bi"]
    private let interests = ["Men", "Women"]
    private let zodiacSigns = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        // Occupation
                        VStack(alignment: .leading) {
                            Text("Occupation")
                                .font(.footnote)
                                .padding(.bottom, 5)
                            
                            TextField("Enter your occupation", text: $occupation)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        .padding(.top, 25)
                        
                        // Zodiac Sign
                        VStack(alignment: .leading) {
                            Text("Zodiac Sign")
                                .font(.footnote)
                                .padding(.top)
                                .padding(.bottom)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                ForEach(zodiacSigns, id: \.self) { sign in
                                    Text(sign)
                                        .font(.footnote)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 6)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(sign == selectedZodiacSign ? Color.primaryPink : Color.gray.opacity(0.2))
                                        )
                                        .foregroundColor(sign == selectedZodiacSign ? .white : .black)
                                        .onTapGesture {
                                            selectedZodiacSign = sign
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom)
                        
                        // Sexual Orientation Picker
                        VStack(alignment: .leading) {
                            Text("Sexual Orientation")
                                .font(.footnote)
                                .padding(.bottom, 5)
                            
                            Button(action: {
                                isPickerPresented.toggle()
                            }) {
                                HStack {
                                    Text(sexualOrientation.isEmpty ? "Sexual orientation" : sexualOrientation)
                                        .foregroundColor(sexualOrientation.isEmpty ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                            .sheet(isPresented: $isPickerPresented) {
                                VStack {
                                    Picker("Sexual Orientation", selection: $sexualOrientation) {
                                        ForEach(sexualOrientations, id: \.self) { orientation in
                                            Text(orientation).tag(orientation)
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(WheelPickerStyle())
                                    
                                    Button("Done") {
                                        isPickerPresented = false
                                    }
                                    .padding()
                                }
                                .padding()
                            }
                        }
                        .padding(.top, 35)
                        
                        // Interest Picker
                        VStack(alignment: .leading) {
                            Text("Interested In")
                                .font(.footnote)
                                .padding(.bottom, 5)
                            
                            Button(action: {
                                isInterestPickerPresented.toggle()
                            }) {
                                HStack {
                                    Text(interestedIn.isEmpty ? "Interested In" : interestedIn)
                                        .foregroundColor(interestedIn.isEmpty ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                            .sheet(isPresented: $isInterestPickerPresented) {
                                VStack {
                                    Picker("Interested In", selection: $interestedIn) {
                                        ForEach(interests, id: \.self) { interest in
                                            Text(interest).tag(interest)
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(WheelPickerStyle())
                                    
                                    Button("Done") {
                                        isInterestPickerPresented = false
                                    }
                                    .padding()
                                }
                                .padding()
                            }
                        }
                        .padding(.top, 35)
                        
                        // Upload Progress
                        if !uploadProgress.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Upload Progress")
                                    .font(.footnote)
                                    .padding(.bottom, 5)
                                
                                ForEach(uploadProgress.indices, id: \.self) { index in
                                    ProgressView(value: uploadProgress[index], total: 1.0)
                                        .progressViewStyle(LinearProgressViewStyle())
                                        .frame(height: 10)
                                }
                            }
                            .padding(.top, 20)
                        }
                        
                        // Validation Message
                        if !validationMessage.isEmpty {
                            Text(validationMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 5)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    updateProfile()
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Finish")
                        }
                    }
                }
                .buttonStyle(CustomButtonStyle(isFormValid: isFormValid))
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(validationMessage), dismissButton: .default(Text("OK")))
                }
                
                // Navigation Link
//                NavigationLink(
//                    destination: MainTabView()
//                        .navigationBarBackButtonHidden(true)
//                        .navigationBarTitleDisplayMode(.inline),
//                    isActive: $authService.isProfileComplete,
//                    label: { EmptyView() }
//                )
            }
        }
        .navigationTitle("Additional Info")
        .foregroundColor(.black)
        .tint(.black)
    }
    
    
    private func updateProfile() {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        isLoading = true
        validationMessage = ""
        
        guard let profileImageURLs = appState.currentUser?.profileImageURLs else {
            print("No profile image URLs found.")
            isLoading = false
            return
        }
        
        uploadProgress = Array(repeating: 0.0, count: profileImageURLs.count)
        
        var uploadedImageURLs: [String] = []
        var imageLoadingErrors: [String] = []
        let uploadGroup = DispatchGroup()
        
        for (index, imageString) in profileImageURLs.enumerated() {
            uploadGroup.enter()
            
            fetchImage(from: imageString) { result in
                switch result {
                case .success(let image):
                    uploadImageToCloudinary(image: image) { urlString, error in
                        if let urlString = urlString {
                            uploadedImageURLs.append(urlString)
                            print("Successfully uploaded image \(index + 1)")
                        } else {
                            print("Failed to upload image \(index + 1).")
                            imageLoadingErrors.append("Failed to upload image \(index + 1): \(error?.localizedDescription ?? "Unknown error")")
                        }
                        uploadGroup.leave()
                    }
                    
                    authService.isProfileComplete = true
                    
                case .failure(let error):
                    print("Failed to load image: \(error.localizedDescription)")
                    imageLoadingErrors.append("Failed to load image \(index + 1): \(error.localizedDescription)")
                    uploadGroup.leave()
                }
            }
        }
        
        uploadGroup.notify(queue: .main) {
            if !imageLoadingErrors.isEmpty {
                self.validationMessage = "Some images failed to load or upload. Please check and try again."
                self.showingAlert = true
                self.isLoading = false
                print("Image loading errors: \(imageLoadingErrors)")
                return
            }
            
            let userRef = self.db.collection("users").document(email)
            let profileData: [String: Any] = [
                "email": self.appState.currentUser?.email,
                "fullName": self.appState.currentUser?.fullName ?? "",
                "age": self.appState.currentUser?.age ?? 18,
                "gender": self.appState.currentUser?.gender,
                "occupation": self.occupation,
                "zodiacSign": self.selectedZodiacSign,
                "sexualOrientation": self.sexualOrientation,
                "interestedIn": self.interestedIn == "Men" ? "Male": "Female",
                "profileImageURLs": uploadedImageURLs
            ]
            userRef.setData(profileData, merge: true) { error in
                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                    self.validationMessage = "Error updating profile. Please try again."
                    self.showingAlert = true
                } else {
                    self.appState.currentUser?.profileImageURLs = uploadedImageURLs
                    self.authService.isProfileComplete = true
                    self.currentStep = 1
                }
                self.isLoading = false
                self.uploadProgress = []
            }
        }
    }



    private func fetchImage(from imageString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if imageString.hasPrefix("data:image") || imageString.hasPrefix("iVBOR") {
            // Handle Base64 encoded image data
            guard let dataStart = imageString.range(of: ";base64,")?.upperBound else {
                let data = Data(base64Encoded: imageString)
                if let data = data, let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(NSError(domain: "ImageDecoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode Base64 image data"])))
                }
                return
            }
            
            let base64String = String(imageString[dataStart...])
            if let data = Data(base64Encoded: base64String), let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(NSError(domain: "ImageDecoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode Base64 image data"])))
            }
        } else if let url = URL(string: imageString) {
            // Handle URL
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(.failure(NSError(domain: "ImageDecoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image data from URL"])))
                    return
                }
                
                completion(.success(image))
            }
            task.resume()
        } else {
            completion(.failure(NSError(domain: "InvalidInput", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image string format"])))
        }
    }

}



#Preview {
    AdditionalInfoView(currentStep: .constant(2))
        .environmentObject(AuthService())
        .environmentObject(AppState())
}

//
//  AgePicker.swift
//  datingApp
//
//  Created by Balogun Kayode on 05/08/2024.
//

import SwiftUI

struct AgePicker: View {
    @Binding var selectedAge: Int
    @Binding var validationMessage: String
    @State private var isPickerPresented = false
    private let minimumAge = 18
    private let ages = Array(18...100)
    
    private func validateAge(){
        if selectedAge < minimumAge {
            validationMessage = "Age cannot be less than \(minimumAge)"
        } else {
            validationMessage = ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Your Age")
                .font(.footnote)
                .padding(.bottom, 5)
            
            Button(action: {
                isPickerPresented.toggle()
            }) {
                HStack {
                    Text("Age: \(selectedAge)")
                        .font(.footnote)
                        .foregroundColor(.black)
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
                    Picker("Age", selection: $selectedAge) {
                        ForEach(ages, id: \.self) { age in
                            Text("\(age)").tag(age)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                    
                    Button("Done") {
                        isPickerPresented = false
                        validateAge()
                    }
                    .padding()
                }
                .padding()
            }
            
            Text(validationMessage)
                .foregroundColor(.red)
                .font(.footnote)
                .padding(.top, 5)
        }
        .onChange(of: selectedAge) { newValue in
            validateAge()
        }
    }
}

#Preview {
    AgePicker(selectedAge: .constant(18), validationMessage: .constant(""))
}

//
//  CustomPicker.swift
//  datingApp
//
//  Created by Balogun Kayode on 14/08/2024.
//

import SwiftUI

struct CustomPicker: View {
    @Binding var value: String
    @State private var modalPresented: Bool = false
    
    let label: String
    let data: [String]

    
    var body: some View {
        // Gender Picker
        VStack(alignment: .leading) {
            Text(label)
                .font(.footnote)
                .padding(.bottom, 5)
            
            Button(action: {
                modalPresented.toggle()
            }) {
                HStack {
                    Text(value.isEmpty ? label : value)
                        .font(.footnote)
                        .foregroundColor(value.isEmpty ? .gray : .black)
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
            .sheet(isPresented: $modalPresented) {
                VStack {
                    Picker(label, selection: $value) {
                        ForEach(data, id: \.self) { interest in
                            Text(interest).tag(interest)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                    
                    Button("Done") {
                        modalPresented = false
                    }
                    .padding()
                }
                .padding()
            }
        }

    }
   
}

//
//  HeadlineTextView.swift
//  datingApp
//
//  Created by Balogun Kayode on 30/07/2024.
//

import SwiftUI

struct HeadlineTextView: View {
    var body: some View {
        HStack {
            Text("It ")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.regular) +
            Text("Starts ")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.bold) +
            
            Text("with")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.regular)
        }
        
        HStack {
            Text("a")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.regular) +
            
            Text(" Swipe")
                .foregroundColor(.white)
                .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .multilineTextAlignment(.center)
            }
        }

#Preview {
    HeadlineTextView()
}

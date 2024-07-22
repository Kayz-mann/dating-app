//
//  SwipeActionIndicatorView.swift
//  datingApp
//
//  Created by Balogun Kayode on 22/07/2024.
//

import SwiftUI

struct SwipeActionIndicatorView: View {
    let sizeConstants = SizeConstants()
    
    @Binding var xOffset: CGFloat
    
    var body: some View {
        HStack {
            Text("LIKE")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundStyle(.green)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.green, lineWidth: 2)
                        .frame(width: 100, height: 48)
                }
            //negative -- float left
                .rotationEffect(.degrees(-45))
                .opacity(Double(xOffset / sizeConstants.screenCutOff))
            
            Spacer()
            
            Text("NOPE")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundStyle(.red)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.red, lineWidth: 2)
                        .frame(width: 100, height: 48)
                }
                //positive float right
                .rotationEffect(.degrees(45))
                .opacity(Double(xOffset / sizeConstants.screenCutOff) * -1)


        }
        .padding(48)
    }
}

#Preview {
    SwipeActionIndicatorView(xOffset: .constant(20))
}

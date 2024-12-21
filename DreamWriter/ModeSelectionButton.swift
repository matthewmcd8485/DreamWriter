//
//  ModeSelectionButton.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI

struct ModeSelectionButton: View {
    var symbolName: String = "brain"
    var title = "Title"
    var subtitle = "Subtitle"
    
    var body: some View {
        ZStack {
            BackgroundView(color: .lightNavy, rounded: true, radius: 15)
            
            HStack {
                Image(systemName: symbolName)
                    .font(.system(size: 30))
                    .foregroundStyle(.mediumBlue)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 15, weight: .light))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.mediumBlue)
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)

    }
}

#Preview {
    HomeTabView()
}

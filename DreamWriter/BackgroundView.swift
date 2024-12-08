//
//  BackgroundView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI

struct BackgroundView: View {
    
    var color: Color
    var rounded = true
    var radius: CGFloat = 25
    
    // Initalizer with standard Color
    init(color: Color, rounded: Bool = false, radius: CGFloat = 25) {
        self.color = color
        self.rounded = rounded
        self.radius = radius
    }
    
    // Initalizer with UIColor
    init(uiColor: UIColor, rounded: Bool = false, radius: CGFloat = 25) {
        color = Color(uiColor: uiColor)
        self.rounded = rounded
        self.radius = radius
    }
    
    var body: some View {
        if rounded {
            Rectangle()
                .fill(color)
                .clipShape(RoundedRectangle(cornerRadius: radius))

        } else {
            Rectangle()
                .fill(color)
                .ignoresSafeArea(.all)
        }
        
    }
}

#Preview {
    BackgroundView(color: .red)
}

//
//  VisualizerView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 30/05/2024.
//

import SwiftUI

struct VisualizerView: View {
    
    @Binding var isVisualizing: Bool
    
    var body: some View {
        HStack {
            ForEach(0 ..< 18) { item in
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 5, height: .random(in: isVisualizing ? 2...200 : 5...90))
                    .animation(.easeInOut(duration: 0.25).repeatForever(autoreverses: true), value: isVisualizing)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    VisualizerView(isVisualizing: .constant(false))
}

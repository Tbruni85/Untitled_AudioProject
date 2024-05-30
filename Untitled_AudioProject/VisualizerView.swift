//
//  VisualizerView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 30/05/2024.
//

import SwiftUI

struct VisualizerView: View {
    
    enum LineType: Int {
        case mini = 5
        case large = 18
        
        var minRange: Range<CGFloat> {
            switch self {
            case .large:
                Range<CGFloat>(uncheckedBounds: (lower: 5, upper: 90))
            case .mini:
                Range<CGFloat>(uncheckedBounds: (lower: 2, upper: 20))
            }
        }
        
        var maxRange: Range<CGFloat> {
            switch self {
            case .large:
                Range<CGFloat>(uncheckedBounds: (lower: 2, upper: 200))
            case .mini:
                Range<CGFloat>(uncheckedBounds: (lower: 5, upper: 35))
            }
        }
        
        var width: CGFloat {
            switch self {
            case .large:
                5
            case .mini:
                2
            }
        }
        
        var spacing: CGFloat {
            switch self {
            case .large:
                10
            case .mini:
                2
            }
        }
    }
    
    var isVisualizing: Bool
    var nLines: LineType
    
    var body: some View {
        HStack(spacing: nLines.spacing) {
            ForEach(0 ..< nLines.rawValue) { item in
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: nLines.width, height: .random(in: isVisualizing ? nLines.maxRange : nLines.minRange))
                    .animation(.easeInOut(duration: 0.25).repeatForever(autoreverses: true), value: isVisualizing)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    VisualizerView(isVisualizing: true, nLines: .large)
}

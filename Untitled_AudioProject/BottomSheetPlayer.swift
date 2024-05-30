//
//  BottomSheetPlayer.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 30/05/2024.
//

import SwiftUI

struct BottomSheetPlayer: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    var body: some View {
        ZStack {
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.ultraThickMaterial)
                    .frame(height: 70)
                    .overlay {
                        MusicInfo(expandSheet: $expandSheet,
                                  animation: animation)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
        }
    }
}

#Preview {
    ContentView()
}

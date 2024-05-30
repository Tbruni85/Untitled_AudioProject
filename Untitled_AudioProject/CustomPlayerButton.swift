//
//  CustomPlayerButton.swift
//  MusicPlayer
//
//  Created by Tiziano Bruni on 28/05/2024.
//

import SwiftUI

struct CustomPlayerButton: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    private struct Constants {
        static var transparencyMaxValue: CGFloat = 0.6
        static var transparencyMinValue: CGFloat = 0.0
    }
    
    @State var transparency: CGFloat = Constants.transparencyMinValue
    
    let dropSize: CGFloat
    let iconWeight: CGFloat
    
    var body: some View {
        Button {
            viewModel.playOrPause()
            transparency = Constants.transparencyMaxValue
            withAnimation(.easeOut(duration: 0.2)) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    transparency = Constants.transparencyMinValue
                }
            }
        } label: {
            ZStack {
                Circle()
                    .frame(width: dropSize, height: dropSize)
                    .opacity(transparency)
                    .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: transparency)
                
                Image(systemName: "pause.fill")
                    .font(.system(size: iconWeight))
                    .scaleEffect(viewModel.isPlaying ? 1 : 0)
                    .opacity(viewModel.isPlaying ? 1 : 0)
                    .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: viewModel.isPlaying)
                
                Image(systemName: "play.fill")
                    .font(.system(size: iconWeight))
                    .scaleEffect(viewModel.isPlaying ? 0 : 1)
                    .opacity(viewModel.isPlaying ? 0 : 1)
                    .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: viewModel.isPlaying)
            }
        }
    }
}

#Preview {
    EmptyView()
}

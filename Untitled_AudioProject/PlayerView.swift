//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Tiziano Bruni on 26/05/2024.
//

import SwiftUI

struct PlayerView: View {
    
    @EnvironmentObject var audioViewModel: ViewModel
    
    private struct Constants {
        static var spacingScale: CGFloat = 0.04
        
        static func playerButtonFont(size: CGSize) -> Font {
            size.height < 300 ? .title3 : .title
        }
        
        static func playerMainButtonFont(size: CGSize) -> Font {
            size.height < 300 ? .largeTitle : .system(size: 50)
        }
    }
    
    var mainSize: CGSize
    
    var body: some View {
        GeometryReader { proxy in
            
            Text(audioViewModel.currentTime + "/" + audioViewModel.trackLength)
                .font(.caption)
                .foregroundColor(.gray)
               // .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: proxy.size.width * 0.18) {
                Button {
                    audioViewModel.backwardTrack()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(Constants.playerButtonFont(size: proxy.size))
                }
                .buttonRepeatBehavior(.enabled)
                .foregroundColor(.primary)
                
                CustomPlayerButton(dropSize: 85, iconWeight: 60)
                    .tint(.primary)
                
                Button {
                    audioViewModel.forwardTrack()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(Constants.playerButtonFont(size: proxy.size))
                }
                .buttonRepeatBehavior(.enabled)
                .foregroundColor(.primary)
            }
        }
        .padding()
    }
}

#Preview {
    PlayerView(mainSize: CGSize(width: 200, height: 450))
}

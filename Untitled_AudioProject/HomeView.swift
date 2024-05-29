//
//  HomeView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import SwiftUI

struct HomeView: View {
    
    private let colums = Array(repeating: GridItem(.fixed(175)), count: 2)
    
    @State var recoderVisible = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: colums, content: {
                    ProjectView(project: Project(name: "Test 1", fileName: "adas"))
                    ProjectView(project: Project(name: "Jammable", fileName: "adas123"))
                })
            }
            .toolbar(content: {
                Button(action: {
                    recoderVisible.toggle()
                }, label: {
                    Image(systemName: "plus.app")
                        .tint(.primary)
                })
            })
            .padding()
            .navigationTitle("Projects")
            .sheet(isPresented: $recoderVisible, content: {
                RecorderView()
            })
        }
    }
}

#Preview {
    HomeView()
}

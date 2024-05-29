//
//  ContentView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.audios, id: \.self) { audio in
                        Text(audio.relativeString)
                    }
                }
                
                Button(action: {
                    do {
                        if viewModel.record {
                            viewModel.stopRecording()
                            return
                        }
                        
                        try viewModel.startRecording(withName: "asdasd1")
                        viewModel.record.toggle()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }, label: {
                    ZStack {
                        Circle()
                            .fill(.red)
                            .frame(width: 70, height: 70)
                        
                        if viewModel.record {
                            Circle()
                                .stroke(.white, lineWidth: 6)
                                .frame(width: 85, height: 85)
                        }
                    }
                })
                .padding(.vertical, 25)
            }
            .navigationTitle("Create new project")
        }
        .alert(isPresented: $viewModel.alert, content: {
            Alert(title: Text("Error"),
                  message: Text("Enable access to the microphone"))
        })
        .onAppear {
            viewModel.requestPermission()
        }
    }
}

#Preview {
    ContentView()
}

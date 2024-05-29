//
//  RecorderView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import SwiftUI

struct RecorderView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var projectName: String = ""
    @State private var noName = true
    
    var body: some View {
        VStack {
            Text("Create a new project")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)
            Spacer()
            
            Button(action: {
                
                do {
                    if viewModel.record {
                        viewModel.stopRecording()
                        presentationMode.wrappedValue.dismiss()
                        return
                    }
                    
                    try viewModel.startRecording(withName: projectName)
                    viewModel.record.toggle()
                } catch {
                    print(error.localizedDescription)
                }
                
            }, label: {
                ZStack {
                    Circle()
                        .fill(noName ? .red.opacity(0.5) : .red)
                        .frame(width: 70, height: 70)
                    
                    if viewModel.record {
                        Circle()
                            .stroke(.white, lineWidth: 6)
                            .frame(width: 85, height: 85)
                    }
                }
            })
            .padding(.vertical, 25)
            .disabled(noName)
        }
        .alert("Give a name to your project", isPresented: $noName) {
            TextField("Untitled", text: $projectName)
            Button("OK", action: submit)
                .disabled(projectName == "")
        } message: {}
        .onAppear {
            viewModel.requestPermission()
        }
    }
    
    func submit() {
        noName.toggle()
    }
}

#Preview {
    EmptyView()
}

//
//  RecorderView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import SwiftUI
import AVKit

struct RecorderView: View {
    
    @State var record = false
    @State var session: AVAudioSession!
    @State var recorder: AVAudioRecorder!
    @State var alert = false
    @State var audios: [URL] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    ForEach(audios, id: \.self) { audio in
                        Text(audio.relativeString)
                    }
                }
                
                Button(action: {
                    do {
                        
                        if record {
                            recorder.stop()
                            record.toggle()
                            getAudios()
                            return
                        }
                        
                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileName = url.appendingPathComponent("myProject_\(audios.count + 1).m4a")
                        let settings = [
                            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 12000,
                            AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                        ]
                        
                        recorder = try AVAudioRecorder(url: fileName, settings: settings)
                        recorder.record()
                        record.toggle()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }, label: {
                    ZStack {
                        Circle()
                            .fill(.red)
                            .frame(width: 70, height: 70)
                        
                        if record {
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
        .alert(isPresented: $alert, content: {
            Alert(title: Text("Error"),
                  message: Text("Enable access to the microphone"))
        })
        .onAppear {
            do {
                session = AVAudioSession()
                try session.setCategory(.playAndRecord)
                AVAudioApplication.requestRecordPermission { status in
                    if !status {
                        alert.toggle()
                    } else {
                        getAudios()
                    }
                }
            } catch {
                
            }
        }
    }
    
    private func getAudios() {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            audios.removeAll()
            result.forEach { filePath in
                audios.append(filePath)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    RecorderView()
}

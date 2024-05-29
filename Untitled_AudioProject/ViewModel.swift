//
//  ViewModel.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import Foundation
import AVKit

class ViewModel: ObservableObject {
    
    @Published var projects: [Project] = []
    @Published var audios: [URL] = []
    @Published var alert = false
    @Published var named = false
    @Published var record = false
    
    private var session: AVAudioSession!
    private var recorder: AVAudioRecorder!
    
    func startRecording(withName name: String) throws {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = url.appendingPathComponent("\(name).m4a")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            recorder = try AVAudioRecorder(url: fileName, settings: settings)
            recorder.record()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func requestPermission() {
        do {
            session = AVAudioSession()
            try session.setCategory(.playAndRecord)
            AVAudioApplication.requestRecordPermission { [weak self] status in
                if !status {
                    self?.alert.toggle()
                } else {
                    self?.getAudios()
                }
            }
        } catch {
            
        }
    }
    
    func stopRecording() {
        recorder.stop()
        record.toggle()
        getAudios()
    }
    
    func getAudios() {
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


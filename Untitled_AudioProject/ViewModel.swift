//
//  ViewModel.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import Foundation
import AVKit

class ViewModel: ObservableObject {
    
    @Published var audios: [URL] = []
    @Published var alert = false
    @Published var named = false
    @Published var record = false
    
    @Published var isPlaying = false
    @Published var currentTime: String = "0:00"
    @Published var currentPercentage: CGFloat = 0
    
    private var audioPlayer: AVAudioPlayer!
    private var timer: Timer?
    
    var activeProject: URL?

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
                if filePath.relativePath.contains(".m4a") {
                    audios.append(filePath)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadTrack(projectURL: URL) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: projectURL)
                activeProject = projectURL
                audioPlayerPlayPause()
            } catch {
                print("AVAudioPlayer could not be instantiated.")
            }
    }
    
    func audioPlayerPlayPause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            isPlaying = false
            guard timer != nil else { return }
            timer?.invalidate()
            timer = nil
        } else {
            audioPlayer.play()
            isPlaying = true
            guard timer == nil else { return }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTrackTime), userInfo: nil, repeats: true)
        }
    }
    
    func playOrPause() {
        audioPlayerPlayPause()
    }
    
    func forwardTrack() {
        var timeForward = audioPlayer.currentTime
        timeForward += 5.0
        if timeForward < audioPlayer.duration {
            audioPlayer.currentTime = timeForward
            audioPlayer.play(atTime: timeForward)
            updateTrackTime()
        } else {
            audioPlayer.currentTime = audioPlayer.duration
            isPlaying = false
        }
    }
    
    func backwardTrack() {
        var timeForward = audioPlayer.currentTime
        timeForward -= 5.0
        if timeForward > 0 {
            audioPlayer.currentTime = timeForward
            audioPlayer.play(atTime: timeForward)
            updateTrackTime()
        } else {
            audioPlayer.currentTime = 0
        }
    }
    
    var trackLength: String {
        guard let audioPlayer = audioPlayer else {
            return  "--:--"
        }
        
        return String(format: "%02d:%02d", ((Int)(audioPlayer.duration)) / 60, ((Int)(audioPlayer.duration)) % 60)
    }
    
    @objc
    func updateTrackTime() {
        guard let audioPlayer = audioPlayer else {
            return
        }
        if audioPlayer.isPlaying {
            currentTime = String(format: "%02d:%02d", ((Int)(audioPlayer.currentTime)) / 60, ((Int)(audioPlayer.currentTime)) % 60)
            currentPercentage = CGFloat(audioPlayer.currentTime / audioPlayer.duration)
            if audioPlayer.currentTime == audioPlayer.duration {
                playOrPause()
            }
        }
    }
    
    var playerImage: String {
        "artwork_placeholder"
    }
    
    var currentArtist: String {
        "Unknown"
    }
    
    var currentSong: String {
        guard let project = activeProject else {
            return ""
        }
        return project.relativeString.replacingOccurrences(of: ".m4a", with: "")
    }
}


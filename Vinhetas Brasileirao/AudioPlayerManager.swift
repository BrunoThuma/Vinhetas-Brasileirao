import AVFoundation
import Foundation

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    var audioPlayer: AVAudioPlayer?
    
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("Could not cofigure AVAudioSession")
        }
    }
    
    func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue) //<- No `let`
            audioPlayer?.play()
            print("AudioPlayerManager:sound is playing")
        } catch let error {
            print("AudioPlayerManager:Sound Play Error -> \(error)")
        }
    }
    
    func play(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.m4a.rawValue)
            audioPlayer?.play()
            print("AudioPlayerManager:sound is playing")
        } catch let error {
            print("AudioPlayerManager:Sound Play Error -> \(error)")
        }
    }
}

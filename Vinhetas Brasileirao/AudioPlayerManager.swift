import AVFoundation

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    var audioPlayer: AVAudioPlayer?
    
    private init() {
    }
    
    func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue) //<- No `let`
            audioPlayer?.play()
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

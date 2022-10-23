//
//  PadsView.swift
//  Vinhetas Brasileirao
//
//  Created by Bruno Thuma on 17/10/22.
//

import SwiftUI
import AVFoundation

struct PadsView: View {
    
    private var audioPlayerManager: AudioPlayerManager = AudioPlayerManager.shared
    private let persistenceManager: FilesPersistence = FilesPersistence()
    
    @State private var myText: String?
    @State private var downloadedFileURL: URL!
    
    var body: some View {
        VStack {
            Text(myText ?? "Hello, World!")
            Button("Download") {
                persistenceManager.downloadAudioFromFirebase(
                    forRelativeLocalPath: "audios/coritiba.m4a",
                    forRemotePath: "audios/coritiba.m4a",
                    completion: didSaveFile)
            }.buttonStyle(.borderedProminent)
            Button("Play Downloaded") {
                playAudio(fromUrl: downloadedFileURL)
            }.buttonStyle(.borderedProminent)
//            Button("Play From Memory") {
//                playFromMemory()
//                print("is asynchronous")
//            }.buttonStyle(.borderedProminent)
            Button("Clear") {
                persistenceManager.clearDocumentsFolder()
            }
            .buttonStyle(.bordered)
            .foregroundColor(.red)
        }
    }
    
    func didSaveFile(toUrl url: URL) {
        downloadedFileURL = url
        myText = "ok"
    }
    
    private func playAudio(fromUrl url: URL) {
        audioPlayerManager.play(url: url)
        print("Succesfully played audio")
    }
}

struct PadsView_Previews: PreviewProvider {
    static var previews: some View {
        PadsView()
    }
}

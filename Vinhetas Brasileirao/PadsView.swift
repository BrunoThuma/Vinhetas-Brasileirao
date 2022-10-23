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
    @State private var downloadedTeams: [TeamsModel] = []
    @State private var remoteTeams: [TeamsModel] = []
    
    var body: some View {
        VStack {
            Text(myText ?? "Hello, World!")
            Button("Download") {
                persistenceManager.downloadAudioFromFirebase(
                    forRelativeLocalPath: "audios/coritiba.m4a",
                    forRemotePath: "audios/coritiba.m4a",
                    completion: didSaveFile)
            }
                .buttonStyle(.borderedProminent)
            Button("Play Downloaded") {
                if downloadedTeams.count > 0 {
                    playAudio(fromUrl: downloadedTeams[0].audioLocalAbsoluteUrl!)
                } else {
                    myText = "No files to be played locally"
                }
                
            }
                .buttonStyle(.borderedProminent)
            Button("List Downloaded") {
                _ = getDownloadedUrlsList()
            }
                .buttonStyle(.borderedProminent)
            Button("Clear") {
                persistenceManager.clearDocumentsFolder()
                myText = "Cleaned all files in documents folder"
            }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
        }.onAppear(perform: fetchDownloadedTeams)
    }
    
    func didSaveFile(toUrl url: URL) {
        downloadedFileURL = url
        myText = "Successfully downloaded \(url.lastPathComponent)"
        fetchDownloadedTeams()
    }
    
    private func playAudio(fromUrl url: URL) {
        audioPlayerManager.play(url: url)
        print("Succesfully played audio")
    }
    
    private func fetchDownloadedTeams() {
        let audiosUrls: [URL] = persistenceManager.getDownloadedAudios()
        
        for audioUrl in audiosUrls {
            let teamName = audioUrl.deletingPathExtension().lastPathComponent
            
            var team = TeamsModel(name: teamName)
            team.audioLocalAbsoluteUrl = audioUrl
            team.audioLocalRelativePath = audioUrl.relativePath
            print("fetched \(teamName) saved at \(team.audioLocalRelativePath ?? "")")
            self.downloadedTeams.append(team)
        }
    }
    
    private func getDownloadedUrlsList() -> [URL] {
        let audiosUrls: [URL] = persistenceManager.getDownloadedAudios()
        
        myText = "Listing audios in documents/audios \n"
        
        for audioUrl in audiosUrls {
            myText! += "\(audioUrl.deletingPathExtension().lastPathComponent) \n"
        }
        
        return audiosUrls
    }
}

struct PadsView_Previews: PreviewProvider {
    static var previews: some View {
        PadsView()
    }
}

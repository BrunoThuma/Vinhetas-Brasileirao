//
//  PadsView.swift
//  Vinhetas Brasileirao
//
//  Created by Bruno Thuma on 17/10/22.
//

import SwiftUI
import FirebaseStorage
import AVFoundation

struct PadsView: View {
    private var storage: Storage = {
        return Storage.storage()
    } ()
    
    private let fmDefault = FileManager.default
    private let documentsDirectory: URL = {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    } ()
    private var audioPlayerManager = AudioPlayerManager.shared
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var myText: String?
    @State private var downloadedFileURL: URL!
    
    var body: some View {
        VStack {
            Text(myText ?? "Hello, World!")
            Button("Download") {
                storeAudioFromFirebase()
            }.buttonStyle(.borderedProminent)
            Button("Play Downloaded") {
                storeAudioFromFirebase()
                playAudio(withFileName: "paysandu.m4a")
            }.buttonStyle(.borderedProminent)
            Button("Play From Memory") {
                playFromMemory()
                print("is asynchronous")
            }.buttonStyle(.borderedProminent)
            Button("Clear") {
                clearDocumentsFolder()
            }
            .buttonStyle(.bordered)
            .foregroundColor(.red)
        }
    }
    
    private func clearDocumentsFolder() {
        let contents: [URL] = listContentsOfDirectory()
        do {
            print("removing \(contents.count) items from documents directory")
            for c in contents {
                try fmDefault.removeItem(at: c)
            }
        } catch {
            print("error")
        }
    }
    
    private func playFromMemory() {
        // Create a reference to the file you want to download
        let rootFolderRef = storage.reference()
        let audioFileRef = rootFolderRef.child("audios/paysandu.m4a")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        audioFileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                audioPlayerManager.play(data: data!)
            }
        }
    }
    
    private func listContentsOfDirectory() -> [URL] {
        guard let documentsDirectory = fmDefault.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }

        do {
            let directoryContents = try fmDefault.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])

            // Print the urls of the files contained in the documents directory
            print(directoryContents)
            return directoryContents
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }
        return []
    }
    
    private func storeAudioFromFirebase() {
        let localFileURL = documentsDirectory.appending(path: "audios/paysandu.m4a", directoryHint: .notDirectory)
        print("localFileURL.path \(localFileURL.path())")
        
        var fileExists: Bool = fmDefault.fileExists(atPath: localFileURL.path())
        
        let rootFolderRef = storage.reference()
        let audioFileRef = rootFolderRef.child("audios/paysandu.m4a")
        
        if !fileExists {
            downloadedFileURL = downloadFile(
                fromRef: audioFileRef,
                toURL: localFileURL)
        } else {
            downloadedFileURL = localFileURL
            print("File already exists")
        }
    }
    
    @discardableResult private func downloadFile(fromRef fileRef: StorageReference, toURL url: URL) -> URL? {
        
        var localURL: URL? = nil
        
        fileRef.write(toFile: url) { result in
            switch result {
            case .success(let success):
                localURL = success
                print("Successfully downloaded to \(localURL?.description ?? "")")
                DispatchQueue.main.async() {
                    self.myText = localURL?.description ?? ""
                    downloadedFileURL = localURL!
                }
            case .failure(let failure):
                print("Error while downloading audio to local storage: \(failure)")
            }
        }
        return localURL
    }
    
    private func playAudio(fromUrl url: URL) {
        audioPlayerManager.play(url: url)
        print("Succesfully played audio")
    }
    
    private func playAudio(withFileName name: String) {
        let mountedUrl = documentsDirectory.appending(path: "audios/\(name)")
        audioPlayerManager.play(url: mountedUrl)
    }
}

struct PadsView_Previews: PreviewProvider {
    static var previews: some View {
        PadsView()
    }
}

import Foundation

struct FilesPersistence {
    
    private let firebaseStorage = FirebaseModule()
    private let fmDefault = FileManager.default
    private let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func downloadAudioFromFirebase(forRelativeLocalPath localPath: String, forRemotePath remotePath: String, completion: @escaping (URL) -> Void) {
        
        let localFileURL = documentsDirectory.appending(
            path: localPath,
            directoryHint: .notDirectory)
        
        var fileExists: Bool = fmDefault.fileExists(atPath: localFileURL.path())
        
        if !fileExists {
            firebaseStorage.downloadFile(
                inPath: remotePath,
                toURL: localFileURL,
                completion: completion)
        } else {
            completion(localFileURL)
            print("File already exists")
        }
    }
    
    func clearDocumentsFolder() {
        let contents: [URL] = listContentsOfDirectory()
        do {
            print("removing \(contents.count) items from documents directory")
            if !contents.isEmpty {
                
                for c in contents {
                    try fmDefault.removeItem(at: c)
                }
            }
            
        } catch {
            print("error")
        }
    }
    
    private func listContentsOfDirectory() -> [URL] {
        guard let documentsDirectory = fmDefault.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }

        do {
            let directoryContents = try fmDefault.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            return directoryContents
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }
        return []
    }
}

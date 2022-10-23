import Foundation

struct FilesPersistence {
    
    private let firebaseStorage = FirebaseModule()
    private let fmDefault = FileManager.default
    private let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    
    func getDocumentsFolderUrl() -> URL {
        return documentsDirectory
    }
    
    func getAbsoluteUrl(forRelativePath path: String) -> URL {
        return documentsDirectory.appending(path: path)
    }
    
    func downloadAudioFromFirebase(forRelativeLocalPath localPath: String, forRemotePath remotePath: String, completion: @escaping (URL) -> Void) {
        
        let localFileURL = documentsDirectory.appending(
            path: localPath,
            directoryHint: .notDirectory)
        
        let fileExists: Bool = fileExistsLocaly(atRelativePath: localPath)
        
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
    
    func fileExistsLocaly(atRelativePath path: String) -> Bool {
        let localFileUrl = documentsDirectory.appending(
            path: path,
            directoryHint: .notDirectory)
        
        return fmDefault.fileExists(atPath: localFileUrl.path())
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
    
    func getDownloadedAudios() -> [URL] {
        listContentsOfDirectory(relativePath: "audios/")
    }
    
    func getDownloadedImages() -> [URL] {
        listContentsOfDirectory(relativePath: "images/")
    }
    
    private func listContentsOfDirectory(relativePath: String? = nil) -> [URL] {
        guard let documentsDirectory = fmDefault.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }

        do {
            let directoryContents: [URL]
            if let path = relativePath {
                let specifiedDirectory = documentsDirectory.appending(path: path, directoryHint: .isDirectory)
                directoryContents = try fmDefault.contentsOfDirectory(at: specifiedDirectory, includingPropertiesForKeys: nil, options: [])
            } else {
                directoryContents = try fmDefault.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            }
            
            return directoryContents
            
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }
        return []
    }
}

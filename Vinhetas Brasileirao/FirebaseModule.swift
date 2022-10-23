import FirebaseStorage
import Foundation

struct FirebaseModule {
    
    private var rootStorageRef: StorageReference = {
        return Storage.storage().reference()
    } ()
    
    func fetchFileData(pathInFirebase path: String) -> Data? {
        // Create a reference to the file you want to download
        let fileRef = rootStorageRef.child(path)
        
        var resultData: Data?
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        fileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                resultData = data
            }
        }
        
        fileRef.getData(maxSize: 1 * 1024 * 1024) { result in
            switch result {
            case .success(let withData):
                resultData = withData
            case .failure(let error):
                print(error)
            }
        }
        
        return resultData
    }
    
    func downloadFile(inPath path: String, toURL url: URL, completion: @escaping (URL) -> Void) {
        
        let fileReference: StorageReference = rootStorageRef.child(path)
        
        fileReference.write(toFile: url) { result in
            switch result {
            case .success(let successData):
                completion(successData)
            case .failure(let error):
                print("Error while downloading audio to local storage: \(error)")
            }
        }
    }
    
    func listItemsIn(directory: String, completion: () -> Void) {
        let storageReference = rootStorageRef.child(directory)
        
        let itemsList: [String] = []
        
        storageReference.listAll { (result, error) in
            if let error = error {
                print("Error listing items in remote directory \(directory): \(error)")
            } else if result != nil && error == nil {
                let items = result!.items
                
            }
            
        }
    }
}

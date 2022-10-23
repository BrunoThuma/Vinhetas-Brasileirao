import Foundation

enum ContentsDirectories {
    case audios
    case images
    
    func relativePath(fileName: String) -> String {
        switch self {
        case .audios:
            return "audios/\(fileName).m4a"
        case .images:
            return "images/\(fileName).jpeg"
        }
    }
    
    func absoluteUrl(fileName: String) -> URL {
        return FilesPersistence().getAbsoluteUrl(forRelativePath: relativePath(fileName: fileName))
    }
}

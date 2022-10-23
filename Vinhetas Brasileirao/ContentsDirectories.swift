enum ContentsDirectories {
    case audios
    case images
    
    var relativePath: String {
        switch self {
        case .audios:
            return "audios/"
        case .images:
            return "images/"
        }
    }
}

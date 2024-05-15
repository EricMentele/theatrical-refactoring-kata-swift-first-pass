struct Play {
    let name: String
    let genre: Genre
}

extension Play {
    enum Genre: String {
        case tragedy
        case comedy
        case unknown
        
        init?(type: String) {
            switch type.lowercased() {
            case "tragedy":
                self = .tragedy
            case "comedy":
                self = .comedy
            default:
                self = .unknown
            }
        }
    }
}

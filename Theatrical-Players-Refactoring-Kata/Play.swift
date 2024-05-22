struct Play {
    let name: String
    let genre: Genre
}

extension Play {
    enum Genre: String, CaseIterable {
        case tragedy
        case comedy
        case pastoral
        case unknown
        
        init?(type: String) {
            switch type.lowercased() {
            case "tragedy":
                self = .tragedy
            case "comedy":
                self = .comedy
            case "pastoral":
                self = .pastoral
            default:
                self = .unknown
            }
        }
    }
}

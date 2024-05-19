struct Performance {
    let playID: String
    let audience: Int
    
    var charge: PerformanceCharge
    
    var cost: Int?
    var volumeCredits: Int?
    
    init(playID: String, audience: Int, charge: PerformanceCharge = .init(playName: "Placeholder", cost: 0), play: Play? = nil, cost: Int? = nil, volumeCredits: Int? = nil) {
        self.playID = playID
        self.audience = audience
        self.charge = charge
        self.cost = cost
        self.volumeCredits = volumeCredits
    }
}

struct PerformanceCharge {
    let playName: String
    let cost: Int
}

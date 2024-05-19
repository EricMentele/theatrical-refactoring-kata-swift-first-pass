struct Performance {
    let playID: String
    let audience: Int
    
    var charge: PerformanceCharge
    
    var volumeCredits: Int?
    
    init(
        playID: String,
        audience: Int,
        charge: PerformanceCharge = PerformanceCharge(playName: "Placeholder", cost: 0),
        volumeCredits: Int? = nil
    ) {
        self.playID = playID
        self.audience = audience
        self.charge = charge
        self.volumeCredits = volumeCredits
    }
}

struct PerformanceCharge {
    let playName: String
    let cost: Int
}

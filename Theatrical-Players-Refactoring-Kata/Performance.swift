struct Performance {
    let playID: String
    let audience: Int
    
    var charge: PerformanceCharge
    
    init(
        playID: String,
        audience: Int,
        charge: PerformanceCharge = PerformanceCharge(
            playName: "Placeholder",
            cost: 0,
            volumeCredits: 0,
            attendanceCount: 0)
    ) {
        self.playID = playID
        self.audience = audience
        self.charge = charge
    }
}

struct PerformanceCharge {
    let playName: String
    let cost: Int
    let volumeCredits: Int
    let attendanceCount: Int
}

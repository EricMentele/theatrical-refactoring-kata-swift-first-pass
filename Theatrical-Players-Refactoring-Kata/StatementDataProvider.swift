func generateStatementData(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> StatementData {
    return StatementData(
        customer: invoice.customer,
        performanceCharges: try invoice.performances.map(charge),
        totalAmount: try invoice.performances.map(charge).map { $0.cost }.sum,
        totalVolumeCredits: try invoice.performances.map(charge).map { $0.volumeCredits }.sum
    )
    
    func charge(_ performance: Performance) throws -> PerformanceCharge {
        .init(
            playName: try play(for: performance.playID).name,
            cost: try costFor(
                try play(for: performance.playID).genre,
                attendanceCount: performance.audience),
            volumeCredits: volumeCreditsFor(try play(for: performance.playID).genre, attendanceCount: performance.audience),
            attendanceCount: performance.audience
        )
    }
    
    func play(for playId: String) throws -> Play {
        guard let result = plays[playId] else {
            throw UnknownTypeError.unknownTypeError("unknown play")
        }
        return result
    }
    
    func costFor(_ genre: Play.Genre, attendanceCount: Int) throws -> Int {
        var result = 0
        
        switch(genre) {
        case .tragedy:
            result = 40000
            if (attendanceCount > 30) {
                result += 1000 * (attendanceCount - 30)
            }
        case .comedy:
            result = 30000
            if (attendanceCount > 20) {
                result += 10000 + 500 * (attendanceCount - 20)
            }
            result += 300 * attendanceCount
        case .unknown:
            throw UnknownTypeError.unknownTypeError("new play")
        }
        
        return result
    }
    
    func volumeCreditsFor(_ genre: Play.Genre, attendanceCount: Int) -> Int {
        var result = 0
        result += max(attendanceCount - 30, 0)
        
        if (.comedy == genre) {
            result += Int(round(Double(attendanceCount / 5)))
        }
        return result
    }
}

private extension Array where Element == Int {
    var sum: Int {
        self.reduce(0) { $0 + $1 }
    }
}

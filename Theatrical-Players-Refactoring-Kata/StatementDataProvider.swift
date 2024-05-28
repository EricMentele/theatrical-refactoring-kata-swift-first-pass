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
                attendanceCount: performance.audience
            ),
            volumeCredits: volumeCreditsFor(
                try play(for: performance.playID).genre,
                attendanceCount: performance.audience
            ),
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
        try LineItemProvider().cost(for: genre).amountFor(attendanceCount: attendanceCount)
    }
    
    func volumeCreditsFor(_ genre: Play.Genre, attendanceCount: Int) -> Int {
        LineItemProvider().volumeCredits(for: genre).amountFor(attendanceCount: attendanceCount)
    }
}

private extension Array where Element == Int {
    var sum: Int {
        self.reduce(0) { $0 + $1 }
    }
}

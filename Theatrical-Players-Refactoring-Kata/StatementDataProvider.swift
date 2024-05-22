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
        try PerformanceCostProvider().cost(for: genre).amountFor(attendanceCount: attendanceCount)
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

protocol PerformanceCost {
    func amountFor(attendanceCount count: Int) -> Int
}

struct PerformanceCostProvider {
    func cost(for genre: Play.Genre) throws -> PerformanceCost {
        switch(genre) {
        case .tragedy:
            return TragedyPerformanceCost()
        case .comedy:
            return ComedyPerformanceCost()
        case .unknown:
            throw UnknownTypeError.unknownTypeError("new play")
        }
    }
    
    struct TragedyPerformanceCost: PerformanceCost {
        func amountFor(attendanceCount count: Int) -> Int {
            let baseVolume = 30
            let exceededBaseVolume = count > baseVolume
            let additionalVolumeCost = exceededBaseVolume ? 1000 * (count - baseVolume) : 0
            return 40000 + additionalVolumeCost
        }
    }
    
    struct ComedyPerformanceCost: PerformanceCost {
        func amountFor(attendanceCount count: Int) -> Int {
            let baseVolume = 20
            let exceededBaseVolume = count > baseVolume
            let additionalVolumeCost = exceededBaseVolume ? 10000 + 500 * (count - baseVolume) : 0
            return 30000 + additionalVolumeCost + 300 * count
        }
    }
}

private extension Array where Element == Int {
    var sum: Int {
        self.reduce(0) { $0 + $1 }
    }
}

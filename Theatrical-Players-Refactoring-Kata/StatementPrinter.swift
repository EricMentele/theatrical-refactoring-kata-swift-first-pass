class StatementPrinter {
    struct StatementData {
        let customer: String
        let performanceCharges: [PerformanceCharge]
        let totalAmount: Int
        let totalVolumeCredits: Int
    }
    
    func generateStatement(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> String {
        return try renderPlainText(generateStatementData(invoice, plays))
    }
    
    private func generateStatementData(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> StatementData {
        return StatementData(
            customer: invoice.customer,
            performanceCharges: try invoice.performances.map(charge),
            totalAmount: totalOf(try invoice.performances.map(charge).map { $0.cost }),
            totalVolumeCredits: totalOf(try invoice.performances.map(charge).map { $0.volumeCredits })
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
                throw UnknownTypeError.unknownTypeError("unknown type: \(genre)")
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
        
        func totalOf(_ amounts: [Int]) -> Int {
            amounts.reduce(0) { $0 + $1 }
        }
    }
    
    private func renderPlainText(_ data: StatementData) throws -> String {
        var result = "Statement for \(data.customer)\n"
        
        for charge in data.performanceCharges {
            // print line for this order
            result += "  \(charge.playName): \(usd(amount: charge.cost)) (\(charge.attendanceCount) seats)\n"
        }
        
        result += "Amount owed is \(usd(amount: data.totalAmount))\n"
        result += "You earned \(data.totalVolumeCredits) credits\n"
        return result
        
        func usd(amount: Int) -> String {
            let frmt = NumberFormatter()
            frmt.numberStyle = .currency
            frmt.locale = Locale(identifier: "en_US")
            return frmt.string(for: NSNumber(value: Double(amount / 100)))!
        }
    }
}

enum UnknownTypeError: Error, Equatable {
    case unknownTypeError(String)
}

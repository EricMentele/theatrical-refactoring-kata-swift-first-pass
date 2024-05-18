class StatementPrinter {
    struct StatementData {
        let customer: String
        let performances: [Performance]
        let totalAmount: Int
        let totalVolumeCredits: Int
    }
    
    func generateStatement(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> String {
        return try renderPlainText(generateStatementData(invoice, plays))
    }
    
    private func generateStatementData(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> StatementData {
        return StatementData(
            customer: invoice.customer,
            performances: try invoice.performances.map(enrich),
            totalAmount: totalOf(try invoice.performances.map(enrich).map { $0.cost! }),
            totalVolumeCredits: totalOf(try invoice.performances.map(enrich).map { $0.volumeCredits! })
        )
        
        func enrich(_ performance: Performance) throws -> Performance {
            var result = performance
            result.play = try play(for: result.playID)
            result.cost = try costFor(result.play!.genre, attendanceCount: result.audience)
            result.volumeCredits = volumeCreditsFor(result.play!.genre, attendanceCount: result.audience)
            return result
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
        
        for performance in data.performances {
            // print line for this order
            result += "  \(performance.play!.name): \(usd(amount: performance.cost!)) (\(performance.audience) seats)\n"
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

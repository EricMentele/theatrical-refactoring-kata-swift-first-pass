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
            totalAmount: totalAmount(from: try invoice.performances.map(enrich)),
            totalVolumeCredits: totalVolumeCredits(from: try invoice.performances.map(enrich))
        )
        
        func enrich(_ performance: Performance) throws -> Performance {
            var result = performance
            result.play = try play(for: result.playID)
            result.cost = try amountFor(performance: result)
            result.volumeCredits = volumeCreditsFor(result)
            return result
        }
        
        func play(for playId: String) throws -> Play {
            guard let result = plays[playId] else {
                throw UnknownTypeError.unknownTypeError("unknown play")
            }
            return result
        }
        
        func amountFor(performance: Performance) throws -> Int {
            var result = 0
            
            switch(performance.play!.genre) {
            case .tragedy:
                result = 40000
                if (performance.audience > 30) {
                    result += 1000 * (performance.audience - 30)
                }
            case .comedy:
                result = 30000
                if (performance.audience > 20) {
                    result += 10000 + 500 * (performance.audience - 20)
                }
                result += 300 * performance.audience
            case .unknown:
                throw UnknownTypeError.unknownTypeError("unknown type: \(performance.play!.genre)")
            }
            
            return result
        }
        
        func totalVolumeCredits(from performances: [Performance]) -> Int {
            performances.reduce(0) { $0 + $1.volumeCredits! }
        }
        
        func volumeCreditsFor(_ performance: Performance) -> Int {
            var result = 0
            result += max(performance.audience - 30, 0)
            
            if (.comedy == performance.play!.genre) {
                result += Int(round(Double(performance.audience / 5)))
            }
            return result
        }
        
        func totalAmount(from performances: [Performance]) -> Int {
            performances.reduce(0) { $0 + $1.cost! }
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

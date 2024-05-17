class StatementPrinter {
    struct StatementData {
        let customer: String
        let performances: [Performance]
    }
    
    func generateStatement(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> String {
        let data = StatementData(
            customer: invoice.customer,
            performances: try invoice.performances.map(enrich)
        )
        
        return try renderPlainText(data, plays)
        
        func enrich(_ performance: Performance) throws -> Performance {
            var result = performance
            result.play = try play(for: result.playID)
            return result
        }
        
        func play(for playId: String) throws -> Play {
            guard let result = plays[playId] else {
                throw UnknownTypeError.unknownTypeError("unknown play")
            }
            return result
        }
    }
    
    private func renderPlainText(_ data: StatementData, _ plays: [String : Play]) throws -> String {
        var result = "Statement for \(data.customer)\n"
        
        for performance in data.performances {
            // print line for this order
            result += "  \(try play(for: performance.playID).name): \(usd(amount: (try amountFor(performance: performance)))) (\(performance.audience) seats)\n"
        }
        
        result += "Amount owed is \(usd(amount: try totalAmount()))\n"
        result += "You earned \(totalVolumeCredits()) credits\n"
        return result
        
        
        func totalAmount() throws -> Int {
            var result = 0
            for performance in data.performances {
                result += try amountFor(performance: performance)
            }
            return result
        }
        
        func totalVolumeCredits() -> Int {
            var result = 0
            for performance in data.performances {
                result += volumeCreditsFor(performance)
            }
            return result
        }
        
        func volumeCreditsFor(_ performance: Performance) -> Int {
            var result = 0
            result += max(performance.audience - 30, 0)
            
            if (.comedy == (try? play(for: performance.playID).genre)) {
                result += Int(round(Double(performance.audience / 5)))
            }
            return result
        }
        
        func usd(amount: Int) -> String {
            let frmt = NumberFormatter()
            frmt.numberStyle = .currency
            frmt.locale = Locale(identifier: "en_US")
            return frmt.string(for: NSNumber(value: Double(amount / 100)))!
        }
        
        func play(for performanceID: String) throws -> Play {
            guard let result = plays[performanceID] else {
                throw UnknownTypeError.unknownTypeError("unknown play")
            }
            return result
        }
        
        func amountFor(performance: Performance) throws -> Int {
            var result = 0
            
            switch(try play(for: performance.playID).genre) {
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
                throw UnknownTypeError.unknownTypeError("unknown type: \(try play(for: performance.playID).genre)")
            }
            
            return result
        }
    }
}

enum UnknownTypeError: Error, Equatable {
    case unknownTypeError(String)
}

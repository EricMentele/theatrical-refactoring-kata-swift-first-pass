class StatementPrinter {
    func generateStatement(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> String {
        var totalAmount = 0
        var volumeCredits = 0
        var result = "Statement for \(invoice.customer)\n"
        
        let frmt = NumberFormatter()
        frmt.numberStyle = .currency
        frmt.locale = Locale(identifier: "en_US")
        
        for performance in invoice.performances {
            let costOfPerformance = try amountFor(performance: performance, genre: try play(for: performance.playID).genre)
            
            // add volume credits
            volumeCredits += max(performance.audience - 30, 0)
            // add extra credit for every ten comedy attendees
            if (.comedy == (try? play(for: performance.playID).genre)) {
                volumeCredits += Int(round(Double(performance.audience / 5)))
            }
            
            // print line for this order
            result += "  \(try play(for: performance.playID).name): \(frmt.string(for: NSNumber(value: Double((costOfPerformance / 100))))!) (\(performance.audience) seats)\n"
            
            totalAmount += costOfPerformance
        }
        result += "Amount owed is \(frmt.string(for: NSNumber(value: Double(totalAmount / 100)))!)\n"
        result += "You earned \(volumeCredits) credits\n"
        return result
        
        func play(for performanceID: String) throws -> Play {
            guard let result = plays[performanceID] else {
                throw UnknownTypeError.unknownTypeError("unknown play")
            }
            return result
        }
        
        func amountFor(performance: Performance, genre: Play.Genre) throws -> Int {
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
                throw UnknownTypeError.unknownTypeError("unknown type: \(genre)")
            }
            
            return result
        }
    }
}

enum UnknownTypeError: Error, Equatable {
    case unknownTypeError(String)
}

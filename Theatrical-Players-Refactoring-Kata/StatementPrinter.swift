class StatementPrinter {
    func generateStatement(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> String {
        var totalAmount = 0
        var volumeCredits = 0
        var result = "Statement for \(invoice.customer)\n"
        
        let frmt = NumberFormatter()
        frmt.numberStyle = .currency
        frmt.locale = Locale(identifier: "en_US")
        
        for performance in invoice.performances {
            guard let play = plays[performance.playID] else {
                throw UnknownTypeError.unknownTypeError("unknown play")
            }
            
            let costOfPerformance = try amountFor(performance: performance, genre: play.genre)
            
            // add volume credits
            volumeCredits += max(performance.audience - 30, 0)
            // add extra credit for every ten comedy attendees
            if (.comedy == play.genre) {
                volumeCredits += Int(round(Double(performance.audience / 5)))
            }
            
            // print line for this order
            result += "  \(play.name): \(frmt.string(for: NSNumber(value: Double((costOfPerformance / 100))))!) (\(performance.audience) seats)\n"
            
            totalAmount += costOfPerformance
        }
        result += "Amount owed is \(frmt.string(for: NSNumber(value: Double(totalAmount / 100)))!)\n"
        result += "You earned \(volumeCredits) credits\n"
        return result
    }
    
    private func amountFor(performance: Performance, genre: Play.Genre) throws -> Int {
        var thisAmount = 0
        
        switch(genre) {
        case .tragedy:
            thisAmount = 40000
            if (performance.audience > 30) {
                thisAmount += 1000 * (performance.audience - 30)
            }
            
        case .comedy:
            thisAmount = 30000
            if (performance.audience > 20) {
                thisAmount += 10000 + 500 * (performance.audience - 20)
            }
            thisAmount += 300 * performance.audience
        case .unknown:
            throw UnknownTypeError.unknownTypeError("unknown type: \(genre)")
        }
        
        return thisAmount
    }
}

enum UnknownTypeError: Error, Equatable {
    case unknownTypeError(String)
}

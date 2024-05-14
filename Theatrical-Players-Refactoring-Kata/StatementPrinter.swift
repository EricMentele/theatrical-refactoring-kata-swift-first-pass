class StatementPrinter {
    func generateStatement(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> String {
        var totalAmount = 0
        var volumeCredits = 0
        var result = "Statement for \(invoice.customer)\n"
        
        let frmt = NumberFormatter()
        frmt.numberStyle = .currency
        frmt.locale = Locale(identifier: "en_US")
        
        for performance in invoice.performances {
            var thisAmount = 0
            guard let play = plays[performance.playID] else {
                throw UnknownTypeError.unknownTypeError("unknown play")
            }
            
            switch (play.type) {
            case "tragedy" :
                    thisAmount = 40000
                    thisAmount += costFor(audienceSize: performance.audience)
            case "comedy" :
                    thisAmount = 30000
                    if (performance.audience > 20) {
                        thisAmount += 10000 + 500 * (performance.audience - 20)
                    }
                    thisAmount += 300 * performance.audience
            
            default : 
                throw UnknownTypeError.unknownTypeError("unknown type: \(play.type)")
            }
            
            // add volume credits
            volumeCredits += max(performance.audience - 30, 0)
            // add extra credit for every ten comedy attendees
            if ("comedy" == play.type) {
                volumeCredits += Int(round(Double(performance.audience / 5)))
            }
            
            // print line for this order
            result += "  \(play.name): \(frmt.string(for: NSNumber(value: Double((thisAmount / 100))))!) (\(performance.audience) seats)\n"
            
            totalAmount += thisAmount
        }
        result += "Amount owed is \(frmt.string(for: NSNumber(value: Double(totalAmount / 100)))!)\n"
        result += "You earned \(volumeCredits) credits\n"
        return result
    }
}

private func costFor(audienceSize: Int) -> Int {
    switch audienceSize {
        case 30...: return 1000 * (audienceSize - 30)
        case 20: return 30000
        case 10: return 3000
        default: return 0
    }
}

enum UnknownTypeError: Error, Equatable {
    case unknownTypeError(String)
}

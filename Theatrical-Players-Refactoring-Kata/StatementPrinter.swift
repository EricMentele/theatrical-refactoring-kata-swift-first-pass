class StatementPrinter {
    func generateStatement(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> String {
        try renderPlainText(generateStatementData(invoice, plays))
    }
    
    func generateStatementHTML(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> String {
        try renderHTML(generateStatementData(invoice, plays))
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
    }
    
    private func renderHTML(_ data: StatementData) throws -> String {
        var result = "<h1>Statement for \(data.customer)</h1>\n"
        result += "<table>\n"
        result += "<tr><th>play</th><th>seats</th><th>cost</th></tr>"
        for perf in data.performanceCharges {
            result += "<tr><td>\(perf.playName)</td><td>\(perf.attendanceCount)</td>"
            result += "<td>\(usd(amount: perf.cost))</td></tr>\n"
        }
        result += "</table>\n"
        result += "<p>Amount owed is <em>\(usd(amount: data.totalAmount))</em></p>\n"
        result += "<p>You earned <em>\(data.totalVolumeCredits)</em> credits</p>\n"
        return result
    }
    
    private func usd(amount: Int) -> String {
        let frmt = NumberFormatter()
        frmt.numberStyle = .currency
        frmt.locale = Locale(identifier: "en_US")
        return frmt.string(for: NSNumber(value: Double(amount / 100)))!
    }
}

enum UnknownTypeError: Error, Equatable {
    case unknownTypeError(String)
}

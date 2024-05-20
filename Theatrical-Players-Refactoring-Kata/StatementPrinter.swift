class StatementPrinter {
    func generateStatement(_ invoice: Invoice, _ plays: Dictionary<String, Play>) throws -> String {
        return try renderPlainText(generateStatementData(invoice, plays))
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

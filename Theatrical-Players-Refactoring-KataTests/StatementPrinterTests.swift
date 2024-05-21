
import XCTest
@testable import Theatrical_Players_Refactoring_Kata

class StatementPrinterTests: XCTestCase {
    func test_generateStatement_producesStatmentForKnownPlays() throws {
        let expected = """
            Statement for BigCo
              Hamlet: $650.00 (55 seats)
              As You Like It: $580.00 (35 seats)
              Othello: $500.00 (40 seats)
            Amount owed is $1,730.00
            You earned 47 credits

            """
        
        let statementPrinter = StatementPrinter()
        let result = try statementPrinter.generateStatement(invoiceWithKnownPlays(), knownPlays())
        
        XCTAssertEqual(result, expected)
    }
    
    func test_generateStatement_throwsErrorOnNewPlayTypes() {
        let statementPrinter = StatementPrinter()
        
        let expectedError = UnknownTypeError.unknownTypeError("new play")
        
        var unknownPlayError: UnknownTypeError?
        do {
            let _ = try statementPrinter.generateStatement(invoiceWithNewPlay(), newPlay())
        } catch let error as UnknownTypeError {
            unknownPlayError = error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        XCTAssertEqual(unknownPlayError, expectedError)
    }
    
    func test_generateStatement_throwsErrorOnUknownPlay() {
        let plays = [
            "hamlet": Play(name: "Hamlet", genre: .tragedy),
            "as-like": Play(name: "As You Like It", genre: .tragedy)
        ]
        let statementPrinter = StatementPrinter()
        let expectedError = UnknownTypeError.unknownTypeError("unknown play")
        
        var unknownPlayError: UnknownTypeError?
        do {
            let _ = try statementPrinter.generateStatement(invoiceWithKnownPlays(), plays)
        } catch let error as UnknownTypeError {
            unknownPlayError = error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        XCTAssertEqual(unknownPlayError, expectedError)
    }
    
    func test_generateStatementHTML_producesHTMLFormattedStatementForKnownPlays() throws {
        let expected = """
            <h1>Statement for BigCo</h1>
            <table>
            <tr><th>play</th><th>seats</th><th>cost</th></tr><tr><td>Hamlet</td><td>55</td><td>$650.00</td></tr>
            <tr><td>As You Like It</td><td>35</td><td>$580.00</td></tr>
            <tr><td>Othello</td><td>40</td><td>$500.00</td></tr>
            </table>
            <p>Amount owed is <em>$1,730.00</em></p>
            <p>You earned <em>47</em> credits</p>
            
            """
        
        let statementPrinter = StatementPrinter()
        let result = try statementPrinter.generateStatementHTML(invoiceWithKnownPlays(), knownPlays())
        XCTAssertEqual(result, expected)
    }
}

extension StatementPrinterTests {
    func knownPlays() -> Dictionary<String, Play> {
        [
            "hamlet": Play(name: "Hamlet", genre: .tragedy),
            "as-like": Play(name: "As You Like It", genre: .comedy),
            "othello": Play(name: "Othello", genre: .tragedy)
        ]
    }
    
    func newPlay() -> Dictionary<String, Play> {
        [
            "henry-v": Play(name: "Henry V", genre: .unknown),
            "as-like": Play(name: "As You Like It", genre: .unknown)
        ]
    }
    
    func invoiceWithKnownPlays() -> Invoice {
        Invoice(
            customer: "BigCo", performances: [
                Performance(playID: "hamlet", audience: 55),
                Performance(playID: "as-like", audience: 35),
                Performance(playID: "othello", audience: 40)
            ]
        )
    }
    
    func invoiceWithNewPlay() -> Invoice {
        Invoice(
            customer: "BigCo", 
            performances: [
                Performance(playID: "henry-v", audience: 53),
                Performance(playID: "as-like", audience: 55)
            ]
        )
    }
}

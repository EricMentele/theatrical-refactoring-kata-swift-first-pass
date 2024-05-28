import XCTest
@testable import Theatrical_Players_Refactoring_Kata

final class LineItemProviderTests: XCTestCase {
    // MARK: - Success
    func test_cost_returnsCorrectPerformanceCost() throws {
        let genreBaseCosts: [(Play.Genre, Int)] = Play.Genre.allCases
            .compactMap {
                switch $0 {
                case .tragedy:
                    return ($0, 40000)
                case .comedy:
                    return ($0, 36000)
                case .pastoral:
                    return ($0, 30)
                case .unknown:
                    return nil
                }
            }
        
        try genreBaseCosts.forEach { (genre, expectedCost) in
            self.expect(
                try LineItemProvider().cost(for: genre),
                withAttendanceCount: genre.costBaseVolumeAttendanceCount,
                toBe: expectedCost
            )
        }
    }
    
    func test_cost_returnsAdditionalVolumeAttendanceCountPerformanceCost() throws {
        let genreAdditionalVolumeCosts: [(Play.Genre, Int)] = Play.Genre.allCases
            .compactMap {
                switch $0 {
                case .tragedy:
                    return ($0, 41000)
                case .comedy:
                    return ($0, 46800)
                case .pastoral:
                    return ($0, 30)
                case .unknown:
                    return nil
                }
            }
        
        try genreAdditionalVolumeCosts.forEach { (genre, expectedCost) in
            self.expect(
                try LineItemProvider().cost(for: genre),
                withAttendanceCount: genre.additionalVolumeAttendanceCount,
                toBe: expectedCost
            )
        }
    }
    
    // MARK: Volume Credits
    
    func test_volumeCredits_returnsCorrectAmountWithBaseAudienceCount() {
        let genresForVolumeCredits: [(Play.Genre, Int)] = Play.Genre.allCases
            .compactMap {
                switch $0 {
                case .tragedy, .pastoral:
                    return ($0, 0)
                case .comedy:
                    return ($0, 6)
                case .unknown:
                    return nil
                }
            }
        
        genresForVolumeCredits.forEach { (genre, expectedAmount) in
            self.expect(
                LineItemProvider().volumeCredits(for: genre),
                withAttendanceCount: 30,
                toBe: expectedAmount
            )
        }
    }
    
    func test_volumeCredits_returnsCorrectAmountForTragedy() {
        let sut = LineItemProvider()
        let genre: Play.Genre = .tragedy
        let expected = 1
        
        let actual = sut.volumeCredits(for: genre).amountFor(attendanceCount: genre.additionalVolumeAttendanceCount)
        
        XCTAssertEqual(expected, actual)
    }
    
    func test_volumeCredits_returnsCorrectAmountForComedy() {
        let sut = LineItemProvider()
        let genre: Play.Genre = .comedy
        let expected = 4
        
        let actual = sut.volumeCredits(for: genre).amountFor(attendanceCount: genre.additionalVolumeAttendanceCount)
        
        XCTAssertEqual(expected, actual)
    }
    
    // MARK: - Errors
    
    func test_costFor_throwsNewPlayErrorOnUknownGenre() throws {
        let sut = LineItemProvider()
        
        XCTAssertThrowsError(try sut.cost(for: .unknown))
    }
}

private extension LineItemProviderTests {
    func expect(_ lineItemTotal: LineItemTotal, withAttendanceCount count: Int, toBe amount: Int, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(lineItemTotal.amountFor(attendanceCount: count), amount, "Wrong cost for \(lineItemTotal) with attendance of \(count)")
    }
}

private extension Play.Genre {
    var costBaseVolumeAttendanceCount: Int {
        switch self {
        case .tragedy:
            return 30
        case .comedy:
            return 20
        case .pastoral:
            return 0
        case .unknown:
            return 0
        }
    }
    
    var additionalVolumeAttendanceCount: Int {
        costBaseVolumeAttendanceCount + 1
    }
}

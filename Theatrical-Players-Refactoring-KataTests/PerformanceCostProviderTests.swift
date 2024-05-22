import XCTest
@testable import Theatrical_Players_Refactoring_Kata

final class PerformanceCostProviderTests: XCTestCase {
    func test_cost_returnsCorrectPerformanceCost() throws {
        let genreBaseCosts: [(Play.Genre, Int)] = [
            (.tragedy, 40000),
            (.comedy, 36000)
        ]
        
        try genreBaseCosts.forEach { (genre, expectedCost) in
            self.expect(
                try PerformanceCostProvider().cost(for: genre),
                withAttendanceCount: genre.baseVolumeAttendanceCount,
                toBe: expectedCost
            )
        }
    }
    
    func test_cost_returnsAdditionalVolumeAttendanceCountPerformanceCost() throws {
        let genreBaseCosts: [(Play.Genre, Int)] = [
            (.tragedy, 41000),
            (.comedy, 46800)
        ]
        
        try genreBaseCosts.forEach { (genre, expectedCost) in
            self.expect(
                try PerformanceCostProvider().cost(for: genre),
                withAttendanceCount: genre.additionalVolumeAttendanceCount,
                toBe: expectedCost
            )
        }
    }
    
    // MARK: Errors
    
    func test_costFor_throwsNewPlayErrorOnUknownGenre() throws {
        let sut = PerformanceCostProvider()
        
        XCTAssertThrowsError(try sut.cost(for: .unknown))
    }
}

private extension PerformanceCostProviderTests {
    func expect(_ cost: PerformanceCost, withAttendanceCount count: Int, toBe expectedCost: Int, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(cost.amountFor(attendanceCount: count), expectedCost, "Wrong cost for \(cost) with attendance of \(count)")
    }
}

private extension Play.Genre {
    var baseVolumeAttendanceCount: Int {
        switch self {
        case .tragedy:
            return 30
        case .comedy:
            return 20
        case .unknown:
            return 0
        }
    }
    
    var additionalVolumeAttendanceCount: Int {
        baseVolumeAttendanceCount + 1
    }
}

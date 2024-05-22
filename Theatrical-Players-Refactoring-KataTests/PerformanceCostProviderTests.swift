import XCTest
@testable import Theatrical_Players_Refactoring_Kata

struct PerformanceCostProvider {
    func costFor(_ genre: Play.Genre, attendanceCount: Int) throws -> Int {
        var result = 0
        
        switch(genre) {
        case .tragedy:
            result = 40000
            if (attendanceCount > 30) {
                result += 1000 * (attendanceCount - 30)
            }
        case .comedy:
            result = 30000
            if (attendanceCount > 20) {
                result += 10000 + 500 * (attendanceCount - 20)
            }
            result += 300 * attendanceCount
        case .unknown:
            throw UnknownTypeError.unknownTypeError("new play")
        }
        
        return result
    }
}

final class PerformanceCostProviderTests: XCTestCase {
    func test_costFor_returnsCostForTragedy() throws {
        let sut = PerformanceCostProvider()
        let genre: Play.Genre = .tragedy
        let expectedCost = 40000
        
        let result = try sut.costFor(genre, attendanceCount: genre.baseVolumeAttendanceCount)
        
        XCTAssertEqual(result, expectedCost)
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
}

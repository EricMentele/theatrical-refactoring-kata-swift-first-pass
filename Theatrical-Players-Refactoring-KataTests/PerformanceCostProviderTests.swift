import XCTest
@testable import Theatrical_Players_Refactoring_Kata

final class PerformanceCostProviderTests: XCTestCase {
    // MARK: Tragedy
    func test_costFor_returnsCostForTragedy() throws {
        let sut = PerformanceCostProvider()
        let genre: Play.Genre = .tragedy
        let expectedCost = 40000
        
        let result = try sut.costFor(genre, attendanceCount: genre.baseVolumeAttendanceCount)
        
        XCTAssertEqual(result, expectedCost)
    }
    
    func test_costFor_returnsAdditionalVolumeCostForTragedy() throws {
        let sut = PerformanceCostProvider()
        let genre: Play.Genre = .tragedy
        let expectedCost = 41000
        
        let result = try sut.costFor(genre, attendanceCount: genre.additionalVolumeAttendanceCount)
        
        XCTAssertEqual(result, expectedCost)
    }
    
    // MARK: Comedy
    func test_costFor_returnsCostForComedy() throws {
        let sut = PerformanceCostProvider()
        let genre: Play.Genre = .comedy
        let expectedCost = 36000
        
        let result = try sut.costFor(genre, attendanceCount: genre.baseVolumeAttendanceCount)
        
        XCTAssertEqual(result, expectedCost)
    }
    
    func test_costFor_returnsAdditionalVolumeCostForComedy() throws {
        let sut = PerformanceCostProvider()
        let genre: Play.Genre = .comedy
        let expectedCost = 46800
        
        let result = try sut.costFor(genre, attendanceCount: genre.additionalVolumeAttendanceCount)
        
        XCTAssertEqual(result, expectedCost)
    }
    
    // MARK: Unknown
    func test_costFor_throwsNewPlayErrorOnUknownGenre() throws {
        let sut = PerformanceCostProvider()
        
        XCTAssertThrowsError(try sut.costFor(.unknown, attendanceCount: 100))
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

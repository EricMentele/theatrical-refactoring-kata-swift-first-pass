protocol PerformanceCost {
    func amountFor(attendanceCount count: Int) -> Int
}

struct PerformanceCostProvider {
    func cost(for genre: Play.Genre) throws -> PerformanceCost {
        switch(genre) {
        case .tragedy:
            return TragedyPerformanceCost()
        case .comedy:
            return ComedyPerformanceCost()
        case .unknown:
            throw UnknownTypeError.unknownTypeError("new play")
        }
    }
    
    struct TragedyPerformanceCost: PerformanceCost {
        func amountFor(attendanceCount count: Int) -> Int {
            let baseVolume = 30
            let exceededBaseVolume = count > baseVolume
            let additionalVolumeCost = exceededBaseVolume ? 1000 * (count - baseVolume) : 0
            return 40000 + additionalVolumeCost
        }
    }
    
    struct ComedyPerformanceCost: PerformanceCost {
        func amountFor(attendanceCount count: Int) -> Int {
            let baseVolume = 20
            let exceededBaseVolume = count > baseVolume
            let additionalVolumeCost = exceededBaseVolume ? 10000 + 500 * (count - baseVolume) : 0
            return 30000 + additionalVolumeCost + 300 * count
        }
    }
}

protocol LineItemTotal {
    func amountFor(attendanceCount count: Int) -> Int
}

struct LineItemProvider {
    func cost(for genre: Play.Genre) throws -> LineItemTotal {
        switch(genre) {
        case .tragedy:
            return TragedyCost()
        case .comedy:
            return ComedyCost()
        case .pastoral:
            return PastoralCost()
        case .unknown:
            throw UnknownTypeError.unknownTypeError("new play")
        }
    }
    
    func volumeCredits(for genre: Play.Genre) -> LineItemTotal {
        return DefaultVolumeCredits()
    }
    
    // MARK: Line Items
    
    struct TragedyCost: LineItemTotal {
        func amountFor(attendanceCount count: Int) -> Int {
            let baseVolume = 30
            let exceededBaseVolume = count > baseVolume
            let additionalVolumeCost = exceededBaseVolume ? 1000 * (count - baseVolume) : 0
            return 40000 + additionalVolumeCost
        }
    }
    
    struct ComedyCost: LineItemTotal {
        func amountFor(attendanceCount count: Int) -> Int {
            let baseVolume = 20
            let exceededBaseVolume = count > baseVolume
            let additionalVolumeCost = exceededBaseVolume ? 10000 + 500 * (count - baseVolume) : 0
            return 30000 + additionalVolumeCost + 300 * count
        }
    }
    
    struct PastoralCost: LineItemTotal {
        func amountFor(attendanceCount count: Int) -> Int {
            return 30
        }
    }
    
    struct DefaultVolumeCredits: LineItemTotal {
        func amountFor(attendanceCount count: Int) -> Int {
            return 0
        }
        
        
    }
}

import Foundation
import ReactiveSwift
import CombineSchedulers

public class OriginalDelayer {

    public private(set) var recorded = ""

    public func recordDelayed(_ string: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            recorded = string
        }
    }
}

public class CombineDelayer {

    public private(set) var recorded = ""

    private let scheduler: AnySchedulerOf<DispatchQueue>

    public init(scheduler: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()) {
        self.scheduler = scheduler
    }

    public func recordDelayed(_ string: String) {
        scheduler.schedule(after: scheduler.now.advanced(by: 1)) { [self] in
            recorded = string
        }
    }
}

public class ReactiveSwiftDelayer {

    public private(set) var recorded = ""

    public func recordDelayed(_ string: String) {
        // ReactiveScheduler.main is a global variable that can be changed in unit tests
        ReactiveScheduler.main.schedule(in: 1) { [self] in
            recorded = string
        }
    }
}



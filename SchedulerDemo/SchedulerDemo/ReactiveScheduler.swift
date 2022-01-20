import Foundation
import ReactiveSwift

/// This is helper to class to introduce a global variable `ReactiveScheduler.main`
/// This can be used to avoid other methods of Dependency Injection.
/// Use the properties of this class instead of ReactiveSwift schedulers directly.
/// Then in unit tests easily `TestScheduler` instances can be used.
public class ReactiveScheduler {

    // MARK: - Public properties

    /// Use this whenever you usually would use `QueueScheduler.main`
    /// When run in the context of a unit test, this might be a `TestScheduler`, same instance as `test`
    public static var main: DateScheduler {
        return test ?? QueueScheduler.main
    }

    // MARK: - Properties for unit tests

    private (set) static var test: TestScheduler?

    // MARK: - Functions for unit tests

    /// Call this in the `setUp()` method of a unit test using `test` scheduler. Don't forget to call `tearDownTest()` later on.
    @discardableResult static func setUpTest(startDate: Date = Date()) -> TestScheduler {
        assert(ProcessInfo.isTest)
        let scheduler = TestScheduler(startDate: startDate)
        test = scheduler
        return scheduler
    }

    /// Call this in the `tearDown()` method of a unit test using `test` scheduler.
    static func tearDownTest() {
        test = nil
    }
}

extension DateScheduler {
    /// Schedules an action for execution at or after the given date.
    ///
    /// - parameters:
    ///   - timerInterval: Starting date will be currentTime + timeInterval.
    ///   - action: A closure of the action to perform.
    ///
    /// - returns: Optional disposable that can be used to cancel the work
    ///            before it begins.
    @discardableResult
    public func schedule(in timeInterval: TimeInterval, action: @escaping () -> Void) -> Disposable? {
        schedule(after: currentDate.addingTimeInterval(timeInterval), action: action)
    }
}

fileprivate extension ProcessInfo {

    /// Returns `true` when run during a test, returns `false` if not.
    static var isTest: Bool {
        processInfo.environment.keys.contains("XCTestConfigurationFilePath")
    }
}


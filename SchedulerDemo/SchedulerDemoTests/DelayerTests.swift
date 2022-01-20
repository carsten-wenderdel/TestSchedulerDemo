import XCTest
@testable import SchedulerDemo

class DelayerTests: XCTestCase {

    func testOriginalDelayer() throws {
        // Given

        // Pick any of three Delayers - the test works with all of them.
        let classUnderTest = OriginalDelayer()
//        let classUnderTest = CombineDelayer()
//        let classUnderTest = ReactiveSwiftDelayer()


        // When
        let exp1 = XCTestExpectation(description: "")
        let exp2 = XCTestExpectation(description: "")

        classUnderTest.recordDelayed("testString")

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(classUnderTest.recorded, "")
            exp1.fulfill()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            XCTAssertEqual(classUnderTest.recorded, "testString")
            exp2.fulfill()
        }

        wait(for: [exp1, exp2], timeout: 2)
    }


    func testCombineDelayer() throws {
        // Set up for this test only:
        let testScheduler = DispatchQueue.test

        // Given
        let classUnderTest = CombineDelayer(scheduler: testScheduler.eraseToAnyScheduler())

        // When
        classUnderTest.recordDelayed("testString")

        testScheduler.advance(by: 0.5)
        XCTAssertEqual(classUnderTest.recorded, "")

        testScheduler.advance(by: 0.7)
        XCTAssertEqual(classUnderTest.recorded, "testString")
    }


    func testReactiveSwiftDelayer() throws {
        // Set up for this test only.
        // This changes the global variable ReactiveScheduler.main
        let testScheduler = ReactiveScheduler.setUpTest()

        // Given
        let classUnderTest = ReactiveSwiftDelayer()

        // When
        classUnderTest.recordDelayed("testString")

        // Then
        testScheduler.advance(by: 0.5)
        XCTAssertEqual(classUnderTest.recorded, "")

        testScheduler.advance(by: 0.7)
        XCTAssertEqual(classUnderTest.recorded, "testString")

        // Tear down for this test only:
        ReactiveScheduler.tearDownTest()
    }
}

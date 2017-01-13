import XCTest
@testable import Perfect_ToDo_iOS_Demo

class Perfect_ToDo_iOS_DemoTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Perfect_ToDo_iOS_Demo().text, "Hello, World!")
    }


    static var allTests : [(String, (Perfect_ToDo_iOS_DemoTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}

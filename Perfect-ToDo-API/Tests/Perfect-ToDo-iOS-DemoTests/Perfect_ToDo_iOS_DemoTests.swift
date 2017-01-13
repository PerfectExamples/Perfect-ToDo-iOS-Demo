import XCTest
import Foundation
@testable import SwiftSQL

class Perfect_ToDo_iOS_DemoTests: XCTestCase {
    
    func testDates() {
        
        let date = Date()
        let sqlDate = getSQLDateTime(date)
        let swiftDate = getDate(fromSQLDateTime: sqlDate)
        
        XCTAssertNotNil(swiftDate)
        
    }


    static var allTests : [(String, (Perfect_ToDo_iOS_DemoTests) -> () throws -> Void)] {
        return [
            ("dates", testDates),
        ]
    }
}

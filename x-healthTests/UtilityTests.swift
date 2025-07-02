import XCTest
@testable import x_health

final class UtilityTests: XCTestCase {
    func testDateFormatterMediumStyle() {
        XCTAssertEqual(dateFormatter.dateStyle, .medium)
    }
}

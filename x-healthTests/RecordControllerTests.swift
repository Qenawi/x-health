import XCTest
@testable import x_health

final class RecordControllerTests: XCTestCase {
    func testAddRecord() {
        let controller = RecordController()
        XCTAssertTrue(controller.records.isEmpty)

        let doctor = Doctor(name: "Dr. Jones", lastVisit: Date())
        let record = MedicalRecord(type: .doctorVisit,
                                   date: Date(),
                                   notes: "Checkup",
                                   doctor: doctor)

        controller.addRecord(record)

        XCTAssertEqual(controller.records.count, 1)
        XCTAssertTrue(controller.records.first === record)
    }
}

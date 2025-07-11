import XCTest
@testable import x_health

final class ModelsTests: XCTestCase {
    func testDoctorEncodingDecoding() throws {
        let doctor = Doctor(name: "Dr. Jane", lastVisit: Date())
        let data = try JSONEncoder().encode(doctor)
        let decoded = try JSONDecoder().decode(Doctor.self, from: data)
        XCTAssertEqual(doctor, decoded)
    }

    func testTagEncodingDecoding() throws {
        let tag = Tag(name: "Important", colorHex: "#FF0000")
        let data = try JSONEncoder().encode(tag)
        let decoded = try JSONDecoder().decode(Tag.self, from: data)
        XCTAssertEqual(tag, decoded)
    }
    func testMedicationEncodingDecoding() throws {
        let med = Medication(name: "Aspirin", dosage: "1 pill", reminderTime: Date(), startDate: Date(), endDate: Date().addingTimeInterval(3600))
        let data = try JSONEncoder().encode(med)
        let decoded = try JSONDecoder().decode(Medication.self, from: data)
        XCTAssertEqual(med.name, decoded.name)
        XCTAssertEqual(med.dosage, decoded.dosage)
    }
}

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
        let dose = MedicationDose(time: Date(), strength: "500mg", quantity: 1)
        let med = Medication(name: "Aspirin", dosage: "tablet", doses: [dose], startDate: Date(), endDate: Date().addingTimeInterval(3600), supplyCount: 30, refillThreshold: 5)
        let data = try JSONEncoder().encode(med)
        let decoded = try JSONDecoder().decode(Medication.self, from: data)
        XCTAssertEqual(med.name, decoded.name)
        XCTAssertEqual(med.dosage, decoded.dosage)
        XCTAssertEqual(decoded.doses.count, 1)
    }

    func testMarkDoseTakenUpdatesSupply() throws {
        let dose = MedicationDose(time: Date(), strength: "500mg", quantity: 1)
        let med = Medication(name: "Ibuprofen", dosage: "tablet", doses: [dose], startDate: Date(), endDate: Date().addingTimeInterval(3600), supplyCount: 5, refillThreshold: 1)
        med.mark(dose: dose, status: .taken)
        XCTAssertEqual(med.doses.first?.status, .taken)
        XCTAssertEqual(med.supplyCount, 4)
    }

    func testResetForNewDaySetsPending() {
        let dose = MedicationDose(time: Date(), strength: "5mg", quantity: 1, status: .taken)
        let med = Medication(name: "Test", dosage: "pill", doses: [dose], startDate: Date(), endDate: Date())
        med.lastReset = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        med.resetForNewDay()
        XCTAssertEqual(med.doses.first?.status, .pending)
    }
}

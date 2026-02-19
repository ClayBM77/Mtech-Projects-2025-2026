//
//  RepresentativeTests.swift
//  RepresentativeTests
//
//  Created by Bridger Mason on 1/26/26.
//

import XCTest
@testable import RandomAPIs
@MainActor
final class RepresentativeTests: XCTestCase {
    
    func testStubAPIControllerReturnsPredeterminedData() async throws {
        // Arrange
        let stubController = StubAPIController()
        let testZip = "12345"
        
        // Act
        let results = try await stubController.search(byZip: testZip)
        let comparison = Representative(
            name: "Bridger Mason",
            party: "definitely likes parties",
            state: "UT",
            district: "13",
            phone: "1",
            office: "just down the road from here",
            link: "lds.org"
        )
        // Assert
        let result = results.first
        XCTAssertEqual(result, comparison)
    }
    
    func testFakeAPIControllerThrowsError() async {
        // Arrange
        let fakeController = FakeAPIController()
        let testZip = "12345"
        
        // Act & Assert
        do {
            _ = try await fakeController.search(byZip: testZip)
            XCTFail("Expected FakeAPIController to throw an error, but it didn't")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }

}

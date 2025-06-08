//
//  TestTaskTests.swift
//  TestTaskTests
//
//  Created by Пользователь on 07.06.2025.
//

import XCTest
@testable import TestTask

final class TestTaskTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testExample() throws {}

    func testPerformanceExample() throws {
        self.measure {        }
    }

}

class APIServiceTests: XCTestCase {
    
    var apiService: EnhancedAPIService!
    
    override func setUp() {
        super.setUp()
        apiService = EnhancedAPIService.shared
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func testFetchUsers() async throws {
        let response = try await apiService.fetchUsers(page: 1, count: 6)
        
        XCTAssertTrue(response.success)
        XCTAssertLessThanOrEqual(response.users.count, 6)
        XCTAssertGreaterThan(response.totalUsers, 0)
    }
    
    func testFetchPositions() async throws {
        let response = try await apiService.fetchPositions()
        
        XCTAssertTrue(response.success)
        XCTAssertGreaterThan(response.positions.count, 0)
        
        // Verify position structure
        let firstPosition = response.positions.first!
        XCTAssertGreaterThan(firstPosition.id, 0)
        XCTAssertFalse(firstPosition.name.isEmpty)
    }
    
    func testInvalidPageNumber() async {
        do {
            _ = try await apiService.fetchUsers(page: -1, count: 6)
            XCTFail("Should throw error for invalid page number")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
}


class ValidationTests: XCTestCase {
    
    func testEmailValidation() {
        // Valid emails
        XCTAssertTrue(ValidationUtilities.validateEmail("test@example.com"))
        XCTAssertTrue(ValidationUtilities.validateEmail("user.name+tag@domain.co.uk"))
        XCTAssertTrue(ValidationUtilities.validateEmail("valid_email@test-domain.org"))
        
        // Invalid emails
        XCTAssertFalse(ValidationUtilities.validateEmail("invalid.email"))
        XCTAssertFalse(ValidationUtilities.validateEmail("@domain.com"))
        XCTAssertFalse(ValidationUtilities.validateEmail("test@"))
        XCTAssertFalse(ValidationUtilities.validateEmail("test@domain"))
        XCTAssertFalse(ValidationUtilities.validateEmail(""))
    }
    
    func testPhoneValidation() {
        // Valid phones
        XCTAssertTrue(ValidationUtilities.validatePhone("+380123456789"))
        XCTAssertTrue(ValidationUtilities.validatePhone("+380 12 345 67 89"))
        XCTAssertTrue(ValidationUtilities.validatePhone("+380(12)345-67-89"))
        
        // Invalid phones
        XCTAssertFalse(ValidationUtilities.validatePhone("+38012345678")) // Too short
        XCTAssertFalse(ValidationUtilities.validatePhone("+3801234567890")) // Too long
        XCTAssertFalse(ValidationUtilities.validatePhone("380123456789")) // Missing +
        XCTAssertFalse(ValidationUtilities.validatePhone("+480123456789")) // Wrong country code
        XCTAssertFalse(ValidationUtilities.validatePhone(""))
    }
    
    func testPhoneFormatting() {
        let unformatted = "380123456789"
        let formatted = ValidationUtilities.formatPhoneNumber(unformatted)
        XCTAssertEqual(formatted, "+380 (12) 345 67 89")
        
        // Already formatted should remain the same
        let alreadyFormatted = "+380 (12) 345 67 89"
        XCTAssertEqual(ValidationUtilities.formatPhoneNumber(alreadyFormatted), alreadyFormatted)
    }
}

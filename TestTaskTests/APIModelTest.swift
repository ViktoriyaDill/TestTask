//
//  APIModelTest.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import XCTest
@testable import TestTask


class ModelTests: XCTestCase {
    
    func testUserDecoding() throws {
        let json = """
        {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com",
            "phone": "+380123456789",
            "position": "Developer",
            "position_id": 1,
            "registration_timestamp": 1640995200,
            "photo": "https://example.com/photo.jpg"
        }
        """
        
        let data = json.data(using: .utf8)!
        let user = try JSONDecoder().decode(User.self, from: data)
        
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.email, "john@example.com")
        XCTAssertEqual(user.phone, "+380123456789")
        XCTAssertEqual(user.position, "Developer")
        XCTAssertEqual(user.positionId, 1)
        XCTAssertEqual(user.registrationTimestamp, 1640995200)
        XCTAssertEqual(user.photo, "https://example.com/photo.jpg")
    }
    
    func testUsersResponseDecoding() throws {
        let json = """
        {
            "success": true,
            "total_pages": 10,
            "total_users": 100,
            "count": 6,
            "page": 1,
            "links": {
                "next_url": "https://example.com/api/users?page=2",
                "prev_url": null
            },
            "users": []
        }
        """
        
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(UsersResponse.self, from: data)
        
        XCTAssertTrue(response.success)
        XCTAssertEqual(response.totalPages, 10)
        XCTAssertEqual(response.totalUsers, 100)
        XCTAssertEqual(response.count, 6)
        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.links.nextUrl, "https://example.com/api/users?page=2")
        XCTAssertNil(response.links.prevUrl)
        XCTAssertEqual(response.users.count, 0)
    }
    
    func testPositionDecoding() throws {
        let json = """
        {
            "id": 1,
            "name": "Frontend Developer"
        }
        """
        
        let data = json.data(using: .utf8)!
        let position = try JSONDecoder().decode(Position.self, from: data)
        
        XCTAssertEqual(position.id, 1)
        XCTAssertEqual(position.name, "Frontend Developer")
    }
}

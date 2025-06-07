//
//  Position.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import Foundation

struct Position: Codable, Identifiable {
    let id: Int
    let name: String
}

struct PositionsResponse: Codable {
    let success: Bool
    let positions: [Position]
}

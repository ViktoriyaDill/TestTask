//
//  AppConstants.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import Foundation


struct AppConstants {
    struct API {
        static let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
        static let pageSize = 6
        static let requestTimeout: TimeInterval = 30
    }
    
    struct Validation {
        static let minNameLength = 2
        static let maxNameLength = 60
        static let maxPhotoSizeMB = 5.0
        static let minPhotoSize = CGSize(width: 70, height: 70)
    }
    
    struct UI {
        static let splashDuration: TimeInterval = 2.0
        static let animationDuration: TimeInterval = 0.3
    }
}

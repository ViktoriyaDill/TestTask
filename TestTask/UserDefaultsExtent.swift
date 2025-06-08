//
//  UserDefaultsExtent.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import Foundation
import SwiftUI


extension UserDefaults {
    private enum Keys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let lastRefreshDate = "lastRefreshDate"
    }
    
    var hasSeenOnboarding: Bool {
        get { bool(forKey: Keys.hasSeenOnboarding) }
        set { set(newValue, forKey: Keys.hasSeenOnboarding) }
    }
    
    var lastRefreshDate: Date? {
        get { object(forKey: Keys.lastRefreshDate) as? Date }
        set { set(newValue, forKey: Keys.lastRefreshDate) }
    }
}

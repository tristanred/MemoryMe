//
//  PreferenceManager.swift
//  Memory Me
//
//  Created by Tristan Dube on 2019-03-20.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Foundation

/**
 * Manager for the player preferences. The user preferences are saved and can
 * persist across app sessions.
 *
 * This class is using the UserDefaults library instead of saving it in an
 * archive. We'll see how it goes.
 */
class PreferenceManager
{
    static var current: PreferenceManager = PreferenceManager();
    
    func GetAllowsTracking() -> Bool
    {
        return UserDefaults.standard.bool(forKey: "allows_tracking");
    }
    
    func SetAllowsTracking(toValue value: Bool)
    {
        UserDefaults.standard.set(value, forKey: "allows_tracking");
    }
}
